from sklearn.tree import DecisionTreeClassifier
from sklearn.ensemble import RandomForestClassifier
from sys import argv
import numpy as np
from sklearn.tree import DecisionTreeClassifier, export_graphviz
from sklearn.model_selection import cross_val_score
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score
import graphviz 
import os
from sklearn.tree import _tree
import copy
from copy import deepcopy
import gen_verilog as verilog
import sys
import boolean
from presets import *
import pandas as pd
from itertools import product
import sklearn.datasets as ds
from math import log
from math import ceil
from math import sqrt
from math import floor
from preprocessing import *
from sklearn.tree import *
from collections import Counter

def getStandaloneComps(bits_precision, useMappedComp):
	compsClassif = []
	with open("presynthesized_comps/comp_%d_map_%d.csv" % (bits_precision, useMappedComp), "r") as fIn:
		for line in fIn.readlines()[1:]:
			compsClassif.append(int(line.split(",")[-1]))

	return compsClassif


def simulErrorsApprox(dataset, period, testLabels, predictedByPy):

	np.savetxt("predictedByPy.txt", predictedByPy.astype(int), fmt='%d')

	np.savetxt("correctTest.txt", testLabels.astype(int), fmt='%d')

	os.system("cp %s/work/SIM_decision_%s_%s/predict.txt ." % (dirSynth, period, dataset))

	nrCorrects = 0
	ypredHdl = []
	nrInfs = 0
	with open("predict.txt","r") as fHdl:
		lines = fHdl.readlines()
		nrInfs = len(lines)
		for idx,line in enumerate(lines):
			classifPred = 0
			lLine = list(line.strip())
			if len(lLine) > 1:
				if "1" in lLine:
					classifPred = len(lLine) - 1 - lLine.index('1')
				else:
					classifPred = 0
			else:
				classifPred = lLine[0]

			if classifPred == int(testLabels.iloc[idx]):
				nrCorrects += 1

	acc = nrCorrects/nrInfs

	return acc


def genDatasetInputPower(dataset, inputs, testData):
	system("mkdir -p %s" % (folderInputsPower))
	system("mkdir -p %s/%s" % (folderInputsPower, dataset))
	system("mkdir -p %s" % (folderRandomInputs))
	system("mkdir -p %s/random" % (folderRandomInputs))

	for _input in inputs:
		if _input['name'] != 'CLK' and _input['name'] != 'RST':
			listBins = []
			strFormat = "{0:0%db}" % (int(_input['size']))

			for idx, elem in testData[_input['name']].items():
				listBins.append(strFormat.format(int(elem)))

			df2 = pd.Series(listBins)
			df2.to_csv("%s/%s/%s.txt" % (folderInputsPower, dataset, _input['name']), index = False, header = False)
			
			listBins = []
			
			if useRealInputs == 0:
				maxValFeat = 2**int(_input['size'])
				for idx in range(numRandomInputs):
					listBins.append(strFormat.format(np.random.randint(maxValFeat)))
			
				df2 = pd.Series(listBins)
				df2.to_csv("%s/random/%s.txt" % (folderRandomInputs, _input['name']), index = False, header = False)

	system("rm -rf %s/OUTPUT_DATASETS" % (dirSynth))
	system("mkdir -p %s/OUTPUT_DATASETS" % (dirSynth))
	#system("cp -r %s/%s %s/OUTPUT_DATASETS/" % (folderInputsPower, dataset, dirSynth))

	system("rm -rf OUTPUTS_RANDOM")
	system("rm -rf OUTPUTS_DATASETS")


def getAllComparisonsOrs(tree, featureSizes, whichOut = -1):
	tree_ = tree.tree_
	featureName = [featureSizes[i][0] if i != _tree.TREE_UNDEFINED else "undefined!" for i in tree_.feature]
	featureSize = [featureSizes[i][1] if i != _tree.TREE_UNDEFINED else "undefined!" for i in tree_.feature]

	comparisons = []

	ors = []

	def recurse(node, depth, expression):
		indent = "\t" * depth
		if tree_.feature[node] != _tree.TREE_UNDEFINED:
			name = featureName[node]
			threshold = tree_.threshold[node]
			_type = int(featureSize[node])
			nrSamples = tree_.n_node_samples[node]

			if [name, threshold, _type, depth, nrSamples] not in comparisons:
				comparisons.append([name, threshold, _type, depth, nrSamples])

			recurse(tree_.children_left[node], depth + 1, deepcopy(expression + [[name, threshold, _type, depth, nrSamples, 'true']]))

			recurse(tree_.children_right[node], depth + 1, deepcopy(expression + [[name, threshold, _type, depth, nrSamples, 'false']]))
		else:
			if whichOut == -1:
				if np.argmax(tree_.value[node]) == 1:
					ors.append(deepcopy(expression))
			else:
				if np.argmax(tree_.value[node]) == whichOut:
					ors.append(deepcopy(expression))

	recurse(0, 1, [])

	return comparisons, ors


def getSimplifiedExpression(tree, c, comparisons, ors):

	algebra = boolean.BooleanAlgebra()

	##### PARSE THE CONDITIONS INTO 'c%d' VALUES TO SIMPLIFY THEM USING BOOLEAN LIBRARY #####
	strExpr = ""

	if ors == []:
		isUsedInExpr = [0]*len(comparisons)
		return "0", isUsedInExpr
	
	for idxOr, elemOr in enumerate(ors):

		for idxAnd, elemAnd in enumerate(elemOr):

			idxElem = [x[:3] for x in comparisons].index(elemAnd[:3])
			notSymbol = "~" if elemAnd[5] == 'false' else ""
			condition = "%sc%s" % (notSymbol, idxElem)

			if idxOr == (len(ors) - 1):
				if len(elemOr) > 1:
					if idxAnd == 0 and idxAnd != (len(elemOr)-1):
						strExpr += '(%s&' % (condition)
					elif idxAnd == (len(elemOr)-1):
						strExpr += '%s)' % (condition)
					else:
						strExpr += '%s&' % (condition)
				else:
					strExpr += '%s' % (condition)
			else:
				if len(elemOr) > 1:
					if idxAnd == 0 and idxAnd != (len(elemOr)-1):
						strExpr += '(%s&' % (condition)
					elif idxAnd == (len(elemOr)-1):
						strExpr += '%s)|' % (condition)
					else:
						strExpr += '%s&' % (condition)
				else:
					strExpr += '%s|' % (condition)

	#########################################################################################
	simplExpr = algebra.parse(strExpr).simplify()

	isUsedInExpr = [1]*len(comparisons)

	for idx, comparison in enumerate(comparisons):
		if "c%s" % (idx) not in str(simplExpr):
			isUsedInExpr[idx] = 0

	return simplExpr, isUsedInExpr


def treeToHdl(clf, dataset, classifier, maxDepth, featureSizes, fHandler, fHandlerTb, fHandlerTbDebug, numTrees, bitsPrecision, approxTechnique, compsClassif = [], m = 0, nrBitsDC = 0):

	nrOut = outs[dataset]

	##### CREATE OUTPUTS VECTOR WITH ONE OUTPUT, WHICH WILL BE MAPPED TO VERILOG #####
	outputs = []
	output = {}
	output['name'] = 'decision'
	output['size'] = 1 if (nrOut == 2 and classifier == 'tree') else nrOut
	output['type'] = 'STD_LOGIC' if (nrOut == 2 and classifier == 'tree') else 'STD_LOGIC_VECTOR'

	outputs.append(output)
	###################################################################################

	# GET ALL COMPARISONS AND AND/OR PATHS IN THE TREE STRUCTURE #
	comparisons = {}
	ors = {}
	comparison = None
	_or = None
	c = {}

	for i in range(numTrees):
		comparisons[i] = []
		ors[i] = []
		for specOut in range(nrOut):
			if classifier == 'tree':
				comparison, _or = getAllComparisonsOrs(clf, featureSizes, specOut)
			elif classifier == 'forest':
				comparison, _or = getAllComparisonsOrs(clf[i], featureSizes, specOut)

			ors[i].append(_or)			

		comparisons[i] = comparison


	globalComparisons = []
	for i in range(numTrees):
		for comparison in comparisons[i]:
			if comparison[:3] not in [x[:3] for x in globalComparisons]:
				globalComparisons += [comparison]
			else:
				for idx,comp in enumerate(globalComparisons):
					if comp[:3] == comparison[:3]:
						if globalComparisons[idx][3] >= comparison[3]:
							globalComparisons[idx][3] = comparison[3]
						if globalComparisons[idx][4] >= comparison[4]:
							globalComparisons[idx][4] = comparison[4]

						break


	#############################################################


	# SIMPLIFY THE AND/OR EXPRESSIONS #
	algebra = boolean.BooleanAlgebra()

	c = [0]*numTrees
	expressions = {}
	isUsedInExprs = {}
	isUsedInExprsPerTree = {}
	strExprs = {}

	for i in range(numTrees):

		expressions[i] = []
		isUsedInExprs[i] = []
		isUsedInExprsPerTree[i] = [0]*len(globalComparisons)
		strExprs[i] = []

		for specOut in range(nrOut):
			c[i] = [0]*len(globalComparisons)
			for idx in range(len(globalComparisons)):
				c[i][idx] = algebra.symbols("c%d" % (idx))

			expression = []
			isUsedInExpr = []

			if classifier == 'tree':
				expression, isUsedInExpr = getSimplifiedExpression(clf, c[i], globalComparisons, ors[i][specOut])
			elif classifier == 'forest':
				expression, isUsedInExpr = getSimplifiedExpression(clf[i], c[i], globalComparisons, ors[i][specOut])

			expressions[i].append(expression)
			isUsedInExprs[i].append(isUsedInExpr)
			isUsedInExprsPerTree[i] = [(x or y) for x,y in zip(isUsedInExprsPerTree[i], isUsedInExpr)]
			strExprs[i].append(str(expression))

	isUsedInExprsGlobal = [0]*len(isUsedInExprsPerTree[0])

	for key in isUsedInExprsPerTree.keys():
		for idx, elem in enumerate(isUsedInExprsPerTree[key]):
			isUsedInExprsGlobal[idx] = elem or isUsedInExprsGlobal[idx]

	#################################

	##### CREATE INPUTS VECTOR WHOSE INPUTS ARE THE FEATURES USED IN THE TREE #####
	inputs = []
	existingInputs = []

	for i in range(numTrees):
		for idx, comparison in enumerate(globalComparisons):
			if comparison[0] not in existingInputs and isUsedInExprsGlobal[idx] == 1:
				existingInputs.append(comparison[0])
				_input = {}
				_input['name'] = comparison[0]
				_input['type'] = 'STD_LOGIC' if comparison[2] == 1 else 'STD_LOGIC_VECTOR'
				_input['size'] = comparison[2]
				inputs.append(_input)


	_input = {}
	_input['name'] = "CLK"
	_input['type'] = "STD_LOGIC"
	_input['size'] = 1
	inputs.append(deepcopy(_input))

	_input['name'] = "RST"
	_input['type'] = "STD_LOGIC"
	_input['size'] = 1
	inputs.append(deepcopy(_input))
	###############################################################################

	##### WRITE THE LIBRARY NAMES AND THE ENTITY, WITH INPUTS AND OUTPUTS #####
	verilog.gen_libraries(fHandler)
	verilog.gen_entity(fHandler, nameEntity, inputs, outputs)
	###########################################################################

	##### ASSIGN INPUTS AND OUTPUTS TO INTERNAL SIGNALS, WHICH WILL BE MAPPED TO VERILOG #####
	signals = []
	comparators = []
	existingComparisons = []

	for _input in inputs:
		signal = {}
		signal["name"] = "reg_%s" % (_input["name"])
		signal["size"] = _input["size"]
		signal["type"] = _input["type"]
		signals.append(deepcopy(signal))

	signal = {}
	signal["name"] = "reg_%s" % (outputs[0]["name"])
	signal["size"] = outputs[0]["size"]
	signal["type"] = outputs[0]["type"]
	signals.append(deepcopy(signal))
	########################################################################################



	# APPLY C2PAx #
	if approxTechnique == 0:
		if m > -1:
			for idx, comparison in enumerate(globalComparisons):
				if comparison[2] != bitsPrecision:
					continue

				prevCte = int(comparison[1])
				areaCurrCte = compsClassif[prevCte]
				currBestCte = prevCte

				for dist in range(1,m+1):
					candCte = prevCte - dist

					if (candCte >= 0) and (candCte < len(compsClassif)):
						areaCand = compsClassif[candCte]
					

						if areaCand < areaCurrCte:
							currBestCte = candCte
							areaCurrCte = areaCand

					candCte = prevCte + dist

					if (candCte >= 0) and (candCte < len(compsClassif)):
						areaCand = compsClassif[candCte]


						if areaCand < areaCurrCte:
							currBestCte = candCte
							areaCurrCte = areaCand

				globalComparisons[idx] = [comparison[0], float(currBestCte), comparison[2]]

	################

	# ASSIGN THE COMPARATORS FROM SK STRUCTURE IN DICTIONARIES, WHICH WILL BE MAPPED TO VERILOG #
	for i in range(numTrees):
		for idx, comparison in enumerate(globalComparisons):
			filteredComparison = "_".join([comparison[0], str(int(comparison[1])).replace(".","_")])

			if isUsedInExprsGlobal[idx] == 1 and filteredComparison not in existingComparisons:

				existingComparisons.append(filteredComparison)

				signal = {}
				signal["name"] = "comp_%s" % (filteredComparison)
				signal["size"] = 1
				signal["type"] = "STD_LOGIC"
				signals.append(deepcopy(signal))

				if "const_%s_%s" % (str(int(comparison[1])).replace(".","_"), str(comparison[2])) not in [existingSignal["name"].replace(".","_") for existingSignal in signals]:
					signal = {}
					signal["name"] = "const_%s_%s" % (str(int(comparison[1])).replace(".","_"), str(comparison[2]))

					for _input in inputs:
						if _input['name'] == comparison[0]:
							signal['type'] = _input["type"]
							signal["size"] = _input["size"]

							if approxTechnique == 1:
								if signal["size"] == bitsPrecision:
									signal["const_value"] = "%s%s" % (('{0:0%sb}' % (signal["size"])).format(int(comparison[1])).replace("-","")[:-nrBitsDC], "x"*nrBitsDC)
								else:
									signal["const_value"] = "%s" % (('{0:0%sb}' % (signal["size"])).format(int(comparison[1])).replace("-",""))
							else:
								signal["const_value"] = "%s" % (('{0:0%sb}' % (signal["size"])).format(int(comparison[1])).replace("-",""))
							signals.append(deepcopy(signal))

				comparator = {}
				comparator["in1"] = "reg_" + comparison[0]
				comparator["in2"] = "const_%s_%s" % (str(int(comparison[1])).replace(".","_"), str(comparison[2]))
				comparator["out"] = "comp_%s" % (filteredComparison)
				comparators.append(deepcopy(comparator))

	###########################################################################################

	exprs = []

	# GET SPECIFITIES OF THE MAJORITY GATE #
	if classifier == 'forest':
		sizeBitsAdd = int(ceil(log(numTrees+1,2)))
		nrCatBits = sizeBitsAdd - 1
		for _out in range(nrOut):
			signal = {}
			signal['name'] = 'add_%d' % (_out)
			signal['size'] = sizeBitsAdd
			signal['type'] = 'STD_LOGIC_VECTOR' if sizeBitsAdd > 1 else 'STD_LOGIC'
			signals.append(deepcopy(signal))

		for _out in range(nrOut):
			expr = {}
			expr['out'] = 'add_%d' % (_out)
			expr['op'] = '+'
			if nrCatBits > 1:
				expr['ops'] = ["{%d'b%s, or_%d}" % (nrCatBits, '0'*nrCatBits, x) for x in range(_out, nrOut*numTrees, nrOut)]
			else:
				expr['ops'] = ["{1'b0, or_%d}" % (x) for x in range(_out, nrOut*numTrees, nrOut)]
			exprs.append(deepcopy(expr))
			
		comps = []
		cmprsnsGlobal = []
		highestsGlobal = []
		groupings = 2
		l = ["add_%d" % (x) for x in range(nrOut)]
		cmprsns = [l[i:i+groupings] for i in range(0, len(l), groupings)]
		while len(cmprsns) > 1:
			nextCmprsns = []
			for elem in cmprsns:
				concatNrs = "_".join(["_".join(x.split("_")[1:]) for x in elem])
				if len(elem) < 2:
					nextCmprsns.append("add_%s" % (concatNrs))
					continue
				comp = {}
				comp['elems'] = elem

				highestsGlobal.append('add_%s' % (concatNrs))
				cmprsnsGlobal.append('comp_add_%s' % (concatNrs))
				idxs = []
	
				nextCmprsns.append("add_%s" % (concatNrs))
				comps.append(deepcopy(comp))
	
			cmprsns = [nextCmprsns[i:i+groupings] for i in range(0,len(nextCmprsns),groupings)]
	
		comp = {}
		comp['elems'] = cmprsns[0]
		comps.append(deepcopy(comp))
		cmprsnsGlobal.append('comp_add_%s' % ("_".join(["_".join(x.split("_")[1:]) for x in cmprsns[0]])))

		for cmprsn in cmprsnsGlobal:
			signal = {}
			signal['name'] = cmprsn
			signal['size'] = 1
			signal['type'] = 'STD_LOGIC'
			signals.append(deepcopy(signal))
		for highest in highestsGlobal:
			signal = {}
			signal['name'] = highest
			signal['size'] = sizeBitsAdd
			signal['type'] = 'STD_LOGIC_VECTOR' if sizeBitsAdd > 1 else 'STD_LOGIC'
			signals.append(deepcopy(signal))

		signal = {}
		signal['name'] = "_".join(cmprsnsGlobal[-1].split("_")[1:])
		signal['size'] = sizeBitsAdd
		signal['type'] = 'STD_LOGIC_VECTOR'
		signals.append(deepcopy(signal))

	######################################

	##### GET REGISTERS #####
	registers = []

	for _input in inputs:
		if _input["name"] == "CLK" or _input["name"] == "RST":
			continue
		register = {}
		register["input"] = _input["name"]
		register["output"] = "reg_%s" % (_input["name"])
		register["size"] = _input["size"]
		registers.append(deepcopy(register))

	register = {}
	register["input"] = "reg_%s" % (outputs[0]["name"])
	register["output"] = outputs[0]["name"]
	register["size"] = outputs[0]["size"]

	registers.append(deepcopy(register))

	###########################

	# GET SPECIFICITIES OF THE MAJORITY GATE #
	muxSels = []

	if classifier == 'forest':
		for _out in range(nrOut):
			elemsContainOut = []
			for elem in cmprsnsGlobal:
				if str(_out) in elem.split("_")[2:]:
					elemsContainOut.append(elem)
			expr = {}
			expr['out'] = "sel_decision_%d" % (_out)
			expr['op'] = '&'
			expr['ops'] = elemsContainOut
	
			signal = {}
			signal['name'] = "sel_decision_%d" % (_out)
			signal['size'] = len(elemsContainOut)
			signal['type'] = 'STD_LOGIC_VECTOR' if len(elemsContainOut) > 1 else "STD_LOGIC"
			signals.append(deepcopy(signal))

			muxSel = {}
			muxSel['selector'] = "sel_decision_%d" % (_out)
			muxSel['output'] = 'reg_decision(%d)' % (_out)
			seqDecider = ""
			for code in elemsContainOut:
				for comp in comps:
					cats = "comp_add_" + "_".join(comp['elems'][0].split("_")[1:] + comp['elems'][1].split("_")[1:])
					add0 = comp['elems'][0].split("_")[1:]
					add1 = comp['elems'][1].split("_")[1:]
					if code == cats:
						if str(_out) in add0:
							seqDecider += "1"
						else:
							seqDecider += "0"
			muxSel['decider'] = seqDecider


			exprs.append(deepcopy(expr))
			muxSels.append(deepcopy(muxSel))
	#########################################

	##### ASSIGN THE AND/OR EXPRESSIONS FOUND TO INTERNAL SIGNALS, WHICH WILL BE MAPPED TO VERILOG #####
	lastIdx = 0
	for i in range(numTrees):
		for specOut in range(nrOut):
			for idx, or_ in enumerate(strExprs[i][specOut].split("|")):
				if or_ == "0":
					signal = {}
					expr = {}
					expr["out"] = "and_%d" % (idx + lastIdx)
					expr["op"] = "and"
					expr["ops"] = ["'0'", "'0'"]

					exprs.append(deepcopy(expr))

					signal["name"] = "and_%d" % (idx + lastIdx)
					signal["size"] = 1
					signal["type"] = "STD_LOGIC"
					signals.append(deepcopy(signal))

					continue


				signal = {}
				expr = {}
				expr["out"] = "and_%d" % (idx + lastIdx)
				expr["op"] = "and"
				expr["ops"] = []

				for idComp, comparison in enumerate(globalComparisons):
					filteredComparison = "_".join([comparison[0], str(int(comparison[1])).replace(".","_")])
					if "c%d" % (idComp) in or_.strip("(").strip(")").split("&"):
						expr["ops"].append(deepcopy("comp_%s" % (filteredComparison)))
					elif "~c%d" % (idComp) in or_.strip("(").strip(")").split("&"):
						expr["ops"].append(deepcopy("not(comp_%s)" % (filteredComparison)))

				if expr["ops"] == []:
					expr["ops"] = ["'1'", "'1'"]

				exprs.append(deepcopy(expr))

				signal["name"] = "and_%d" % (idx + lastIdx)
				signal["size"] = 1
				signal["type"] = "STD_LOGIC"
				signals.append(deepcopy(signal))

			signal = {}
			signal["name"] = "or_%d" % (specOut + i * nrOut)
			signal["size"] = 1
			signal["type"] = "STD_LOGIC"
			signals.append(deepcopy(signal))

			expr["out"] = "or_%d" % (specOut + i * nrOut)
			expr["op"] = "or"
			expr["ops"] = []

			expr["ops"] = ["and_%d" % (x + lastIdx) for x in range(len(strExprs[i][specOut].split("|")))]

			exprs.append(deepcopy(expr))

			lastIdx = lastIdx + idx + 1
	###################################################################################################

	##### GEN SPECIFICITIES OF THE MAJORITY GATE #####
	maj = {}
	maj['inputs'] = [0]*nrOut
	maj['outputs'] = ['reg_decision(%d)' % (x) for x in range(nrOut)]
	for i in range(nrOut):
		maj['inputs'][i] = []
		for j in range(numTrees):
			maj['inputs'][i].append('or_%d' % (i+j*nrOut))

	###############################################

	if numTrees == 1:
		comps = []
		maj = []
		muxSels = []

	maj = []

	verilog.gen_architecture(fHandler, classifier, nameEntity, inputs, signals, registers, comparators, exprs, maj, nrOut, comps, muxSels)

	####################################

	return inputs, outputs


def orderCodeFeats(tree, features):
	tree_ = tree.tree_
	featureName = [features[i] if i != _tree.TREE_UNDEFINED else "undefined!" for i in tree_.feature]

	orderedFeats = []
	for feat in featureName:
		if feat != "undefined!":
			orderedFeats.append(int(feat.split("_")[1]))

	orderedFeats = list(dict.fromkeys(orderedFeats))
	
	return ['feat_%d' % (x) for x in sorted(orderedFeats)]


def orderList(features):

	features = list(dict.fromkeys(features))

	orderedFeats = []
	for feat in features:
		orderedFeats.append(int(feat.split("_")[1]))

	return ['feat_%d' % (x) for x in sorted(orderedFeats)]


def getOrderedFeats(clf, classifier, features, numTrees = 5):
	
	intOrderedFeats = []
	if classifier == 'tree':
		intOrderedFeats = orderCodeFeats(clf, features)
	elif classifier == 'forest':
		intOrderedFeats = []
		allOrderedFeats = []
		for i in range(numTrees):
			localOrderedFeats = orderCodeFeats(clf[i], features)
			allOrderedFeats.append(localOrderedFeats)
			intOrderedFeats += localOrderedFeats

		intOrderedFeats = orderList(intOrderedFeats)

	return intOrderedFeats


def plotPDF(clf, dataset, maxDepth, bitsPrecision, classifier = 'tree', path = 'tree', feats = None, labels = None, numTrees=5):
	if classifier == 'forest':
		for i in range(numTrees):
			dotData = export_graphviz(clf[i], out_file=None, feature_names=feats, class_names= labels, filled=True, rounded=True, special_characters=True)
			graph = graphviz.Source(dotData)
			graph.render("%s/%s_numTrees_%d_maxDepth_%d_bitsPrecision_%d_idx_%d" % (path, dataset, numTrees, maxDepth, bitsPrecision, i))
	else:
		dotData = export_graphviz(clf, out_file=None, feature_names=feats, class_names= labels, filled=True, rounded=True, special_characters=True)
		graph = graphviz.Source(dotData)
		graph.render("%s/%s_numTrees_%d_maxDepth_%d_bitsPrecision_%d" % (path, dataset, numTrees, maxDepth, bitsPrecision))


def readDataset(dataset):
	dataPreprocess = np.genfromtxt("%s/%s_preprocessed.csv" % (folderDatasets, dataset), skip_header = 1, delimiter = ',')
	dataApprox = np.genfromtxt("%s/%s_preprocessed_approx.csv" % (folderDatasets, dataset), skip_header = 1, delimiter = ',')
	features = open("%s/%s_preprocessed.csv" % (folderDatasets, dataset), 'r').readline().strip('\n').strip('#').split(',')
	dfPreprocess = pd.DataFrame(data = np.c_[dataPreprocess], columns = features)
	dfApprox = pd.DataFrame(data = np.c_[dataApprox], columns = features)

	return dataPreprocess, dataApprox, features, dfPreprocess, dfApprox


def initializeSetup(classifier):
	os.system('mkdir -p %s/%s' % (folderResults, dirVhdl[classifier]))
	os.system('mkdir -p %s/%s' % (folderResults, dirPdf[classifier]))


def trnsfrToSynthEnv(classifier, nameCfg, dataset, approxTechnique, paramToIter):
	os.system("rm -rf %s/OUTPUT_DATASETS" % (dirSynth))
	os.system("rm -rf %s/synth/*" % (dirSynth))
	os.system("rm -rf %s/work/*" % (dirSynth))
	os.system("mkdir -p %s/OUTPUT_DATASETS" % (dirSynth))

	if paramToIter == -1:
		os.system('cp %s/%s/%s.v %s/rtl/decision.v' % (folderResults, dirVhdl[classifier], nameCfg, dirSynth))
	else:
		if approxTechnique == 0:
			os.system('cp %s/%s/%s_m_%d.v %s/rtl/decision.v' % (folderResults, dirVhdl[classifier], nameCfg, paramToIter, dirSynth))
		elif approxTechnique == 1:
			os.system('cp %s/%s/%s_DC_%d.v %s/rtl/decision.v' % (folderResults, dirVhdl[classifier], nameCfg, paramToIter, dirSynth))

	os.system('cp %s/%s/tb_%s%s.v %s/bench/tb_decision.v' % (folderResults, dirVhdl[classifier], "random_" if useRealInputs == 0 else "", nameCfg, dirSynth))
	if useRealInputs == 1:
		os.system('cp -r %s/%s %s/OUTPUT_DATASETS/' % (folderInputsPower, dataset, dirSynth))
	else:
		os.system('cp -r %s/random %s/OUTPUT_DATASETS/' % (folderRandomInputs, dirSynth))


def genAllOutputFiles(classifier, numTrees, maxDepth, dataset, bitsPrecision, clf, featureSizes, testData, compsClassif, approxTechnique, useMappedComp):

	nameCfg = "%s_numTrees_%d_maxDepth_%d_bitsPrecision_%d" % (nameDecisionClass[dataset], numTrees, maxDepth, bitsPrecision)

	fileOutHdl = open("%s/%s/%s.v" % (folderResults, dirVhdl[classifier], nameCfg), 'w')
	fileTbHdl = open("%s/%s/tb_%s.v" % (folderResults, dirVhdl[classifier], nameCfg), 'w')
	fileTbHdlDebug = open("%s/%s/tb_debug_%s.v" % (folderResults, dirVhdl[classifier], nameCfg), 'w')

	fileTbHdlRandom = open("%s/%s/tb_random_%s.csv" % (folderResults, dirVhdl[classifier], nameCfg), 'w')

	features = [x[0] for x in featureSizes]

	print("%s: Generating PDF for baseline model..." % (dataset))
	plotPDF(clf, dataset, maxDepth, bitsPrecision, classifier=classifier, path='%s/%s' % (folderResults, dirPdf[classifier]), feats=features[:-1], numTrees=numTrees)
	
	orderedFeats = getOrderedFeats(clf, classifier, features[:-1], numTrees)
	print("%s: Generating HDL files for all models..." % (dataset))
	inputs, outputs = treeToHdl(clf, dataset, classifier, maxDepth, featureSizes, fileOutHdl, fileTbHdl, fileTbHdlDebug, numTrees, bitsPrecision, -1)

	if approxTechnique == 0:
		for m in mList:
			fileOutHdlC2PAxComp = open("%s/%s/%s_m_%d.v" % (folderResults, dirVhdl[classifier], nameCfg, m), 'w')
			inputs, outputs = treeToHdl(clf, dataset, classifier, maxDepth, featureSizes, fileOutHdlC2PAxComp, fileTbHdl, fileTbHdlDebug, numTrees, bitsPrecision, approxTechnique, m = m, compsClassif = compsClassif)
			fileOutHdlC2PAxComp.close()

	elif approxTechnique == 1:
		for nrBitsDC in nrsBitsDC:
			fileOutHdlDCComp = open("%s/%s/%s_DC_%d.v" % (folderResults, dirVhdl[classifier], nameCfg, nrBitsDC), 'w')
			inputs, outputs = treeToHdl(clf, dataset, classifier, maxDepth, featureSizes, fileOutHdlDCComp, fileTbHdl, fileTbHdlDebug, numTrees, bitsPrecision, approxTechnique, nrBitsDC = nrBitsDC)
			fileOutHdlDCComp.close()

	verilog.gen_tb(fileTbHdl, testData.shape[0], inputs, outputs)
	verilog.gen_tb(fileTbHdlDebug, maxLinesDebug, inputs, outputs)
	verilog.gen_tb(fileTbHdlRandom, numRandomInputs, inputs, outputs)

	genDatasetInputPower(dataset, inputs, testData)

	fileOutHdl.close()
	fileTbHdl.close()
	fileTbHdlDebug.close()
	fileTbHdlRandom.close()
	
	return orderedFeats, inputs



def trainTestClf(classifier, numTrees, maxDepth, dataset, bitsPrecision, featureSizes):

	print("Running dataset %s, with %s, for %d tree(s), maximum depth of %d and %d bits of precision" % (dataset, classifier, numTrees, maxDepth, bitsPrecision))

	nameCfg = "%s_numTrees_%d_maxDepth_%d_bitsPrecision_%d" % (nameDecisionClass[dataset], numTrees, maxDepth, bitsPrecision)
	
	##### READ FEATURES AND OUTPUT LABELS #####
	print("%s: Reading features and output labels..." % (dataset))
	dataPreprocess, dataApprox, features, dfPreprocess, dfApprox = readDataset(dataset)
	####################################################

	##### GENERATE TRAIN AND TEST DATA FOR BASELINE MODELS #####
	print("%s: Generate train and test data for baseline model..." % (dataset))
	train, test, trainLabels, testLabels = train_test_split(dfApprox.iloc[:,:-1], dfApprox.iloc[:,-1], test_size = 0.33, random_state = 42)
	#############################################################

	##### TRAIN THE DECISION TREE OR RANDOM FOREST FOREST) #####
	print("%s: Running classifier for baseline models..." % (dataset))
	clf = None

	if classifier == 'tree':
		clf = DecisionTreeClassifier(max_depth = maxDepth).fit(train, trainLabels)
	elif classifier == 'forest':

		clf = []

		if useClassicRF == 1:
			clf = RandomForestClassifier(max_depth = maxDepth, n_estimators = numTrees).fit(train, trainLabels)
		else:
			clf = []
			numFeats = len(featureSizes[:-1])
			numFeatsSub = int(sqrt(numFeats))
			for i in range(numTrees):
				colsIdx = np.random.choice(range(numFeats), numFeats - numFeatsSub)
				trainSub = np.array(train)
				trainSub[:,colsIdx] = 1
				tree = DecisionTreeClassifier(max_depth = maxDepth).fit(trainSub, trainLabels)
				clf.append(tree)
	########################################################################

	##### GENERATE ACCURACY SCORE FOR BASELINE MODEL #####
	print("%s: Generating accuracy score for baseline model..." % (dataset))
	yPredict = None
	if classifier == 'tree':
		yPredict = clf.predict(test)
	elif classifier == 'forest':
		votes = []
		for i in range(numTrees):
			votes.append(clf[i].predict(test))
		votes = np.array(votes).T

		#yPredict = np.round(votes.sum(axis=1)/float(numTrees)).astype('int')

		yPredict = []

		i = 0
		for vote in votes:
			srtdVote = sorted(vote)
			mostCommon = Counter(srtdVote).most_common()
			maxOcc = max([x[1] for x in mostCommon])
			mostCommon = min([x[0] for x in mostCommon if x[1] == maxOcc])
			yPredict.append(mostCommon)

		yPredict = np.array(yPredict)

	acc = accuracy_score(testLabels, yPredict)

	print("Accuracy train with test: %f" % (acc))
	#############################################################################################

	return [clf, acc, test, testLabels, yPredict]


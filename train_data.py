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
import gen_decision_tree_verilog as verilog
import gen_decision_tree_verilog_module as verilogSep
import sys
import boolean
from ctes_trees import *
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

def classifyComps(bits_precision, useMappedComp):
	compsClassif = []
	with open("results_comps/comp_%d_map_%d.csv" % (bits_precision, useMappedComp), "r") as fIn:
		for line in fIn.readlines()[1:]:
			compsClassif.append(int(line.split(",")[-1]))

	return compsClassif


def limitedClassifyComps(bits_precision, useMappedComp, areaThr):
	compsClassif = []
	with open("results_comps/comp_%d_map_%d.csv" % (bits_precision, useMappedComp), "r") as fIn:
		for line in fIn.readlines()[1:]:
			splitLine = line.rstrip().split(",")
			if int(splitLine[-1]) <= areaThr:
				compsClassif.append(int(splitLine[1]))

	return compsClassif


def genInputsDebug(dataset, orderedFeats, inputs, testData):
	system('mkdir -p %s/%s/%s' % (folderDebugTest, dataset, 'default'))

	df = pd.DataFrame()

	for feat in orderedFeats:
		df[feat] = testData[feat].head(maxLinesDebug)

	df.to_csv("%s/%s/%s/testData.txt" % (folderDebugTest, dataset, 'default'), index=False)

	for _input in inputs:
		if _input['name'] != 'CLK' and _input['name'] != 'RST':
			localDf = testData[_input['name']].head(maxLinesDebug)
			listBins = []
			strFormat = "{0:0%db}" % (int(_input['size']))
			for idx, elem in localDf.items():
				listBins.append(strFormat.format(int(elem)))
			df2 = pd.Series(listBins)
			df2.to_csv("%s/%s/%s.txt" % (folderDebugTest, dataset, _input['name']), header=False, index=False)


def debugClf(clf, classifier, dataset, orderedFeats, inputs, period, fileName, testData, testLabels, predictedByPy):

	np.savetxt("predictedByPy.txt", predictedByPy[:maxLinesDebug].astype(int), fmt='%d')

	os.system('rm -rf %s/%s/*' % (dirSynth, folderDebugTest))
	os.system('cp -r %s %s/' % (folderDebugTest, dirSynth))

	os.system('rm -rf %s/rtl/*' % (dirSynth))
	os.system('rm -rf %s/bench/*' % (dirSynth))

	os.system('cp %s/%s/%s.v %s/rtl/decision.v' % (folderResults, dirVhdl[classifier]['approx'], fileName, dirSynth))

	os.system('cp %s/%s/tb_debug_%s.v %s/bench/tb_decision.v' % (folderResults, dirVhdl[classifier]['approx'], fileName, dirSynth))

	os.system("bash exec_debug.sh %s %s" % (period, dataset))

	os.system("cp %s/work/RTL_decision_%s/predict.txt ." % (dirSynth, dataset))

	ypredHdl = []
	with open("predict.txt","r") as fHdl:
		lines = fHdl.readlines()
		for line in lines:
			lLine = list(line.strip())
			if len(lLine) > 1:
				ypredHdl.append(len(lLine) - 1 - lLine.index('1'))
			else:
				ypredHdl.append(lLine[0])

	ypredHdl = np.array(ypredHdl).astype(int)

	isHdlCorrect = np.array_equal(ypredHdl, predictedByPy[:maxLinesDebug])

	return isHdlCorrect


def simulErrorsApprox(dataset, period, AtestLabels, predictedByPy):

	np.savetxt("predictedByPy.txt", predictedByPy.astype(int), fmt='%d')

	np.savetxt("correctTest.txt", AtestLabels.astype(int), fmt='%d')

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

			if classifPred == int(AtestLabels.iloc[idx]):
				nrCorrects += 1

	acc = nrCorrects/nrInfs

	return acc


def genDatasetInputPower(dataset, inputs, testData):
	system("mkdir -p %s" % (folderInputsPower))
	system("mkdir -p %s/%s" % (folderInputsPower, dataset))
	system("mkdir -p %s" % (folderRandomInputs))
	system("mkdir -p %s/random" % (folderRandomInputs))

	#df = pd.read_csv("datasets/%s_preprocessed_approx.csv" % (dataset))

	#np.random.seed(0)
	#df = df.sample(frac=1)

	#if df.shape[0] > 100000:
	#	df = df.head(100000)

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

	##### ISUSEDINEXPR IS NEEDED TO CHECK LATER WHICH OF THE COMPARISONS ARE NOT USED IN THE EXPRESSION (THEREFORE, ONLY LEAD TO '0' LEAVES) #####
	isUsedInExpr = [1]*len(comparisons)

	for idx, comparison in enumerate(comparisons):
		if "c%s" % (idx) not in str(simplExpr):
			isUsedInExpr[idx] = 0
	##############################################################################################################################################

	return simplExpr, isUsedInExpr


def treeToHdl(clf, dataset, classifier, maxDepth, featureSizes, fHandler, fHandlerTb, fHandlerTbDebug, numTrees, bitsPrecision, updateCteMode, totalSamples, compsClassif = [], listBestComps = [], maxStep = 0, maxStepPercent = 0, nrBitsDC = 0, areaThr = 0):

	nrOut = outs[dataset]

	##### CREATE OUTPUTS VECTOR WITH ONE OUTPUT (ONE BIT OF DECISION TREE, FIXED) #####
	outputs = []
	output = {}
	output['name'] = 'decision'
	output['size'] = 1 if (nrOut == 2 and classifier == 'tree') else nrOut
	output['type'] = 'STD_LOGIC' if (nrOut == 2 and classifier == 'tree') else 'STD_LOGIC_VECTOR'

	outputs.append(output)
	###################################################################################

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
			##### AQUI, A VARIAVEL C VAI TER TODAS COMPARACOES CONSIDERANDO O SIMBOLO DA BIBLIOTECA BOOLEAN (NAO EH IGUAL O NUMERO DE FEATURES PORQUE ALGUMAS FEATURES SAO COMPARADAS MAIS DE UMA VEZ NA ARVORE, OU NEM SAO USADAS)

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

	##### GET COMPARATORS AND SIGNALS #####

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


	# CHANGE THE CONSTANTS
	if updateCteMode == 0:
		if maxStep > -1:
			for idx, comparison in enumerate(globalComparisons):
				if comparison[2] != bitsPrecision:
					continue

				newMaxStep = maxStep

				prevCte = int(comparison[1])
				areaCurrCte = compsClassif[prevCte]
				currBestCte = prevCte

				for step in range(1,newMaxStep+1):
					candCte = prevCte - step

					if (candCte >= 0) and (candCte < len(compsClassif)):
						areaCand = compsClassif[candCte]
					

						if areaCand < areaCurrCte:
							currBestCte = candCte
							areaCurrCte = areaCand

					candCte = prevCte + step

					if (candCte >= 0) and (candCte < len(compsClassif)):
						areaCand = compsClassif[candCte]


						if areaCand < areaCurrCte:
							currBestCte = candCte
							areaCurrCte = areaCand

				globalComparisons[idx] = [comparison[0], float(currBestCte), comparison[2]]


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

							if updateCteMode == 3:
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

	###################################################

	exprs = []

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

	#########################

	##### GET 'AND' AND 'OR' SIGNALS (EXPRESSIONS) #####

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

				######## FIX BUG WHERE AND_X <=  ; ########
				if expr["ops"] == []:
					expr["ops"] = ["'1'", "'1'"]
				###########################################

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

	##### GEN MAJORITARY GATE FOR ALL THE ORS #####

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

	verilogSep.gen_architecture(fHandler, classifier, nameEntity, inputs, signals, registers, comparators, exprs, maj, nrOut, comps, muxSels)

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
	os.system('mkdir -p %s/%s' % (folderResults, dirVhdl[classifier]['approx']))
	os.system('mkdir -p %s/%s' % (folderResults, dirPdf[classifier]['approx']))


def trnsfrToSynthEnv(nameCfg, dataset, paramToIter):
	os.system("rm -rf %s/OUTPUT_DATASETS" % (dirSynth))
	os.system("rm -rf %s/synth/*" % (dirSynth))
	os.system("rm -rf %s/work/*" % (dirSynth))
	os.system("mkdir -p %s/OUTPUT_DATASETS" % (dirSynth))

	if paramToIter == -1:
		os.system('cp %s/%s/%s.v %s/rtl/decision.v' % (folderResults, dirVhdl[classifier]['approx'], nameCfg, dirSynth))
	else:
		if updateCteMode == 0:
			os.system('cp %s/%s/%s_step_%d.v %s/rtl/decision.v' % (folderResults, dirVhdl[classifier]['approx'], nameCfg, paramToIter, dirSynth))
		elif updateCteMode == 3:
			os.system('cp %s/%s/%s_DC_%d.v %s/rtl/decision.v' % (folderResults, dirVhdl[classifier]['approx'], nameCfg, paramToIter, dirSynth))

	os.system('cp %s/%s/tb_%s%s.v %s/bench/tb_decision.v' % (folderResults, dirVhdl[classifier]['approx'], "random_" if useRealInputs == 0 else "", nameCfg, dirSynth))
	if useRealInputs == 1:
		os.system('cp -r %s/%s %s/OUTPUT_DATASETS/' % (folderInputsPower, dataset, dirSynth))
	else:
		os.system('cp -r %s/random %s/OUTPUT_DATASETS/' % (folderRandomInputs, dirSynth))


def genAllOutputFiles(classifier, numTrees, maxDepth, dataset, bitsPrecision, AClf, featureSizes, testData, compsClassif, totalSamples, updateCteMode, useMappedComp):

	nameCfg = "%s_numTrees_%d_maxDepth_%d_bitsPrecision_%d" % (nameDecisionClass[dataset], numTrees, maxDepth, bitsPrecision)

	AfileOutHdl = open("%s/%s/%s.v" % (folderResults, dirVhdl[classifier]['approx'], nameCfg), 'w')
	AfileTbHdl = open("%s/%s/tb_%s.v" % (folderResults, dirVhdl[classifier]['approx'], nameCfg), 'w')
	AfileTbHdlDebug = open("%s/%s/tb_debug_%s.v" % (folderResults, dirVhdl[classifier]['approx'], nameCfg), 'w')

	AfileTbHdlRandom = open("%s/%s/tb_random_%s.csv" % (folderResults, dirVhdl[classifier]['approx'], nameCfg), 'w')

	features = [x[0] for x in featureSizes]

	print("%s: Generating PDF for Approximate models..." % (dataset))
	plotPDF(AClf, dataset, maxDepth, bitsPrecision, classifier=classifier, path='%s/%s' % (folderResults, dirPdf[classifier]['approx']), feats=features[:-1], numTrees=numTrees)
	
	orderedFeats = getOrderedFeats(AClf, classifier, features[:-1], numTrees)
	print("%s: Generating VHDL file for Approximate models..." % (dataset))
	inputs, outputs = treeToHdl(AClf, dataset, classifier, maxDepth, featureSizes, AfileOutHdl, AfileTbHdl, AfileTbHdlDebug, numTrees, bitsPrecision, -1, totalSamples)

	if updateCteMode == 0:
		for maxStepSearchCte in maxStepsSearchCte:
			AfileOutHdlStepComp = open("%s/%s/%s_step_%d.v" % (folderResults, dirVhdl[classifier]['approx'], nameCfg, maxStepSearchCte), 'w')
			inputs, outputs = treeToHdl(AClf, dataset, classifier, maxDepth, featureSizes, AfileOutHdlStepComp, AfileTbHdl, AfileTbHdlDebug, numTrees, bitsPrecision, updateCteMode, totalSamples, maxStep = maxStepSearchCte, compsClassif = compsClassif)
			AfileOutHdlStepComp.close()

	elif updateCteMode == 3:
		for nrBitsDC in nrsBitsDC:
			AfileOutHdlDCComp = open("%s/%s/%s_DC_%d.v" % (folderResults, dirVhdl[classifier]['approx'], nameCfg, nrBitsDC), 'w')
			inputs, outputs = treeToHdl(AClf, dataset, classifier, maxDepth, featureSizes, AfileOutHdlDCComp, AfileTbHdl, AfileTbHdlDebug, numTrees, bitsPrecision, updateCteMode, totalSamples, nrBitsDC = nrBitsDC)
			AfileOutHdlDCComp.close()

	if debugArch == 1:
		genInputsDebug(dataset, orderedFeats, inputs, testData)

	verilog.gen_tb(AfileTbHdl, testData.shape[0], inputs, outputs)
	verilog.gen_tb(AfileTbHdlDebug, maxLinesDebug, inputs, outputs)
	verilog.gen_tb(AfileTbHdlRandom, numRandomInputs, inputs, outputs)

	genDatasetInputPower(dataset, inputs, testData)

	AfileOutHdl.close()
	AfileTbHdl.close()
	AfileTbHdlDebug.close()
	AfileTbHdlRandom.close()
	
	return orderedFeats, inputs



def trainTestClf(classifier, numTrees, maxDepth, dataset, bitsPrecision, featureSizes):

	print("Running dataset %s, with %s, for %d tree(s), maximum depth of %d and %d bits of precision" % (dataset, classifier, numTrees, maxDepth, bitsPrecision))

	nameCfg = "%s_numTrees_%d_maxDepth_%d_bitsPrecision_%d" % (nameDecisionClass[dataset], numTrees, maxDepth, bitsPrecision)
	
	##### READ FEATURES AND OUTPUT LABELS #####
	print("%s: Reading features and output labels..." % (dataset))
	dataPreprocess, dataApprox, features, dfPreprocess, dfApprox = readDataset(dataset)
	####################################################

	##### GENERATE TRAIN AND TEST DATA FOR APPROXIMATE MODELS #####
	print("%s: Generate train and test data for approximate model..." % (dataset))
	Atrain, Atest, AtrainLabels, AtestLabels = train_test_split(dfApprox.iloc[:,:-1], dfApprox.iloc[:,-1], test_size = 0.33, random_state = 42)
	#############################################################

	##### RUN THE DECISION TREE ALGORITHM (OR AN ALTERNATIVE ONE, LIKE THE RANDOM FOREST) #####
	print("%s: Running classifier for approximate models..." % (dataset))
	AClf = None

	if classifier == 'tree':
		AClf = DecisionTreeClassifier(max_depth = maxDepth).fit(Atrain, AtrainLabels)
	elif classifier == 'forest':

		AClf = []

		if useClassicRF == 1:
			AClf = RandomForestClassifier(max_depth = maxDepth, n_estimators = numTrees).fit(Atrain, AtrainLabels)
		else:
			AClf = []
			numFeats = len(featureSizes[:-1])
			numFeatsSub = int(sqrt(numFeats))
			for i in range(numTrees):
				colsIdx = np.random.choice(range(numFeats), numFeats - numFeatsSub)
				AtrainSub = np.array(Atrain)
				AtrainSub[:,colsIdx] = 1
				Atree = DecisionTreeClassifier(max_depth = maxDepth).fit(AtrainSub, AtrainLabels)
				AClf.append(Atree)
	#print cross_val_score(clf, XTrain, yTrain, cv = 5)
	###########################################################################################

	##### GENERATE HIT SCORE FOR APPROXIMATE MODELS #####
	print("%s: Generating hit score for approximate models..." % (dataset))
	yPredictAA = None
	if classifier == 'tree':
		yPredictAA = AClf.predict(Atest)
	elif classifier == 'forest':
		AAvotes = []
		for i in range(numTrees):
			AAvotes.append(AClf[i].predict(Atest))
		AAvotes = np.array(AAvotes).T

		#yPredictAA = np.round(AAvotes.sum(axis=1)/float(numTrees)).astype('int')

		yPredictAA = []

		i = 0
		for vote in AAvotes:
			srtdVote = sorted(vote)
			mostCommon = Counter(srtdVote).most_common()
			maxOcc = max([x[1] for x in mostCommon])
			mostCommon = min([x[0] for x in mostCommon if x[1] == maxOcc])
			yPredictAA.append(mostCommon)

		yPredictAA = np.array(yPredictAA)

	AAscore = accuracy_score(AtestLabels, yPredictAA)

	print("hit approximate train with approximate test: %f" % (AAscore))
	#############################################################################################

	return [AClf, AAscore, Atest, AtestLabels, yPredictAA, Atrain.shape[0]]



np.random.seed(seed)

fHits = open("%s/%s" % (folderResults, nameFileAcc), "a")

for updateCteMode, useMappedComp in product(updateCteModes, useMappedComps):

	for classifier in classifiers:

		initializeSetup(classifier)

		_numTrees = [1]
		if classifier == "tree":
			_numTrees = [1]
		elif classifier == 'forest':
			_numTrees = numTrees

		for numTree, maxDepth, dataset, bitsPrecision in product(_numTrees, maxDepths, datasets, bitsPrecisions):

			featureSizes = preprocessing("%s/%s.csv" % (folderDatasets, dataset), Nbits = bitsPrecision, drop_cols = dropCols[dataset])

			compsClassif = classifyComps(bitsPrecision, useMappedComp)

			np.random.seed(seed)
			AClf, AAHitValue, Atest, AtestLabels, yPredictAA, totalSamples = trainTestClf(classifier, numTree, maxDepth, dataset, bitsPrecision, featureSizes)

			print(AAHitValue)

			orderedFeats, inputs = genAllOutputFiles(classifier, numTree, maxDepth, dataset, bitsPrecision, AClf, featureSizes, Atest, compsClassif, totalSamples, updateCteMode, useMappedComp)

			nameCfg = "%s_numTrees_%d_maxDepth_%d_bitsPrecision_%d" % (nameDecisionClass[dataset], numTree, maxDepth, bitsPrecision)

			isHdlCorrect = -1

			if debugArch == 1:
				isHdlCorrect = debugClf(AClf, classifier, dataset, orderedFeats, inputs, period, nameCfg, Atest, AtestLabels, yPredictAA)

			trnsfrToSynthEnv(nameCfg, dataset, -1)

			os.system("bash exec_decision_spec_period.sh %s %s %s" % (dataset if useRealInputs == 1 else "random", period, dirSynth))

			increasePerHeight = stepIncreasePerHeight if updateCteMode == 0 else percentIncreasePerHeight

			os.system("python parse_power.py %s %s %s %s %s %s %s %s %d %s %s %s %d" % (dirSynth, dataset if useRealInputs == 1 else "random", classifier, str(maxDepth), str(numTree), period, str(bitsPrecision), AAHitValue, updateCteMode, "0", str(increasePerHeight), str(useMappedComp), 1))

			os.system("python parse_power.py %s %s %s %s %s %s %s %s %d %s %s %s %d" % (dirSynth, dataset if useRealInputs == 1 else "random", classifier, str(maxDepth), str(numTree), period, str(bitsPrecision), AAHitValue, updateCteMode, "0", str(increasePerHeight), str(useMappedComp), 0))

			acc = simulErrorsApprox(dataset, period, AtestLabels, yPredictAA)

			isHdlCorrect = 1 if acc == AAHitValue else 0

			print(",".join([str(x) for x in [dataset, bitsPrecision, classifier, maxDepth, numTree, AAHitValue, isHdlCorrect]]), file=fHits)

			print("Correctness state of VHDL: %d" % (isHdlCorrect))

			#exit()

			paramsToIter = []
			if updateCteMode == 0:
				paramsToIter = deepcopy(maxStepsSearchCte)
				paramsToIter.remove(0)
			elif updateCteMode == 3:
				paramsToIter = nrsBitsDC

			if (updateCteMode == 0) or (updateCteMode == 3):

				for paramToIter in paramsToIter:
					trnsfrToSynthEnv(nameCfg, dataset, paramToIter)

					os.system("bash exec_decision_spec_period.sh %s %s %s" % (dataset if useRealInputs == 1 else "random", period, dirSynth))

					acc = simulErrorsApprox(dataset, period, AtestLabels, yPredictAA)

					os.system("python parse_power.py %s %s %s %s %s %s %s %s %d %s %s %s %d" % (dirSynth, dataset if useRealInputs == 1 else "random", classifier, str(maxDepth), str(numTree), period, str(bitsPrecision), str(acc), updateCteMode, str(paramToIter), str(increasePerHeight), str(useMappedComp), 1))

					os.system("python parse_power.py %s %s %s %s %s %s %s %s %d %s %s %s %d" % (dirSynth, dataset if useRealInputs == 1 else "random", classifier, str(maxDepth), str(numTree), period, str(bitsPrecision), str(acc), updateCteMode, str(paramToIter), str(increasePerHeight), str(useMappedComp), 0))

					print(",".join([str(x) for x in [dataset, bitsPrecision, classifier, maxDepth, numTree, acc, isHdlCorrect]]), file=fHits)

fHits.close()

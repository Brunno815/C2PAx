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

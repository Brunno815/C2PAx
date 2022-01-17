import numpy as np
import graphviz 
import os
import copy
from copy import deepcopy
import sys
from presets import *
import pandas as pd
from itertools import product
from preprocessing import *
from sklearn.tree import *
from train_translate import *

np.random.seed(seed)

fAcc = open("%s/%s" % (folderResults, nameFileAcc), "a")

# Iterate through the approximation presets
for approxTechnique, useMappedComp in product(approxTechniques, useMappedComps):

	# Iterate through the desired classifiers
	for classifier in classifiers:

		initializeSetup(classifier)

		_numTrees = [1]
		if classifier == "tree":
			_numTrees = [1]
		elif classifier == 'forest':
			_numTrees = numTrees

		# Iterate through the tree/forest and quantization configurations
		for numTree, maxDepth, dataset, bitsPrecision in product(_numTrees, maxDepths, datasets, bitsPrecisions):

			# Quantizes the features of the data set
			featureSizes = preprocessing("%s/%s.csv" % (folderDatasets, dataset), Nbits = bitsPrecision, drop_cols = dropCols[dataset])

			# Get list of standalone comparators (from the offline synthesis stage)
			compsClassif = getStandaloneComps(bitsPrecision, useMappedComp)

			np.random.seed(seed)
			# Train the classifier
			clf, acc, test, testLabels, yPredict = trainTestClf(classifier, numTree, maxDepth, dataset, bitsPrecision, featureSizes)

			# Generate all output files (RTL and testbenches) of the baseline and approximate models
			orderedFeats, inputs = genAllOutputFiles(classifier, numTree, maxDepth, dataset, bitsPrecision, clf, featureSizes, test, compsClassif, approxTechnique, useMappedComp)

			nameCfg = "%s_numTrees_%d_maxDepth_%d_bitsPrecision_%d" % (nameDecisionClass[dataset], numTree, maxDepth, bitsPrecision)

			isHdlCorrect = -1
			accSimul = -1

			# Transfer the baseline model to the synthesis environment
			trnsfrToSynthEnv(classifier, nameCfg, dataset, approxTechnique, -1)

			# Synthesize the baseline model if Cadence environment is properly set up, and simulate it to verify correctness
			if runSynth == 1:
				os.system("bash exec_synth.sh %s %s %s" % (dataset if useRealInputs == 1 else "random", period, dirSynth))
				accSimul = simulErrorsApprox(dataset, period, testLabels, yPredict)
				isHdlCorrect = 1 if acc == accSimul else 0

			# Parse synthesis results to output files
			os.system("python parse_synth.py %s %s %s %s %s %s %s %s %d %s %s %d %d" % (dirSynth, dataset if useRealInputs == 1 else "random", classifier, str(maxDepth), str(numTree), period, str(bitsPrecision), acc, approxTechnique, "0", str(useMappedComp), 0, runSynth))

			print(",".join([str(x) for x in [dataset, bitsPrecision, classifier, maxDepth, numTree, acc, isHdlCorrect]]), file=fAcc)

			paramsToIter = []
			if approxTechnique == 0:
				paramsToIter = deepcopy(mList)
			elif approxTechnique == 1:
				paramsToIter = nrsBitsDC

			if (approxTechnique == 0) or (approxTechnique == 1):

				# Iterate through every approximate (C2PAx or DC) configuration to prepare for synthesis
				for paramToIter in paramsToIter:

					# Transfer specific approximate model to synthesis environment
					trnsfrToSynthEnv(classifier, nameCfg, dataset, approxTechnique, paramToIter)

					# Synthesize the specific approximate model if Cadence environment is properly set up, and simulate it to obtain accuracy of the approximate model
					if runSynth == 1:
						os.system("bash exec_synth.sh %s %s %s" % (dataset if useRealInputs == 1 else "random", period, dirSynth))

						accSimul = simulErrorsApprox(dataset, period, AtestLabels, yPredictAA)

					# Parse synthesis results to output files
					os.system("python parse_synth.py %s %s %s %s %s %s %s %s %d %s %s %d %d" % (dirSynth, dataset if useRealInputs == 1 else "random", classifier, str(maxDepth), str(numTree), period, str(bitsPrecision), str(accSimul), approxTechnique, str(paramToIter), str(useMappedComp), 0, runSynth))

					print(",".join([str(x) for x in [dataset, bitsPrecision, classifier, maxDepth, numTree, accSimul, isHdlCorrect]]), file=fAcc)


print("RTL files are in RESULTS folder.")

os.system("rm -rf dataset_inputs_power")
os.system("rm -rf random_inputs_power")
os.system("rm -rf SYNTH_REPORTS")
os.system("rm -rf predict.txt")
os.system("rm -rf predictedByPy.txt")
os.system("rm -rf correctTest.txt")
os.system("rm -rf testing.csv")
os.system("rm -rf TEST_DATA")
os.system("rm -rf slacks")
os.system("rm -rf SYNTH/synth/*")
os.system("rm -rf SYNTH/work/*")
os.system("rm -rf datasets/*.txt")
os.system("rm -rf datasets/*_preprocessed*")

fAcc.close()

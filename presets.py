from os import system
import os

datasets = ['dummy']

outs = {}
outs['dummy'] = 3
outs['wearable'] = 5
outs['activities'] = 5
outs['wireless'] = 4

folderDatasets = 'datasets'
folderResults = 'RESULTS'
folderDebugTest = 'TEST_DATA'
folderInputsPower = "dataset_inputs_power"
folderRandomInputs = "random_inputs_power"

dirSizes = 'bits_features'
curDir = os.getcwd()
dirSynth = '%s/SYNTH' % (curDir)

dropCols = {}
dropCols['dummy'] = None
dropCols['activities'] = None
dropCols["wearable"] = ['user_name', 'raw_timestamp_part_1', 'raw_timestamp_part_2', 'cvtd_timestamp']
dropCols["wireless"] = ['Time']

nameDecisionClass = {}
for dataset in datasets:
	nameDecisionClass[dataset] = dataset

nameFunction = 'decision'
nameEntity = 'decision'

nameFileAcc = "acc_values.csv"
nameFileSynth = "synthesis_results.csv"

dirPdf = {}
dirPdf['tree'] = 'PDF_trees'
dirPdf['forest'] = 'PDF_forests'

dirVhdl = {}
dirVhdl['tree'] = 'HDL_trees'
dirVhdl['forest'] = 'HDL_forests'

system('mkdir -p %s' % (folderResults))

fPower = open("%s/%s" % (folderResults, nameFileSynth), "w")
print(",".join(["Dataset", "Classifier", "Bits_Precision", "Depth", "NrTrees", "Period", "Leakage_PWR", "Dyn_PWR", "Total_PWR", "Cells", "Cell_Area", "Total_Area", "NAND2_Eq_Total", "Slack", "Accuracy", "ApproxTechnique", "Param", "UseMappedComp"]), file=fPower)
fPower.close()

fAcc = open("%s/%s" % (folderResults, nameFileAcc), "w")
print(",".join(['Dataset', 'Precision', 'Classifier', 'MaxDepth', 'NumTrees', 'Accuracy', 'isHdlCorrect']), file=fAcc)
fAcc.close()

seed = 0
maxLinesDebug = 200
runSynth = 0 #run synth (in case of '0', the RTL files are generated but not synthesized)
useRealInputs = 1 #consider real input vectors from the data set in the synthesis
numRandomInputs = 50000
period = "%.1f" % (20.0) #synthesis period

useClassicRF = 1 #use regular RandomForestClassifier or an ensemble of DecisionTreeClassifier, for the RFs


# -1 - no technique
# 0  - C2PAx
# 1  - DC
approxTechniques = [0]

mList = [5] #values of the approximation range m to test
nrsBitsDC = [3] #number of LSBs to assign DC
useMappedComps = [0]

bitsPrecisions = [10] #width of the features and comparisons (categorical features are assigned their own specific widths)

#Tree/forest configurations
classifiers = ['tree']
maxDepths = [3]
numTrees = [5]

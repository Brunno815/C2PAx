from os import system
import os

datasets = ['accelAdl', 'wearable', 'activities', 'wireless']

outs = {}
outs['accelAdl'] = 14
outs['wearable'] = 5
outs['activities'] = 5
outs['wireless'] = 4

folderDatasets = 'datasets'
folderResults = 'GEN_RESULTS'
folderDebugTest = 'TEST_DATA'
folderInputsPower = "dataset_inputs_power"
folderRandomInputs = "random_inputs_power"

dirSizes = 'bits_features'
curDir = os.getcwd()
dirSynth = '%s/SYNTH' % (curDir)

dropCols = {}
dropCols['accelAdl'] = None
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
nameFileErrors = "errorsWithPrune.csv"

dirPdf = {}
dirPdf['tree'] = {}
dirPdf['forest'] = {}
dirPdf['tree']['golden'] = 'PDF_trees_golden'
dirPdf['forest']['golden'] = 'PDF_forests_golden'
dirPdf['tree']['approx'] = 'PDF_trees_approx'
dirPdf['forest']['approx'] = 'PDF_forests_approx'

dirVhdl = {}
dirVhdl['tree'] = {}
dirVhdl['forest'] = {}
dirVhdl['tree']['golden'] = 'VHDL_trees_golden'
dirVhdl['forest']['golden'] = 'VHDL_forests_golden'
dirVhdl['tree']['approx'] = 'VHDL_trees_approx'
dirVhdl['forest']['approx'] = 'VHDL_forests_approx'

system('mkdir -p %s' % (folderResults))

fPower = open("%s/%s" % (folderResults, nameFileSynth), "w")
print(",".join(["Dataset", "Classifier", "Bits_Precision", "Depth", "NrTrees", "Period", "Leakage_PWR", "Dyn_PWR", "Total_PWR", "Cells", "Cell_Area", "Total_Area", "NAND2_Eq_Total", "Slack", "Accuracy", "UpdateCteMode", "Param", "IncreasePerHeight", "UseMappedComp"]), file=fPower)
fPower.close()

fHits = open("%s/%s" % (folderResults, nameFileAcc), "w")
print(",".join(['Dataset', 'Precision', 'Classifier', 'MaxDepth', 'NumTrees', 'Accuracy', 'isHdlCorrect']), file=fHits)
fHits.close()

seed = 0
maxLinesDebug = 200

debugArch = 0


maxStepsSearchCte = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,20,25,30,35,40,45,50,100,150,200]

nrsBitsDC = [1,2,3,4,5,6,7,8,9]

stepIncreasePerHeight = 1
percentIncreasePerHeight = 0.001

minStep = 1

#
# -1 - no technique
# 0  - update by fixed max distance
# 3  - use don't care signals in LSBs of the constants (lets synth tool find the best mode for the specific constant, based on the area)
updateCteModes = [0]
#


useMappedComps = [0]

useRealInputs = 1
numRandomInputs = 50000

period = "%.1f" % (20.0)

useClassicRF = 1

classifiers = ['forest']

bitsPrecisions = [10]
maxDepths = [3,4,5,6,7,8,9,10]
numTrees = [5]

datasets = ['activities']
maxDepths = [6]
maxStepsSearchCte = [0,5]

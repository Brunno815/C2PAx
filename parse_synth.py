from sys import argv

dirSynth = argv[1]
dataset = argv[2]
classifier = argv[3]
maxDepth = argv[4]
numTrees = argv[5]
period = argv[6]
bitsPrecision = argv[7]
acc = argv[8]
approxTechnique = argv[9]
paramToIter = argv[10]
useMappedComp = argv[11]
getPwrDefault = int(argv[12])
runSynth = int(argv[13])

name_arch = "decision"
folder_reports = "%s/synth/synthesis_decision_PERIOD_%s/reports" % (dirSynth, period)
spec_report = "_".join(["reports", dataset, classifier, "maxDepth", maxDepth, "numTrees", numTrees, "bitsPrecision", bitsPrecision, "period", period])
name_power_default = "decision_power.rpt"
name_power_dataset = "decision_%s_power.rpt" % (dataset)
name_timing = "decision_timing_nworst_3.rpt"
name_area = "final_area.rpt"
name_nand2 = "decision_area_NAND2_eq.rpt"
folder_results = "RESULTS"
leak = 0.0
dyn = 0.0
total = 0.0
cells = 0
cell_area = 0
total_area = 0
nand2_eq_total = 0

name_power = ""
concStrPwr = ""
if getPwrDefault == 1:
	name_power = name_power_default
	concStrPwr = "_def"
else:
	name_power = name_power_dataset
	concStrPwr = "_ds"

if runSynth == 1:
	with open("%s/%s" % (folder_reports, name_power), "r") as f_power, open("%s/%s" % (folder_reports, name_area), "r") as f_area, open("%s/%s" % (folder_reports, name_nand2), "r") as f_nand2, open("%s/%s" % (folder_reports, name_timing), "r") as f_timing, open("%s/synthesis_results.csv" % (folder_results), "a") as f_out:
		for line in f_power.readlines():
			splitLine = line.split()
			if len(splitLine) > 0:
				if splitLine[0] == name_arch:
					leak = float(splitLine[2])
					dyn = float(splitLine[5])
					total = float(splitLine[6])

		for line in f_area.readlines():
			splitLine = line.split()
			if len(splitLine) > 0:
				if splitLine[0] == name_arch:
					cells = int(splitLine[1])
					cell_area = int(splitLine[2])
					total_area = int(splitLine[4])

		for line in f_nand2.readlines():
			splitLine = line.split()
			if len(splitLine) > 0:
				if splitLine[0] == name_arch:
					nand2_eq_total = int(splitLine[4])
	
		for line in f_timing.readlines():
			if "Timing slack" in line:
				slack = int(line.split()[3][:-2])/1000.0
				break

		print(",".join([dataset+concStrPwr, classifier, bitsPrecision, maxDepth, numTrees, str(period), str(leak), str(dyn), str(total), str(cells), str(cell_area), str(total_area), str(nand2_eq_total), str(slack), acc, approxTechnique, str(paramToIter), str(useMappedComp)]), file=f_out)

else:
	with open("%s/synthesis_results.csv" % (folder_results), "a") as f_out:
		print(",".join([dataset+concStrPwr, classifier, bitsPrecision, maxDepth, numTrees, str(period), "-", "-", "-", "-", "-", "-", "-", "-", acc, approxTechnique, str(paramToIter), str(useMappedComp)]), file=f_out)

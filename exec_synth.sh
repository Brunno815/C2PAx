#!/bin/bash

# 1 = dataset
# 2 = period
# 3 = dirSynth

dataset=$1
period=$2
dirSynth=$3

mkdir -p "slacks"
mkdir -p "SYNTH_REPORTS"

echo "Starting synthesis..."

cd ${dirSynth}/ && ./run_synth -p ${period}

echo "Starting simulation..."
cd -

cd ${dirSynth}/ && ./run_sim -n -s -l ${dataset}

echo "Starting resynthesis..."
cd -

cd ${dirSynth}/ && ./run_synth -r -p ${period}

cd -

rm -rf "./SYNTH_REPORTS/*"

#cp -r ${dirSynth}/synth/synthesis_decision_PERIOD_${period}/reports/decision_power.rpt ./SYNTH_REPORTS/reports_${dataset}_${classifier}_maxDepth_${maxDepth}_numTrees_${numTrees}_bitsPrecision_${bitsPrecision}_period_${period}"
#python parse_power.py ${dirSynth} ${dataset} ${classifier} ${maxDepth} ${numTrees} ${period} ${bitsPrecision} ${paramToIter} 1
#python parse_power.py ${dirSynth} ${dataset} ${classifier} ${maxDepth} ${numTrees} ${period} ${bitsPrecision} ${paramToIter} 0

#!/bin/bash

period=$1
dataset=$2

dirSynth="`pwd`"

echo "Starting debugging simulation..."

cd ${dirSynth}/SYNTH && ./run_sim -d -v -l ${dataset}

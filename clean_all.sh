#!/bin/bash

filePath="`pwd`"

rm -rf bashes
rm -rf dataset_inputs_power
rm -rf random_inputs_power
rm -rf GEN_RESULTS
rm -rf RESULTS
rm -rf SYNTH_REPORTS
rm -rf predict.txt
rm -rf predictedByPy.txt
rm -rf correctTest.txt
rm -rf *.pyc
rm -rf testing.csv
rm -rf TEST_DATA
rm -rf slacks
rm -rf ${filePath}/SYNTH/synth/*
rm -rf ${filePath}/SYNTH/work/*
rm -rf ${filePath}/SYNTH/bench/*
rm -rf ${filePath}/SYNTH/rtl/ARCH_DECISION/*
rm -rf ${filePath}/SYNTH/OUTPUT_DATASETS
rm -rf ${filePath}/SYNTH/TEST_DATA
rm -rf datasets/*.txt
rm -rf datasets/*_preprocessed*

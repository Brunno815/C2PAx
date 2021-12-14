# C2PAx

## Project Description

This repository contains C2PAx, a technique to approximate constant comparators based on previous standalone synthesis of comparators for every possible constant value, focusing on VLSI implementations of tree-based models.

This proposal was implemented considering Decision Trees (DTs) and Random Forests (RFs) ML models, to verify the impacts of the proposal. It can be applied to any other model that uses constant comparators (XGBoost, for instance), or any accelerator.

First, the software generates RTL descriptions of the DT/RF to be approximated, using a tree-to-Verilog translator, which uses the Scikit-Learn tree structures as input. The descriptions are generated with constant comparators, and all the comparators of the tree model are instantiated in the RTL. Then, the RTL descriptions are approximated using the C2PAx proposal.

We also implement another method for approximation denoted as DC, which applies Don't Care signals to the Least Significant Bits (LSBs) of the comparators, so that we can compare our results with a baseline model.

There RTL files are then synthesized and simulated to obtain power, area, timing, and accuracy results.


## Requirements

This implementation uses Cadence Genus and Irun to perform logic synthesis and simulation, respectively. Therefore, licenses are required.

## Running the code

To run the code, users must run the `train_data.py` file. The parameters of the project are selected in the `ctes_trees.py` file. To define the approximation level of the technique, users must specify the desired values in the `maxStepsSearchCte` list. Other parameters such as the tree configurations (depth, number of estimators, quantization level, etc) can also be defined in this file.
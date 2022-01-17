# C2PAx

## Project Description

This repository contains **C2PAx**, a technique to approximate constant comparators based on previous standalone synthesis of comparators for every possible constant value, focusing on VLSI implementations of tree-based models.

This proposal was implemented considering Decision Trees (DTs) and Random Forests (RFs) ML models, to verify the impacts of the proposal. It can be applied to any other ML model that uses constant comparators (XGBoost, for instance), or any other accelerator that uses comparators with explicit constants.

First, the software generates RTL descriptions of the DT/RF to be approximated, using a tree-to-Verilog translator, which uses the Scikit-Learn (SK) tree structures as input. This translator was first proposed in [1]. The descriptions are generated with constant comparators, and all the comparators of the tree model are instantiated in the RTL.

The baseline RTL descriptions are approximated using our C2PAx proposal. The idea is that tree-based models contain several comparators, which can be described with explicit constants in one of their operators (these constants are defined in the training stage). The synthesis tool implements a specific circuit for each constant being compared. By synthesizing comparisons with every possible constant (for example, in a 10-bit comparison, there are 1024 possible values for the constant in the other input), we can have a list of pre-synthesized comparators with area results associated to each constant. Then, whenever we train a DT/RF model to generate a RTL description, we can adjust the constants of its comparisons so that we reduce the area (and energy) of the comparators, based on the pre-synthesized list of standalone comparators. This adjustment is performed based on an approximation range m, which denotes how far from the original constant the algorithm can look for another constant with a smaller associated area.

We also implement another method for approximation denoted as DC [2], which applies Don't Care signals to the Least Significant Bits (LSBs) of the comparators, so that we can compare our results with a baseline model.

There RTL files can then be synthesized and simulated to obtain power, area, timing, and accuracy results.


## Requirements

**This implementation uses Cadence Genus and Irun to perform logic synthesis and simulation, respectively. Therefore, licenses are required.**

Also, this implementation requires some well-known Python libraries, such as SK, numpy, pandas, etc. Besides, the Boolean library is required (available at https://pypi.org/project/boolean.py/)

## Project Structure

This project is structured as follows:

* `run_trees.py` - This is the main script file that iterates through every preset configuration of approximate ranges, tree/forest parameters, quantization, etc. This script calls the methods for preprocess and train the data set, as well as generate the output (RTL and testbench) files for both the baseline and the approximate models (for C2PAx or DC). Optionally, we can synthesize the generated RTLs, but Cadence licenses are required.

* `presets.py` - Contains all the preset and configuration variables, such as the data sets to be used, the DT/RF configurations (tree depth, number of trees), the quantization level (this implementation considers 10-bit quantization), as well as the list of values for the approximation range `m` (`mList`) and the number of bits to be assigned DC values (`nrsBitsDC`). The chosen technique can be defined in the approxTechniques list. Other configuration presets can be defined here regarding the use of synthesis, the period, etc.

* `preprocessing.py` - Applies the quantization to the data. In this work, only 10-bit quantization is applied, due to results obtained in [1]. Other widths can be applied, as long as the comparators for that specific width are pre-synthesized and available to be used by C2PAx (and moved to the `presynthesized_comps/` directory).

* `train_translate.py` - Contains most utilities to train the SK structures and translate them to HDL descriptions (or to PDF files for visualization purposes). The `trainTestClf` method generates the SK structure and returns it, along with the accuracy of the baseline model (the accuracy of the approximate models can only be obtained through synthesis of the RTL files, as there are no equivalent associated SK structure). The `treeToHdl` method is the core of the translation to HDL, and it generates the lists and dictionaries to be used by the `gen_verilog.py` file in the mapping process. The `treeToHdl` method is the one that applies the C2PAx or DC method which are then mapped to Verilog.

* `gen_verilog.py` - Contains the methods to generate libraries, entities, comparators, majority gates, etc, in the Verilog syntax. This is used by the `train_translate.py` file.

* `exec_synth.sh` - Executes the synthesis of a RTL model (licenses are required).

* `clean_all.sh` - Cleans temporary files and the current results folder.

* `SYNTH/` - Synthesis environment. Must be set up properly based on the licenses available by the user. As default, this directory is not used, as it would require licenses, which are not free. Therefore, we only make the RTLs and testbenches available.

* `datasets/` - Contains the data sets to be used. We added an example file (`example.csv`) to be run.

* `presynthesized_comps/` - Contains the list of pre-synthesized comparators, for 10-bit width. To consider other sizes, you must synthesize the comparators with every possible constant of the desired width, and add the results to a CSV file, as in the `comp_10_map_0.csv` file inside this folder. This file ontains information on all the 1024 constants, regarding power and area. Only NAND2-Equivalent area is considered as metric in our implementation.


RTLs, testbenches, accuracy and synthesis results (requires licenses) are all generated inside the `RESULTS/` folder. An example is shown below.


## Running the code

An example is provided to be executed. We made a `dummy.csv` data set available (in the `datasets/` folder), which contains three classes. The parameters are already defined in the `presets.csv` file, regarding approximations desired, tree configurations and data sets.

To run the code:

```python
python run_trees.py
```

The RTL files are made available in the `RESULTS/` folder, inside the `HDL_trees/` or `HDL_forests/` folder, depending on the generated classifier. The baseline and approximate files (with different approximation ranges `m`) will be generated after execution.


## References

<font size="3"> [1] B.Abreu,M.Grellert,andS.Bampi,“Aframeworkfordesigningpower-efficientinferenceacceleratorsintree-based   learning   applications,”Engineering  Applications  of  ArtificialIntelligence,    vol.    109,    p.    104638,    2022.    [Online].    Available:https://www.sciencedirect.com/science/article/pii/S0952197621004462</font>
<font size="3"> [2] S.  Salamat,  M.  Ahmadi,  B.  Alizadeh,  and  M.  Fujita,  “Systematicapproximate logic optimization using Don’t Care conditions,” in201718th International Symposium on Quality Electronic Design (ISQED),2017, pp. 419–425.</font>
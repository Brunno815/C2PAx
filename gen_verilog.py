import math
import sys
from os import system
from math import ceil
from itertools import combinations
import numpy as np
import pandas as pd

useRegs = 0

#def print_file(fileHandler, codeLine):
	#print(codeLine, file=fileHandler)

def gen_register(fileHandler, _input, _output, size):
	
	if useRegs == 1:
		print("", file=fileHandler)
		print("\talways @(posedge CLK or posedge RST) begin", file=fileHandler)
		print("\t\tif(RST) begin", file=fileHandler)
		print("\t\t\t%s <= %d'b%s;" % (_output, size, "0"*size), file=fileHandler)
		print("\t\tend else begin", file=fileHandler)
		print("\t\t\t%s <= %s;" % (_output, _input), file=fileHandler)
		print("\t\tend", file=fileHandler)
		print("\tend", file=fileHandler)
		print("\n\n", file=fileHandler)
	else:
		print("", file=fileHandler)
		print("\tassign %s = %s;" % (_output, _input), file=fileHandler)


def gen_comparator(fileHandler, input1, input2, output):
	print("\tassign %s = (%s <= %s);" % (output, input1, input2), file=fileHandler)

def gen_maj(fileHandler, inputs, outputs):

	for _inputs, _output in zip(inputs, outputs):

		nrInputsMaj = len(_inputs)
		sizeTermMaj = int(ceil(nrInputsMaj/2.0))

		expr = ""
		nands = []

		for comb in combinations(_inputs, sizeTermMaj):
			nands.append("~(%s)" % (" & ".join(comb)))

		expr = "%s <= ~(%s);" % (_output, " & ".join(nands))

		print("\n", file=fileHandler)
		print("%s" % (expr), file=fileHandler)
		print("\n\n", file=fileHandler)


def gen_libraries(fileHandler, customLibraries = []):
	print("`timescale 1ns / 1ps", file=fileHandler)
	print("", file=fileHandler)

def gen_entity(fileHandler, nameEntity, inputs, outputs):
	print("module %s(" % (nameEntity), file=fileHandler)
	for _input in inputs:
		print("\t%s," % (_input["name"]), file=fileHandler)

	for idx, output in enumerate(outputs):
		print("\t%s" % (output["name"]), file=fileHandler)

	print(");", file=fileHandler)
	print("", file=fileHandler)
	print("", file=fileHandler)

	for _input in inputs:
		if _input["size"] > 1:
			print("\tinput [%d:0] %s;" % (_input["size"]-1, _input["name"]), file=fileHandler);
		else:
			print("\tinput wire %s;" % (_input["name"]), file=fileHandler);

	for idx, output in enumerate(outputs):
		if output["size"] > 1:
			print("\toutput %s[%d:0] %s;" % ("reg " if useRegs == 1 else "", output["size"]-1, output["name"]), file=fileHandler)
		else:
			print("\toutput %s%s;" % ("reg " if useRegs == 1 else "", output["name"]), file=fileHandler)

	print("", file=fileHandler)

	for _input in inputs:
		if (_input["name"] != "CLK") and (_input["name"] != "RST"):
			print("\t%s [%d:0] reg_%s;" % ("reg" if useRegs == 1 else "wire", _input["size"]-1, _input["name"]), file=fileHandler)
	
	for idx, output in enumerate(outputs):
		print("\twire [%d:0] reg_%s;" % (output["size"]-1, output["name"]), file=fileHandler)

	print("", file=fileHandler)


def gen_module_ands(fileHandler, signals, nr_out, isEntity = 0):
	
	if isEntity == 0:
		print("ANDS INST_ANDS(", file=fileHandler)
	else:
		print("module ANDS(", file=fileHandler)

	values = []

	for signal in signals:
		if ("comp" in signal['name']) and ("add" not in signal['name']):
			values.append(signal['name'])

	values.append("reg_decision")

	print(", ".join(values), file=fileHandler)
	print(");", file=fileHandler)
	print("", file=fileHandler)

	if isEntity == 1:
		for signal in signals:
			if ("comp" in signal['name']) and ("add" not in signal['name']):
				print("input [%d:0] %s;"  % (signal['size']-1, signal['name']), file=fileHandler)
		print("output [%d:0] reg_decision;" % (nr_out-1), file=fileHandler)
		print("", file=fileHandler)



def gen_module_comps(fileHandler, inputs, signals, isEntity = 0):

	if isEntity == 0:
		print("COMPS INST_COMP(", file=fileHandler)
	else:
		print("module COMPS(", file=fileHandler)
	
	values = []

	for _input in inputs:
		if "feat" in _input['name']:
			values.append("reg_" + _input['name'])

	for signal in signals:
		if ("comp" in signal['name']) and ("add" not in signal['name']):
			values.append(signal['name'])

	print(", ".join(values), file=fileHandler)
	print(");", file=fileHandler)
	print("", file=fileHandler)

	if isEntity == 1:
		for _input in inputs:
			if "feat" in _input['name']:
				print("input [%d:0] reg_%s;" % (_input['size']-1, _input['name']), file=fileHandler)
		for signal in signals:
			if ("comp" in signal['name']) and ("add" not in signal['name']):
				print("output [%d:0] %s;" % (signal['size']-1, signal['name']), file=fileHandler)
		print("", file=fileHandler)


def gen_signals_andsors(fileHandler, signals):
	for signal in signals:
		if ("and_" in signal['name']) or ("or_" in signal['name']) or ("add" in signal['name']) or ("sel" in signal['name']):
			print("wire [%d:0] %s;" % (signal['size']-1, signal['name']), file=fileHandler)
	print("", file=fileHandler)


def gen_signals_ctes(fileHandler, signals):
	for signal in signals:
		if "const" in signal['name']:
			print("wire [%d:0] %s;" % (signal['size']-1, signal['name']), file=fileHandler)
			print("assign %s = %d'b%s;" % (signal['name'], signal['size'], signal['const_value']), file=fileHandler)
	print("", file=fileHandler)

		

def gen_signals_comps(fileHandler, signals):
	for signal in signals:
		if ("comp" in signal["name"]) and ("add" not in signal['name']):
			print("wire [%d:0] %s;" % (signal['size']-1, signal['name']), file=fileHandler)


def gen_signals(fileHandler, signals):
	for signal in signals:
		if "reg" not in signal["name"]:
			print("wire [%d:0] %s;" % (signal["size"]-1, signal["name"]), file=fileHandler)

	for signal in signals:
		if "const" in signal["name"]:
			print("assign %s = %d'b%s;" % (signal["name"], signal["size"], signal["const_value"]), file=fileHandler)

	print("\n\n", file=fileHandler)


def gen_logic(fileHandler, attrs):
	for attr in attrs:
		print("%s <= %s %s %s;\n" % (attr[0], attr[1], attr[2], attr[3]), file=fileHandler)


def gen_ands_ors(fileHandler, exprs):
	for expr in exprs:
		vOp = ""
		if expr["op"] == "and":
			vOp = "&"
		elif expr["op"] == "or":
			vOp = "|"
		elif expr["op"] == "not":
			vOp = "~"
		elif expr["op"] == "&":
			vOp = ","
		else:
			vOp = expr["op"]

		expr2 = [x if x != "'0'" else "1'b0" for x in expr["ops"]]
		expr3 = [x if x != "'1'" else "1'b1" for x in expr2]

		expr4 = [x.replace("not", "~") for x in expr3]
		expr5 = [x.replace("&", ",") for x in expr4]
		expr6 = [x.replace("(","{").replace(")","}") if "," in x else x for x in expr5]

		if "sel_decision" in expr["out"]:
			print("assign %s = {%s};\n" % (expr["out"], (" %s " % (vOp)).join(expr6)), file=fileHandler)
		else:
			print("assign %s = %s;\n" % (expr["out"], (" %s " % (vOp)).join(expr6)), file=fileHandler)

	print("", file=fileHandler)


def gen_comps_priority(fileHandler, comps):
	for comp in comps:
		sepNums = []
		for x in comp['elems']:
			sepNums += x.split("_")[1:]
		codeCat = "_".join(sepNums)

		print("\tassign comp_add_%s = (%s >= %s);" % (codeCat, comp['elems'][0], comp['elems'][1]), file=fileHandler)
		print("\tassign add_%s = comp_add_%s ? %s : %s;" % (codeCat, codeCat, comp['elems'][0], comp['elems'][1]), file=fileHandler)


def gen_muxSels(fileHandler, muxSels):
	for muxSel in muxSels:
		print("assign %s =  (%s == %d'b%s) ? 1'b1 : 1'b0;" % (muxSel['output'].replace('(','[').replace(')',']'), muxSel['selector'], len(muxSel['decider']), muxSel['decider']), file=fileHandler)
		print("", file=fileHandler)


def gen_architecture(fileHandler, classifier, nameEntity, inputs, signals, registers, comparators, exprs, maj, nr_out = 2, comps = [], muxSels = []):

	gen_signals_comps(fileHandler, signals)

	gen_module_comps(fileHandler, inputs, signals, isEntity = 0)

	gen_module_ands(fileHandler, signals, nr_out, isEntity = 0)

	for register in registers:
		gen_register(fileHandler, register['input'], register['output'], register['size'])

	print("", file=fileHandler)

	print("endmodule", file=fileHandler)
	print("", file=fileHandler)
	print("", file=fileHandler)

	gen_module_comps(fileHandler, inputs, signals, isEntity = 1)

	gen_signals_ctes(fileHandler, signals)	

	for comparator in comparators:
		gen_comparator(fileHandler, comparator["in1"], comparator["in2"], comparator["out"])

	print("endmodule", file=fileHandler)
	print("", file=fileHandler)
	print("", file=fileHandler)

	gen_module_ands(fileHandler, signals, nr_out, isEntity = 1)

	gen_signals_andsors(fileHandler, signals)

	gen_ands_ors(fileHandler, exprs)

	if maj != []:
		gen_maj(fileHandler, maj['inputs'], maj['outputs'])

	if comps != []:
		gen_comps_priority(fileHandler, comps)

	if muxSels != []:
		gen_muxSels(fileHandler, muxSels)

	print("", file=fileHandler)

	if classifier == 'tree':
		if nr_out == 2:
			print("assign reg_decision = or_0;", file=fileHandler)
		else:
			for i in range(nr_out):
				print("assign reg_decision[%d] = or_%d;" % (i, i), file=fileHandler)

	print("", file=fileHandler)

	print("", file=fileHandler)

	print("endmodule", file=fileHandler)


def gen_tb(fileHandler, lines, inputs, outputs):

	print("`timescale 1ns / 1ps\n", file=fileHandler)
	print("module tst;\n", file=fileHandler)
	print("\tparameter", file=fileHandler)
	print("\t\tINPUT_PATH=\"./\",", file=fileHandler)
	print("\t\tPERIOD=60,", file=fileHandler)

	print("\t\tQTD=%d;\n" % (lines+1), file=fileHandler)

	print("\tparameter", file=fileHandler)
	print("\t\tKBITS=64;\n", file=fileHandler)
	
	print("\treg [KBITS-1:0] K;", file=fileHandler)
	
	###### INSERT THE INPUTS AND OUTPUTS HERE ######
	list_ins = []
	for _input in inputs:
		if _input['name'] != 'RST' and _input['name'] != 'CLK':
			print("\twire [%d-1:0] %s;" % (_input['size'], _input['name']), file=fileHandler)
			list_ins.append(_input['name'])

	list_outs = []
	for _output in outputs:
		print("\twire [%s-1:0] %s;\n" % (_output['size'], _output['name']), file=fileHandler)
		list_outs.append(_output['name'])
	################################################

	print("\tinteger f, i;", file=fileHandler)

	if list_ins != []:
		print("\tINPUTS_ALL #(INPUT_PATH,QTD,KBITS) ROM1 (K,%s);" % (",".join(list_ins)), file=fileHandler)
	print("\treg CLK;", file=fileHandler)

	if list_ins != []:
		print("\tdecision DUT(%s,CLK,1'b0,%s);" % (",".join(list_ins), ",".join(list_outs)), file=fileHandler)
	else:
		print("\tdecision DUT(CLK,1'b0,%s);" % (",".join(list_outs)), file=fileHandler)

	print("\tinitial CLK = 1'b0;", file=fileHandler)
	print("\talways #(PERIOD/2) CLK = ~CLK;\n", file=fileHandler)

	print("\tinitial", file=fileHandler)
	print("\tbegin", file=fileHandler)
	print("\t\ti = 0;", file=fileHandler)
	print('\t\tf = $fopen("predict.txt", "w");', file=fileHandler)
	print("\t\tfor (K=0; K < QTD-1; K=K+1)", file=fileHandler)
	print("\t\tbegin", file=fileHandler)
	print("\t\t\t@(negedge CLK);", file=fileHandler)
	print("\t\t\ti = i + 1;", file=fileHandler)
	print("\t\t\tif (i >= 1)", file=fileHandler)
	print("\t\t\tbegin", file=fileHandler)
	print('\t\t\t\t$fwrite(f, "%b\\n", decision);', file=fileHandler)
	print("\t\t\tend", file=fileHandler)
	print("\t\tend", file=fileHandler)
	print("\t\t$fclose(f);",file=fileHandler)
	print("\t\t$finish;", file=fileHandler)
	print("\tend", file=fileHandler)
	print("endmodule\n", file=fileHandler)

	if list_ins != []:
		print("module INPUTS_ALL(K,%s);" % (",".join(list_ins)), file=fileHandler)

		print("\tparameter", file=fileHandler)
		print("\t\tINPUT_PATH = \"./\",", file=fileHandler)
		print("\t\tLINHAS = %d," % (lines+1), file=fileHandler)
		print("\t\tNBITS = 64;\n", file=fileHandler)

		print("\tinput wire [NBITS-1:0] K;", file=fileHandler)

		for _input in inputs:
			if _input['name'] != 'RST' and _input['name'] != 'CLK':
				print("\toutput reg [%d-1:0] %s;" % (_input['size'], _input['name']), file=fileHandler)

		for _input in inputs:
			if _input['name'] != 'RST' and _input['name'] != 'CLK':
				print("\treg [%d-1:0] in_%s [0:LINHAS-1];" % (_input['size'], _input['name']), file=fileHandler)

		print("\n\tinitial", file=fileHandler)
		print("\tbegin", file=fileHandler)

		for _input in inputs:
			if _input['name'] != 'RST' and _input['name'] != 'CLK':
				print("\t\t$readmemb({INPUT_PATH,\"/\",\"%s.txt\"},in_%s);" % (_input['name'], _input['name']), file=fileHandler)

		print("\tend\n", file=fileHandler)
	
		print("\talways @( K )", file=fileHandler)
		print("\tbegin", file=fileHandler)

		for _input in inputs:
			if _input['name'] != 'RST' and _input['name'] != 'CLK':
				print("\t\t%s = in_%s[K];" % (_input['name'], _input['name']), file=fileHandler)

		print("\tend", file=fileHandler)
		print("endmodule", file=fileHandler)


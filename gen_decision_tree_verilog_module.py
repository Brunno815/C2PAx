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



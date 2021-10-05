`timescale 1ns / 1ps

module decision(
	feat_10,
	feat_14,
	feat_16,
	feat_12,
	feat_2,
	feat_11,
	feat_1,
	feat_17,
	feat_6,
	feat_8,
	feat_9,
	feat_7,
	feat_15,
	feat_0,
	feat_3,
	feat_13,
	feat_5,
	feat_4,
	CLK,
	RST,
	decision
);


	input [9:0] feat_10;
	input [9:0] feat_14;
	input [9:0] feat_16;
	input [9:0] feat_12;
	input [1:0] feat_2;
	input [9:0] feat_11;
	input wire feat_1;
	input [9:0] feat_17;
	input [9:0] feat_6;
	input [9:0] feat_8;
	input [9:0] feat_9;
	input [9:0] feat_7;
	input [9:0] feat_15;
	input [1:0] feat_0;
	input [1:0] feat_3;
	input [9:0] feat_13;
	input [1:0] feat_5;
	input [1:0] feat_4;
	input wire CLK;
	input wire RST;
	output [4:0] decision;

	wire [9:0] reg_feat_10;
	wire [9:0] reg_feat_14;
	wire [9:0] reg_feat_16;
	wire [9:0] reg_feat_12;
	wire [1:0] reg_feat_2;
	wire [9:0] reg_feat_11;
	wire [0:0] reg_feat_1;
	wire [9:0] reg_feat_17;
	wire [9:0] reg_feat_6;
	wire [9:0] reg_feat_8;
	wire [9:0] reg_feat_9;
	wire [9:0] reg_feat_7;
	wire [9:0] reg_feat_15;
	wire [1:0] reg_feat_0;
	wire [1:0] reg_feat_3;
	wire [9:0] reg_feat_13;
	wire [1:0] reg_feat_5;
	wire [1:0] reg_feat_4;
	wire [4:0] reg_decision;

wire [0:0] comp_feat_10_703;
wire [0:0] comp_feat_10_175;
wire [0:0] comp_feat_10_3;
wire [0:0] comp_feat_14_527;
wire [0:0] comp_feat_16_759;
wire [0:0] comp_feat_12_535;
wire [0:0] comp_feat_2_0;
wire [0:0] comp_feat_11_3;
wire [0:0] comp_feat_1_0;
wire [0:0] comp_feat_17_807;
wire [0:0] comp_feat_17_799;
wire [0:0] comp_feat_6_359;
wire [0:0] comp_feat_8_511;
wire [0:0] comp_feat_9_519;
wire [0:0] comp_feat_7_471;
wire [0:0] comp_feat_7_439;
wire [0:0] comp_feat_15_783;
wire [0:0] comp_feat_0_1;
wire [0:0] comp_feat_11_743;
wire [0:0] comp_feat_11_335;
wire [0:0] comp_feat_3_2;
wire [0:0] comp_feat_16_703;
wire [0:0] comp_feat_3_0;
wire [0:0] comp_feat_13_591;
wire [0:0] comp_feat_11_823;
wire [0:0] comp_feat_13_623;
wire [0:0] comp_feat_7_479;
wire [0:0] comp_feat_9_511;
wire [0:0] comp_feat_5_2;
wire [0:0] comp_feat_17_783;
wire [0:0] comp_feat_11_687;
wire [0:0] comp_feat_8_471;
wire [0:0] comp_feat_15_775;
wire [0:0] comp_feat_0_2;
wire [0:0] comp_feat_13_631;
wire [0:0] comp_feat_6_407;
wire [0:0] comp_feat_6_383;
wire [0:0] comp_feat_11_799;
wire [0:0] comp_feat_13_615;
wire [0:0] comp_feat_12_527;
wire [0:0] comp_feat_15_655;
wire [0:0] comp_feat_0_0;
wire [0:0] comp_feat_15_735;
wire [0:0] comp_feat_8_535;
wire [0:0] comp_feat_8_527;
wire [0:0] comp_feat_11_815;
wire [0:0] comp_feat_8_543;
wire [0:0] comp_feat_10_735;
wire [0:0] comp_feat_8_503;
wire [0:0] comp_feat_11_15;
wire [0:0] comp_feat_9_567;
wire [0:0] comp_feat_12_463;
wire [0:0] comp_feat_2_2;
wire [0:0] comp_feat_5_1;
wire [0:0] comp_feat_10_591;
wire [0:0] comp_feat_14_519;
wire [0:0] comp_feat_17_767;
wire [0:0] comp_feat_6_367;
wire [0:0] comp_feat_13_639;
wire [0:0] comp_feat_12_559;
wire [0:0] comp_feat_6_399;
wire [0:0] comp_feat_10_711;
wire [0:0] comp_feat_9_527;
wire [0:0] comp_feat_12_519;
wire [0:0] comp_feat_15_807;
wire [0:0] comp_feat_7_463;
wire [0:0] comp_feat_13_607;
wire [0:0] comp_feat_14_535;
wire [0:0] comp_feat_14_575;
wire [0:0] comp_feat_12_415;
wire [0:0] comp_feat_14_543;
wire [0:0] comp_feat_11_767;
wire [0:0] comp_feat_11_655;
wire [0:0] comp_feat_11_647;
wire [0:0] comp_feat_11_527;
wire [0:0] comp_feat_14_511;
wire [0:0] comp_feat_4_0;
wire [0:0] comp_feat_15_847;
wire [0:0] comp_feat_17_815;
wire [0:0] comp_feat_15_751;
wire [0:0] comp_feat_15_767;
wire [0:0] comp_feat_12_431;
wire [0:0] comp_feat_2_1;
wire [0:0] comp_feat_8_575;
wire [0:0] comp_feat_11_807;
wire [0:0] comp_feat_6_391;
wire [0:0] comp_feat_9_535;
wire [0:0] comp_feat_11_719;
wire [0:0] comp_feat_10_671;
wire [0:0] comp_feat_8_567;
wire [0:0] comp_feat_11_831;
wire [0:0] comp_feat_7_495;
wire [0:0] comp_feat_14_503;
wire [0:0] comp_feat_16_687;
wire [0:0] comp_feat_8_495;
wire [0:0] comp_feat_15_799;
wire [0:0] comp_feat_10_759;
wire [0:0] comp_feat_4_2;
wire [0:0] comp_feat_15_687;
wire [0:0] comp_feat_8_423;
wire [0:0] comp_feat_17_839;
wire [0:0] comp_feat_15_719;
wire [0:0] comp_feat_16_719;
wire [0:0] comp_feat_15_671;
wire [0:0] comp_feat_12_551;
wire [0:0] comp_feat_16_735;
wire [0:0] comp_feat_9_7;
wire [0:0] comp_feat_15_759;
wire [0:0] comp_feat_16_727;
wire [0:0] comp_feat_10_767;
wire [0:0] comp_feat_11_695;
wire [0:0] comp_feat_11_735;
wire [0:0] comp_feat_8_631;
wire [0:0] comp_feat_15_791;
wire [0:0] comp_feat_10_751;
wire [0:0] comp_feat_12_511;
wire [0:0] comp_feat_17_719;
wire [0:0] comp_feat_9_215;
wire [0:0] comp_feat_3_1;
wire [0:0] comp_feat_10_223;
wire [0:0] comp_feat_10_255;
wire [0:0] comp_feat_15_863;
wire [0:0] comp_feat_12_383;
wire [0:0] comp_feat_10_607;
wire [0:0] comp_feat_16_751;
wire [0:0] comp_feat_17_791;
wire [0:0] comp_feat_10_687;
wire [0:0] comp_feat_7_455;
wire [0:0] comp_feat_8_487;
wire [0:0] comp_feat_11_703;
wire [0:0] comp_feat_15_831;
wire [0:0] comp_feat_7_487;
wire [0:0] comp_feat_16_775;
wire [0:0] comp_feat_8_399;
wire [0:0] comp_feat_15_639;
wire [0:0] comp_feat_17_847;
COMPS INST_COMP(
reg_feat_10, reg_feat_14, reg_feat_16, reg_feat_12, reg_feat_2, reg_feat_11, reg_feat_1, reg_feat_17, reg_feat_6, reg_feat_8, reg_feat_9, reg_feat_7, reg_feat_15, reg_feat_0, reg_feat_3, reg_feat_13, reg_feat_5, reg_feat_4, comp_feat_10_703, comp_feat_10_175, comp_feat_10_3, comp_feat_14_527, comp_feat_16_759, comp_feat_12_535, comp_feat_2_0, comp_feat_11_3, comp_feat_1_0, comp_feat_17_807, comp_feat_17_799, comp_feat_6_359, comp_feat_8_511, comp_feat_9_519, comp_feat_7_471, comp_feat_7_439, comp_feat_15_783, comp_feat_0_1, comp_feat_11_743, comp_feat_11_335, comp_feat_3_2, comp_feat_16_703, comp_feat_3_0, comp_feat_13_591, comp_feat_11_823, comp_feat_13_623, comp_feat_7_479, comp_feat_9_511, comp_feat_5_2, comp_feat_17_783, comp_feat_11_687, comp_feat_8_471, comp_feat_15_775, comp_feat_0_2, comp_feat_13_631, comp_feat_6_407, comp_feat_6_383, comp_feat_11_799, comp_feat_13_615, comp_feat_12_527, comp_feat_15_655, comp_feat_0_0, comp_feat_15_735, comp_feat_8_535, comp_feat_8_527, comp_feat_11_815, comp_feat_8_543, comp_feat_10_735, comp_feat_8_503, comp_feat_11_15, comp_feat_9_567, comp_feat_12_463, comp_feat_2_2, comp_feat_5_1, comp_feat_10_591, comp_feat_14_519, comp_feat_17_767, comp_feat_6_367, comp_feat_13_639, comp_feat_12_559, comp_feat_6_399, comp_feat_10_711, comp_feat_9_527, comp_feat_12_519, comp_feat_15_807, comp_feat_7_463, comp_feat_13_607, comp_feat_14_535, comp_feat_14_575, comp_feat_12_415, comp_feat_14_543, comp_feat_11_767, comp_feat_11_655, comp_feat_11_647, comp_feat_11_527, comp_feat_14_511, comp_feat_4_0, comp_feat_15_847, comp_feat_17_815, comp_feat_15_751, comp_feat_15_767, comp_feat_12_431, comp_feat_2_1, comp_feat_8_575, comp_feat_11_807, comp_feat_6_391, comp_feat_9_535, comp_feat_11_719, comp_feat_10_671, comp_feat_8_567, comp_feat_11_831, comp_feat_7_495, comp_feat_14_503, comp_feat_16_687, comp_feat_8_495, comp_feat_15_799, comp_feat_10_759, comp_feat_4_2, comp_feat_15_687, comp_feat_8_423, comp_feat_17_839, comp_feat_15_719, comp_feat_16_719, comp_feat_15_671, comp_feat_12_551, comp_feat_16_735, comp_feat_9_7, comp_feat_15_759, comp_feat_16_727, comp_feat_10_767, comp_feat_11_695, comp_feat_11_735, comp_feat_8_631, comp_feat_15_791, comp_feat_10_751, comp_feat_12_511, comp_feat_17_719, comp_feat_9_215, comp_feat_3_1, comp_feat_10_223, comp_feat_10_255, comp_feat_15_863, comp_feat_12_383, comp_feat_10_607, comp_feat_16_751, comp_feat_17_791, comp_feat_10_687, comp_feat_7_455, comp_feat_8_487, comp_feat_11_703, comp_feat_15_831, comp_feat_7_487, comp_feat_16_775, comp_feat_8_399, comp_feat_15_639, comp_feat_17_847
);

ANDS INST_ANDS(
comp_feat_10_703, comp_feat_10_175, comp_feat_10_3, comp_feat_14_527, comp_feat_16_759, comp_feat_12_535, comp_feat_2_0, comp_feat_11_3, comp_feat_1_0, comp_feat_17_807, comp_feat_17_799, comp_feat_6_359, comp_feat_8_511, comp_feat_9_519, comp_feat_7_471, comp_feat_7_439, comp_feat_15_783, comp_feat_0_1, comp_feat_11_743, comp_feat_11_335, comp_feat_3_2, comp_feat_16_703, comp_feat_3_0, comp_feat_13_591, comp_feat_11_823, comp_feat_13_623, comp_feat_7_479, comp_feat_9_511, comp_feat_5_2, comp_feat_17_783, comp_feat_11_687, comp_feat_8_471, comp_feat_15_775, comp_feat_0_2, comp_feat_13_631, comp_feat_6_407, comp_feat_6_383, comp_feat_11_799, comp_feat_13_615, comp_feat_12_527, comp_feat_15_655, comp_feat_0_0, comp_feat_15_735, comp_feat_8_535, comp_feat_8_527, comp_feat_11_815, comp_feat_8_543, comp_feat_10_735, comp_feat_8_503, comp_feat_11_15, comp_feat_9_567, comp_feat_12_463, comp_feat_2_2, comp_feat_5_1, comp_feat_10_591, comp_feat_14_519, comp_feat_17_767, comp_feat_6_367, comp_feat_13_639, comp_feat_12_559, comp_feat_6_399, comp_feat_10_711, comp_feat_9_527, comp_feat_12_519, comp_feat_15_807, comp_feat_7_463, comp_feat_13_607, comp_feat_14_535, comp_feat_14_575, comp_feat_12_415, comp_feat_14_543, comp_feat_11_767, comp_feat_11_655, comp_feat_11_647, comp_feat_11_527, comp_feat_14_511, comp_feat_4_0, comp_feat_15_847, comp_feat_17_815, comp_feat_15_751, comp_feat_15_767, comp_feat_12_431, comp_feat_2_1, comp_feat_8_575, comp_feat_11_807, comp_feat_6_391, comp_feat_9_535, comp_feat_11_719, comp_feat_10_671, comp_feat_8_567, comp_feat_11_831, comp_feat_7_495, comp_feat_14_503, comp_feat_16_687, comp_feat_8_495, comp_feat_15_799, comp_feat_10_759, comp_feat_4_2, comp_feat_15_687, comp_feat_8_423, comp_feat_17_839, comp_feat_15_719, comp_feat_16_719, comp_feat_15_671, comp_feat_12_551, comp_feat_16_735, comp_feat_9_7, comp_feat_15_759, comp_feat_16_727, comp_feat_10_767, comp_feat_11_695, comp_feat_11_735, comp_feat_8_631, comp_feat_15_791, comp_feat_10_751, comp_feat_12_511, comp_feat_17_719, comp_feat_9_215, comp_feat_3_1, comp_feat_10_223, comp_feat_10_255, comp_feat_15_863, comp_feat_12_383, comp_feat_10_607, comp_feat_16_751, comp_feat_17_791, comp_feat_10_687, comp_feat_7_455, comp_feat_8_487, comp_feat_11_703, comp_feat_15_831, comp_feat_7_487, comp_feat_16_775, comp_feat_8_399, comp_feat_15_639, comp_feat_17_847, reg_decision
);


	assign reg_feat_10 = feat_10;

	assign reg_feat_14 = feat_14;

	assign reg_feat_16 = feat_16;

	assign reg_feat_12 = feat_12;

	assign reg_feat_2 = feat_2;

	assign reg_feat_11 = feat_11;

	assign reg_feat_1 = feat_1;

	assign reg_feat_17 = feat_17;

	assign reg_feat_6 = feat_6;

	assign reg_feat_8 = feat_8;

	assign reg_feat_9 = feat_9;

	assign reg_feat_7 = feat_7;

	assign reg_feat_15 = feat_15;

	assign reg_feat_0 = feat_0;

	assign reg_feat_3 = feat_3;

	assign reg_feat_13 = feat_13;

	assign reg_feat_5 = feat_5;

	assign reg_feat_4 = feat_4;

	assign decision = reg_decision;

endmodule


module COMPS(
reg_feat_10, reg_feat_14, reg_feat_16, reg_feat_12, reg_feat_2, reg_feat_11, reg_feat_1, reg_feat_17, reg_feat_6, reg_feat_8, reg_feat_9, reg_feat_7, reg_feat_15, reg_feat_0, reg_feat_3, reg_feat_13, reg_feat_5, reg_feat_4, comp_feat_10_703, comp_feat_10_175, comp_feat_10_3, comp_feat_14_527, comp_feat_16_759, comp_feat_12_535, comp_feat_2_0, comp_feat_11_3, comp_feat_1_0, comp_feat_17_807, comp_feat_17_799, comp_feat_6_359, comp_feat_8_511, comp_feat_9_519, comp_feat_7_471, comp_feat_7_439, comp_feat_15_783, comp_feat_0_1, comp_feat_11_743, comp_feat_11_335, comp_feat_3_2, comp_feat_16_703, comp_feat_3_0, comp_feat_13_591, comp_feat_11_823, comp_feat_13_623, comp_feat_7_479, comp_feat_9_511, comp_feat_5_2, comp_feat_17_783, comp_feat_11_687, comp_feat_8_471, comp_feat_15_775, comp_feat_0_2, comp_feat_13_631, comp_feat_6_407, comp_feat_6_383, comp_feat_11_799, comp_feat_13_615, comp_feat_12_527, comp_feat_15_655, comp_feat_0_0, comp_feat_15_735, comp_feat_8_535, comp_feat_8_527, comp_feat_11_815, comp_feat_8_543, comp_feat_10_735, comp_feat_8_503, comp_feat_11_15, comp_feat_9_567, comp_feat_12_463, comp_feat_2_2, comp_feat_5_1, comp_feat_10_591, comp_feat_14_519, comp_feat_17_767, comp_feat_6_367, comp_feat_13_639, comp_feat_12_559, comp_feat_6_399, comp_feat_10_711, comp_feat_9_527, comp_feat_12_519, comp_feat_15_807, comp_feat_7_463, comp_feat_13_607, comp_feat_14_535, comp_feat_14_575, comp_feat_12_415, comp_feat_14_543, comp_feat_11_767, comp_feat_11_655, comp_feat_11_647, comp_feat_11_527, comp_feat_14_511, comp_feat_4_0, comp_feat_15_847, comp_feat_17_815, comp_feat_15_751, comp_feat_15_767, comp_feat_12_431, comp_feat_2_1, comp_feat_8_575, comp_feat_11_807, comp_feat_6_391, comp_feat_9_535, comp_feat_11_719, comp_feat_10_671, comp_feat_8_567, comp_feat_11_831, comp_feat_7_495, comp_feat_14_503, comp_feat_16_687, comp_feat_8_495, comp_feat_15_799, comp_feat_10_759, comp_feat_4_2, comp_feat_15_687, comp_feat_8_423, comp_feat_17_839, comp_feat_15_719, comp_feat_16_719, comp_feat_15_671, comp_feat_12_551, comp_feat_16_735, comp_feat_9_7, comp_feat_15_759, comp_feat_16_727, comp_feat_10_767, comp_feat_11_695, comp_feat_11_735, comp_feat_8_631, comp_feat_15_791, comp_feat_10_751, comp_feat_12_511, comp_feat_17_719, comp_feat_9_215, comp_feat_3_1, comp_feat_10_223, comp_feat_10_255, comp_feat_15_863, comp_feat_12_383, comp_feat_10_607, comp_feat_16_751, comp_feat_17_791, comp_feat_10_687, comp_feat_7_455, comp_feat_8_487, comp_feat_11_703, comp_feat_15_831, comp_feat_7_487, comp_feat_16_775, comp_feat_8_399, comp_feat_15_639, comp_feat_17_847
);

input [9:0] reg_feat_10;
input [9:0] reg_feat_14;
input [9:0] reg_feat_16;
input [9:0] reg_feat_12;
input [1:0] reg_feat_2;
input [9:0] reg_feat_11;
input [0:0] reg_feat_1;
input [9:0] reg_feat_17;
input [9:0] reg_feat_6;
input [9:0] reg_feat_8;
input [9:0] reg_feat_9;
input [9:0] reg_feat_7;
input [9:0] reg_feat_15;
input [1:0] reg_feat_0;
input [1:0] reg_feat_3;
input [9:0] reg_feat_13;
input [1:0] reg_feat_5;
input [1:0] reg_feat_4;
output [0:0] comp_feat_10_703;
output [0:0] comp_feat_10_175;
output [0:0] comp_feat_10_3;
output [0:0] comp_feat_14_527;
output [0:0] comp_feat_16_759;
output [0:0] comp_feat_12_535;
output [0:0] comp_feat_2_0;
output [0:0] comp_feat_11_3;
output [0:0] comp_feat_1_0;
output [0:0] comp_feat_17_807;
output [0:0] comp_feat_17_799;
output [0:0] comp_feat_6_359;
output [0:0] comp_feat_8_511;
output [0:0] comp_feat_9_519;
output [0:0] comp_feat_7_471;
output [0:0] comp_feat_7_439;
output [0:0] comp_feat_15_783;
output [0:0] comp_feat_0_1;
output [0:0] comp_feat_11_743;
output [0:0] comp_feat_11_335;
output [0:0] comp_feat_3_2;
output [0:0] comp_feat_16_703;
output [0:0] comp_feat_3_0;
output [0:0] comp_feat_13_591;
output [0:0] comp_feat_11_823;
output [0:0] comp_feat_13_623;
output [0:0] comp_feat_7_479;
output [0:0] comp_feat_9_511;
output [0:0] comp_feat_5_2;
output [0:0] comp_feat_17_783;
output [0:0] comp_feat_11_687;
output [0:0] comp_feat_8_471;
output [0:0] comp_feat_15_775;
output [0:0] comp_feat_0_2;
output [0:0] comp_feat_13_631;
output [0:0] comp_feat_6_407;
output [0:0] comp_feat_6_383;
output [0:0] comp_feat_11_799;
output [0:0] comp_feat_13_615;
output [0:0] comp_feat_12_527;
output [0:0] comp_feat_15_655;
output [0:0] comp_feat_0_0;
output [0:0] comp_feat_15_735;
output [0:0] comp_feat_8_535;
output [0:0] comp_feat_8_527;
output [0:0] comp_feat_11_815;
output [0:0] comp_feat_8_543;
output [0:0] comp_feat_10_735;
output [0:0] comp_feat_8_503;
output [0:0] comp_feat_11_15;
output [0:0] comp_feat_9_567;
output [0:0] comp_feat_12_463;
output [0:0] comp_feat_2_2;
output [0:0] comp_feat_5_1;
output [0:0] comp_feat_10_591;
output [0:0] comp_feat_14_519;
output [0:0] comp_feat_17_767;
output [0:0] comp_feat_6_367;
output [0:0] comp_feat_13_639;
output [0:0] comp_feat_12_559;
output [0:0] comp_feat_6_399;
output [0:0] comp_feat_10_711;
output [0:0] comp_feat_9_527;
output [0:0] comp_feat_12_519;
output [0:0] comp_feat_15_807;
output [0:0] comp_feat_7_463;
output [0:0] comp_feat_13_607;
output [0:0] comp_feat_14_535;
output [0:0] comp_feat_14_575;
output [0:0] comp_feat_12_415;
output [0:0] comp_feat_14_543;
output [0:0] comp_feat_11_767;
output [0:0] comp_feat_11_655;
output [0:0] comp_feat_11_647;
output [0:0] comp_feat_11_527;
output [0:0] comp_feat_14_511;
output [0:0] comp_feat_4_0;
output [0:0] comp_feat_15_847;
output [0:0] comp_feat_17_815;
output [0:0] comp_feat_15_751;
output [0:0] comp_feat_15_767;
output [0:0] comp_feat_12_431;
output [0:0] comp_feat_2_1;
output [0:0] comp_feat_8_575;
output [0:0] comp_feat_11_807;
output [0:0] comp_feat_6_391;
output [0:0] comp_feat_9_535;
output [0:0] comp_feat_11_719;
output [0:0] comp_feat_10_671;
output [0:0] comp_feat_8_567;
output [0:0] comp_feat_11_831;
output [0:0] comp_feat_7_495;
output [0:0] comp_feat_14_503;
output [0:0] comp_feat_16_687;
output [0:0] comp_feat_8_495;
output [0:0] comp_feat_15_799;
output [0:0] comp_feat_10_759;
output [0:0] comp_feat_4_2;
output [0:0] comp_feat_15_687;
output [0:0] comp_feat_8_423;
output [0:0] comp_feat_17_839;
output [0:0] comp_feat_15_719;
output [0:0] comp_feat_16_719;
output [0:0] comp_feat_15_671;
output [0:0] comp_feat_12_551;
output [0:0] comp_feat_16_735;
output [0:0] comp_feat_9_7;
output [0:0] comp_feat_15_759;
output [0:0] comp_feat_16_727;
output [0:0] comp_feat_10_767;
output [0:0] comp_feat_11_695;
output [0:0] comp_feat_11_735;
output [0:0] comp_feat_8_631;
output [0:0] comp_feat_15_791;
output [0:0] comp_feat_10_751;
output [0:0] comp_feat_12_511;
output [0:0] comp_feat_17_719;
output [0:0] comp_feat_9_215;
output [0:0] comp_feat_3_1;
output [0:0] comp_feat_10_223;
output [0:0] comp_feat_10_255;
output [0:0] comp_feat_15_863;
output [0:0] comp_feat_12_383;
output [0:0] comp_feat_10_607;
output [0:0] comp_feat_16_751;
output [0:0] comp_feat_17_791;
output [0:0] comp_feat_10_687;
output [0:0] comp_feat_7_455;
output [0:0] comp_feat_8_487;
output [0:0] comp_feat_11_703;
output [0:0] comp_feat_15_831;
output [0:0] comp_feat_7_487;
output [0:0] comp_feat_16_775;
output [0:0] comp_feat_8_399;
output [0:0] comp_feat_15_639;
output [0:0] comp_feat_17_847;

wire [9:0] const_703_10;
assign const_703_10 = 10'b1010111111;
wire [9:0] const_175_10;
assign const_175_10 = 10'b0010101111;
wire [9:0] const_3_10;
assign const_3_10 = 10'b0000000011;
wire [9:0] const_527_10;
assign const_527_10 = 10'b1000001111;
wire [9:0] const_759_10;
assign const_759_10 = 10'b1011110111;
wire [9:0] const_535_10;
assign const_535_10 = 10'b1000010111;
wire [1:0] const_0_2;
assign const_0_2 = 2'b00;
wire [0:0] const_0_1;
assign const_0_1 = 1'b0;
wire [9:0] const_807_10;
assign const_807_10 = 10'b1100100111;
wire [9:0] const_799_10;
assign const_799_10 = 10'b1100011111;
wire [9:0] const_359_10;
assign const_359_10 = 10'b0101100111;
wire [9:0] const_511_10;
assign const_511_10 = 10'b0111111111;
wire [9:0] const_519_10;
assign const_519_10 = 10'b1000000111;
wire [9:0] const_471_10;
assign const_471_10 = 10'b0111010111;
wire [9:0] const_439_10;
assign const_439_10 = 10'b0110110111;
wire [9:0] const_783_10;
assign const_783_10 = 10'b1100001111;
wire [1:0] const_1_2;
assign const_1_2 = 2'b01;
wire [9:0] const_743_10;
assign const_743_10 = 10'b1011100111;
wire [9:0] const_335_10;
assign const_335_10 = 10'b0101001111;
wire [1:0] const_2_2;
assign const_2_2 = 2'b10;
wire [9:0] const_591_10;
assign const_591_10 = 10'b1001001111;
wire [9:0] const_823_10;
assign const_823_10 = 10'b1100110111;
wire [9:0] const_623_10;
assign const_623_10 = 10'b1001101111;
wire [9:0] const_479_10;
assign const_479_10 = 10'b0111011111;
wire [9:0] const_687_10;
assign const_687_10 = 10'b1010101111;
wire [9:0] const_775_10;
assign const_775_10 = 10'b1100000111;
wire [9:0] const_631_10;
assign const_631_10 = 10'b1001110111;
wire [9:0] const_407_10;
assign const_407_10 = 10'b0110010111;
wire [9:0] const_383_10;
assign const_383_10 = 10'b0101111111;
wire [9:0] const_615_10;
assign const_615_10 = 10'b1001100111;
wire [9:0] const_655_10;
assign const_655_10 = 10'b1010001111;
wire [9:0] const_735_10;
assign const_735_10 = 10'b1011011111;
wire [9:0] const_815_10;
assign const_815_10 = 10'b1100101111;
wire [9:0] const_543_10;
assign const_543_10 = 10'b1000011111;
wire [9:0] const_503_10;
assign const_503_10 = 10'b0111110111;
wire [9:0] const_15_10;
assign const_15_10 = 10'b0000001111;
wire [9:0] const_567_10;
assign const_567_10 = 10'b1000110111;
wire [9:0] const_463_10;
assign const_463_10 = 10'b0111001111;
wire [9:0] const_767_10;
assign const_767_10 = 10'b1011111111;
wire [9:0] const_367_10;
assign const_367_10 = 10'b0101101111;
wire [9:0] const_639_10;
assign const_639_10 = 10'b1001111111;
wire [9:0] const_559_10;
assign const_559_10 = 10'b1000101111;
wire [9:0] const_399_10;
assign const_399_10 = 10'b0110001111;
wire [9:0] const_711_10;
assign const_711_10 = 10'b1011000111;
wire [9:0] const_607_10;
assign const_607_10 = 10'b1001011111;
wire [9:0] const_575_10;
assign const_575_10 = 10'b1000111111;
wire [9:0] const_415_10;
assign const_415_10 = 10'b0110011111;
wire [9:0] const_647_10;
assign const_647_10 = 10'b1010000111;
wire [9:0] const_847_10;
assign const_847_10 = 10'b1101001111;
wire [9:0] const_751_10;
assign const_751_10 = 10'b1011101111;
wire [9:0] const_431_10;
assign const_431_10 = 10'b0110101111;
wire [9:0] const_391_10;
assign const_391_10 = 10'b0110000111;
wire [9:0] const_719_10;
assign const_719_10 = 10'b1011001111;
wire [9:0] const_671_10;
assign const_671_10 = 10'b1010011111;
wire [9:0] const_831_10;
assign const_831_10 = 10'b1100111111;
wire [9:0] const_495_10;
assign const_495_10 = 10'b0111101111;
wire [9:0] const_423_10;
assign const_423_10 = 10'b0110100111;
wire [9:0] const_839_10;
assign const_839_10 = 10'b1101000111;
wire [9:0] const_551_10;
assign const_551_10 = 10'b1000100111;
wire [9:0] const_7_10;
assign const_7_10 = 10'b0000000111;
wire [9:0] const_727_10;
assign const_727_10 = 10'b1011010111;
wire [9:0] const_695_10;
assign const_695_10 = 10'b1010110111;
wire [9:0] const_791_10;
assign const_791_10 = 10'b1100010111;
wire [9:0] const_215_10;
assign const_215_10 = 10'b0011010111;
wire [9:0] const_223_10;
assign const_223_10 = 10'b0011011111;
wire [9:0] const_255_10;
assign const_255_10 = 10'b0011111111;
wire [9:0] const_863_10;
assign const_863_10 = 10'b1101011111;
wire [9:0] const_455_10;
assign const_455_10 = 10'b0111000111;
wire [9:0] const_487_10;
assign const_487_10 = 10'b0111100111;

	assign comp_feat_10_703 = (reg_feat_10 <= const_703_10);
	assign comp_feat_10_175 = (reg_feat_10 <= const_175_10);
	assign comp_feat_10_3 = (reg_feat_10 <= const_3_10);
	assign comp_feat_14_527 = (reg_feat_14 <= const_527_10);
	assign comp_feat_16_759 = (reg_feat_16 <= const_759_10);
	assign comp_feat_12_535 = (reg_feat_12 <= const_535_10);
	assign comp_feat_2_0 = (reg_feat_2 <= const_0_2);
	assign comp_feat_11_3 = (reg_feat_11 <= const_3_10);
	assign comp_feat_1_0 = (reg_feat_1 <= const_0_1);
	assign comp_feat_17_807 = (reg_feat_17 <= const_807_10);
	assign comp_feat_17_799 = (reg_feat_17 <= const_799_10);
	assign comp_feat_6_359 = (reg_feat_6 <= const_359_10);
	assign comp_feat_8_511 = (reg_feat_8 <= const_511_10);
	assign comp_feat_9_519 = (reg_feat_9 <= const_519_10);
	assign comp_feat_7_471 = (reg_feat_7 <= const_471_10);
	assign comp_feat_7_439 = (reg_feat_7 <= const_439_10);
	assign comp_feat_15_783 = (reg_feat_15 <= const_783_10);
	assign comp_feat_0_1 = (reg_feat_0 <= const_1_2);
	assign comp_feat_11_743 = (reg_feat_11 <= const_743_10);
	assign comp_feat_11_335 = (reg_feat_11 <= const_335_10);
	assign comp_feat_3_2 = (reg_feat_3 <= const_2_2);
	assign comp_feat_16_703 = (reg_feat_16 <= const_703_10);
	assign comp_feat_3_0 = (reg_feat_3 <= const_0_2);
	assign comp_feat_13_591 = (reg_feat_13 <= const_591_10);
	assign comp_feat_11_823 = (reg_feat_11 <= const_823_10);
	assign comp_feat_13_623 = (reg_feat_13 <= const_623_10);
	assign comp_feat_7_479 = (reg_feat_7 <= const_479_10);
	assign comp_feat_9_511 = (reg_feat_9 <= const_511_10);
	assign comp_feat_5_2 = (reg_feat_5 <= const_2_2);
	assign comp_feat_17_783 = (reg_feat_17 <= const_783_10);
	assign comp_feat_11_687 = (reg_feat_11 <= const_687_10);
	assign comp_feat_8_471 = (reg_feat_8 <= const_471_10);
	assign comp_feat_15_775 = (reg_feat_15 <= const_775_10);
	assign comp_feat_0_2 = (reg_feat_0 <= const_2_2);
	assign comp_feat_13_631 = (reg_feat_13 <= const_631_10);
	assign comp_feat_6_407 = (reg_feat_6 <= const_407_10);
	assign comp_feat_6_383 = (reg_feat_6 <= const_383_10);
	assign comp_feat_11_799 = (reg_feat_11 <= const_799_10);
	assign comp_feat_13_615 = (reg_feat_13 <= const_615_10);
	assign comp_feat_12_527 = (reg_feat_12 <= const_527_10);
	assign comp_feat_15_655 = (reg_feat_15 <= const_655_10);
	assign comp_feat_0_0 = (reg_feat_0 <= const_0_2);
	assign comp_feat_15_735 = (reg_feat_15 <= const_735_10);
	assign comp_feat_8_535 = (reg_feat_8 <= const_535_10);
	assign comp_feat_8_527 = (reg_feat_8 <= const_527_10);
	assign comp_feat_11_815 = (reg_feat_11 <= const_815_10);
	assign comp_feat_8_543 = (reg_feat_8 <= const_543_10);
	assign comp_feat_10_735 = (reg_feat_10 <= const_735_10);
	assign comp_feat_8_503 = (reg_feat_8 <= const_503_10);
	assign comp_feat_11_15 = (reg_feat_11 <= const_15_10);
	assign comp_feat_9_567 = (reg_feat_9 <= const_567_10);
	assign comp_feat_12_463 = (reg_feat_12 <= const_463_10);
	assign comp_feat_2_2 = (reg_feat_2 <= const_2_2);
	assign comp_feat_5_1 = (reg_feat_5 <= const_1_2);
	assign comp_feat_10_591 = (reg_feat_10 <= const_591_10);
	assign comp_feat_14_519 = (reg_feat_14 <= const_519_10);
	assign comp_feat_17_767 = (reg_feat_17 <= const_767_10);
	assign comp_feat_6_367 = (reg_feat_6 <= const_367_10);
	assign comp_feat_13_639 = (reg_feat_13 <= const_639_10);
	assign comp_feat_12_559 = (reg_feat_12 <= const_559_10);
	assign comp_feat_6_399 = (reg_feat_6 <= const_399_10);
	assign comp_feat_10_711 = (reg_feat_10 <= const_711_10);
	assign comp_feat_9_527 = (reg_feat_9 <= const_527_10);
	assign comp_feat_12_519 = (reg_feat_12 <= const_519_10);
	assign comp_feat_15_807 = (reg_feat_15 <= const_807_10);
	assign comp_feat_7_463 = (reg_feat_7 <= const_463_10);
	assign comp_feat_13_607 = (reg_feat_13 <= const_607_10);
	assign comp_feat_14_535 = (reg_feat_14 <= const_535_10);
	assign comp_feat_14_575 = (reg_feat_14 <= const_575_10);
	assign comp_feat_12_415 = (reg_feat_12 <= const_415_10);
	assign comp_feat_14_543 = (reg_feat_14 <= const_543_10);
	assign comp_feat_11_767 = (reg_feat_11 <= const_767_10);
	assign comp_feat_11_655 = (reg_feat_11 <= const_655_10);
	assign comp_feat_11_647 = (reg_feat_11 <= const_647_10);
	assign comp_feat_11_527 = (reg_feat_11 <= const_527_10);
	assign comp_feat_14_511 = (reg_feat_14 <= const_511_10);
	assign comp_feat_4_0 = (reg_feat_4 <= const_0_2);
	assign comp_feat_15_847 = (reg_feat_15 <= const_847_10);
	assign comp_feat_17_815 = (reg_feat_17 <= const_815_10);
	assign comp_feat_15_751 = (reg_feat_15 <= const_751_10);
	assign comp_feat_15_767 = (reg_feat_15 <= const_767_10);
	assign comp_feat_12_431 = (reg_feat_12 <= const_431_10);
	assign comp_feat_2_1 = (reg_feat_2 <= const_1_2);
	assign comp_feat_8_575 = (reg_feat_8 <= const_575_10);
	assign comp_feat_11_807 = (reg_feat_11 <= const_807_10);
	assign comp_feat_6_391 = (reg_feat_6 <= const_391_10);
	assign comp_feat_9_535 = (reg_feat_9 <= const_535_10);
	assign comp_feat_11_719 = (reg_feat_11 <= const_719_10);
	assign comp_feat_10_671 = (reg_feat_10 <= const_671_10);
	assign comp_feat_8_567 = (reg_feat_8 <= const_567_10);
	assign comp_feat_11_831 = (reg_feat_11 <= const_831_10);
	assign comp_feat_7_495 = (reg_feat_7 <= const_495_10);
	assign comp_feat_14_503 = (reg_feat_14 <= const_503_10);
	assign comp_feat_16_687 = (reg_feat_16 <= const_687_10);
	assign comp_feat_8_495 = (reg_feat_8 <= const_495_10);
	assign comp_feat_15_799 = (reg_feat_15 <= const_799_10);
	assign comp_feat_10_759 = (reg_feat_10 <= const_759_10);
	assign comp_feat_4_2 = (reg_feat_4 <= const_2_2);
	assign comp_feat_15_687 = (reg_feat_15 <= const_687_10);
	assign comp_feat_8_423 = (reg_feat_8 <= const_423_10);
	assign comp_feat_17_839 = (reg_feat_17 <= const_839_10);
	assign comp_feat_15_719 = (reg_feat_15 <= const_719_10);
	assign comp_feat_16_719 = (reg_feat_16 <= const_719_10);
	assign comp_feat_15_671 = (reg_feat_15 <= const_671_10);
	assign comp_feat_12_551 = (reg_feat_12 <= const_551_10);
	assign comp_feat_16_735 = (reg_feat_16 <= const_735_10);
	assign comp_feat_9_7 = (reg_feat_9 <= const_7_10);
	assign comp_feat_15_759 = (reg_feat_15 <= const_759_10);
	assign comp_feat_16_727 = (reg_feat_16 <= const_727_10);
	assign comp_feat_10_767 = (reg_feat_10 <= const_767_10);
	assign comp_feat_11_695 = (reg_feat_11 <= const_695_10);
	assign comp_feat_11_735 = (reg_feat_11 <= const_735_10);
	assign comp_feat_8_631 = (reg_feat_8 <= const_631_10);
	assign comp_feat_15_791 = (reg_feat_15 <= const_791_10);
	assign comp_feat_10_751 = (reg_feat_10 <= const_751_10);
	assign comp_feat_12_511 = (reg_feat_12 <= const_511_10);
	assign comp_feat_17_719 = (reg_feat_17 <= const_719_10);
	assign comp_feat_9_215 = (reg_feat_9 <= const_215_10);
	assign comp_feat_3_1 = (reg_feat_3 <= const_1_2);
	assign comp_feat_10_223 = (reg_feat_10 <= const_223_10);
	assign comp_feat_10_255 = (reg_feat_10 <= const_255_10);
	assign comp_feat_15_863 = (reg_feat_15 <= const_863_10);
	assign comp_feat_12_383 = (reg_feat_12 <= const_383_10);
	assign comp_feat_10_607 = (reg_feat_10 <= const_607_10);
	assign comp_feat_16_751 = (reg_feat_16 <= const_751_10);
	assign comp_feat_17_791 = (reg_feat_17 <= const_791_10);
	assign comp_feat_10_687 = (reg_feat_10 <= const_687_10);
	assign comp_feat_7_455 = (reg_feat_7 <= const_455_10);
	assign comp_feat_8_487 = (reg_feat_8 <= const_487_10);
	assign comp_feat_11_703 = (reg_feat_11 <= const_703_10);
	assign comp_feat_15_831 = (reg_feat_15 <= const_831_10);
	assign comp_feat_7_487 = (reg_feat_7 <= const_487_10);
	assign comp_feat_16_775 = (reg_feat_16 <= const_775_10);
	assign comp_feat_8_399 = (reg_feat_8 <= const_399_10);
	assign comp_feat_15_639 = (reg_feat_15 <= const_639_10);
	assign comp_feat_17_847 = (reg_feat_17 <= const_847_10);
endmodule


module ANDS(
comp_feat_10_703, comp_feat_10_175, comp_feat_10_3, comp_feat_14_527, comp_feat_16_759, comp_feat_12_535, comp_feat_2_0, comp_feat_11_3, comp_feat_1_0, comp_feat_17_807, comp_feat_17_799, comp_feat_6_359, comp_feat_8_511, comp_feat_9_519, comp_feat_7_471, comp_feat_7_439, comp_feat_15_783, comp_feat_0_1, comp_feat_11_743, comp_feat_11_335, comp_feat_3_2, comp_feat_16_703, comp_feat_3_0, comp_feat_13_591, comp_feat_11_823, comp_feat_13_623, comp_feat_7_479, comp_feat_9_511, comp_feat_5_2, comp_feat_17_783, comp_feat_11_687, comp_feat_8_471, comp_feat_15_775, comp_feat_0_2, comp_feat_13_631, comp_feat_6_407, comp_feat_6_383, comp_feat_11_799, comp_feat_13_615, comp_feat_12_527, comp_feat_15_655, comp_feat_0_0, comp_feat_15_735, comp_feat_8_535, comp_feat_8_527, comp_feat_11_815, comp_feat_8_543, comp_feat_10_735, comp_feat_8_503, comp_feat_11_15, comp_feat_9_567, comp_feat_12_463, comp_feat_2_2, comp_feat_5_1, comp_feat_10_591, comp_feat_14_519, comp_feat_17_767, comp_feat_6_367, comp_feat_13_639, comp_feat_12_559, comp_feat_6_399, comp_feat_10_711, comp_feat_9_527, comp_feat_12_519, comp_feat_15_807, comp_feat_7_463, comp_feat_13_607, comp_feat_14_535, comp_feat_14_575, comp_feat_12_415, comp_feat_14_543, comp_feat_11_767, comp_feat_11_655, comp_feat_11_647, comp_feat_11_527, comp_feat_14_511, comp_feat_4_0, comp_feat_15_847, comp_feat_17_815, comp_feat_15_751, comp_feat_15_767, comp_feat_12_431, comp_feat_2_1, comp_feat_8_575, comp_feat_11_807, comp_feat_6_391, comp_feat_9_535, comp_feat_11_719, comp_feat_10_671, comp_feat_8_567, comp_feat_11_831, comp_feat_7_495, comp_feat_14_503, comp_feat_16_687, comp_feat_8_495, comp_feat_15_799, comp_feat_10_759, comp_feat_4_2, comp_feat_15_687, comp_feat_8_423, comp_feat_17_839, comp_feat_15_719, comp_feat_16_719, comp_feat_15_671, comp_feat_12_551, comp_feat_16_735, comp_feat_9_7, comp_feat_15_759, comp_feat_16_727, comp_feat_10_767, comp_feat_11_695, comp_feat_11_735, comp_feat_8_631, comp_feat_15_791, comp_feat_10_751, comp_feat_12_511, comp_feat_17_719, comp_feat_9_215, comp_feat_3_1, comp_feat_10_223, comp_feat_10_255, comp_feat_15_863, comp_feat_12_383, comp_feat_10_607, comp_feat_16_751, comp_feat_17_791, comp_feat_10_687, comp_feat_7_455, comp_feat_8_487, comp_feat_11_703, comp_feat_15_831, comp_feat_7_487, comp_feat_16_775, comp_feat_8_399, comp_feat_15_639, comp_feat_17_847, reg_decision
);

input [0:0] comp_feat_10_703;
input [0:0] comp_feat_10_175;
input [0:0] comp_feat_10_3;
input [0:0] comp_feat_14_527;
input [0:0] comp_feat_16_759;
input [0:0] comp_feat_12_535;
input [0:0] comp_feat_2_0;
input [0:0] comp_feat_11_3;
input [0:0] comp_feat_1_0;
input [0:0] comp_feat_17_807;
input [0:0] comp_feat_17_799;
input [0:0] comp_feat_6_359;
input [0:0] comp_feat_8_511;
input [0:0] comp_feat_9_519;
input [0:0] comp_feat_7_471;
input [0:0] comp_feat_7_439;
input [0:0] comp_feat_15_783;
input [0:0] comp_feat_0_1;
input [0:0] comp_feat_11_743;
input [0:0] comp_feat_11_335;
input [0:0] comp_feat_3_2;
input [0:0] comp_feat_16_703;
input [0:0] comp_feat_3_0;
input [0:0] comp_feat_13_591;
input [0:0] comp_feat_11_823;
input [0:0] comp_feat_13_623;
input [0:0] comp_feat_7_479;
input [0:0] comp_feat_9_511;
input [0:0] comp_feat_5_2;
input [0:0] comp_feat_17_783;
input [0:0] comp_feat_11_687;
input [0:0] comp_feat_8_471;
input [0:0] comp_feat_15_775;
input [0:0] comp_feat_0_2;
input [0:0] comp_feat_13_631;
input [0:0] comp_feat_6_407;
input [0:0] comp_feat_6_383;
input [0:0] comp_feat_11_799;
input [0:0] comp_feat_13_615;
input [0:0] comp_feat_12_527;
input [0:0] comp_feat_15_655;
input [0:0] comp_feat_0_0;
input [0:0] comp_feat_15_735;
input [0:0] comp_feat_8_535;
input [0:0] comp_feat_8_527;
input [0:0] comp_feat_11_815;
input [0:0] comp_feat_8_543;
input [0:0] comp_feat_10_735;
input [0:0] comp_feat_8_503;
input [0:0] comp_feat_11_15;
input [0:0] comp_feat_9_567;
input [0:0] comp_feat_12_463;
input [0:0] comp_feat_2_2;
input [0:0] comp_feat_5_1;
input [0:0] comp_feat_10_591;
input [0:0] comp_feat_14_519;
input [0:0] comp_feat_17_767;
input [0:0] comp_feat_6_367;
input [0:0] comp_feat_13_639;
input [0:0] comp_feat_12_559;
input [0:0] comp_feat_6_399;
input [0:0] comp_feat_10_711;
input [0:0] comp_feat_9_527;
input [0:0] comp_feat_12_519;
input [0:0] comp_feat_15_807;
input [0:0] comp_feat_7_463;
input [0:0] comp_feat_13_607;
input [0:0] comp_feat_14_535;
input [0:0] comp_feat_14_575;
input [0:0] comp_feat_12_415;
input [0:0] comp_feat_14_543;
input [0:0] comp_feat_11_767;
input [0:0] comp_feat_11_655;
input [0:0] comp_feat_11_647;
input [0:0] comp_feat_11_527;
input [0:0] comp_feat_14_511;
input [0:0] comp_feat_4_0;
input [0:0] comp_feat_15_847;
input [0:0] comp_feat_17_815;
input [0:0] comp_feat_15_751;
input [0:0] comp_feat_15_767;
input [0:0] comp_feat_12_431;
input [0:0] comp_feat_2_1;
input [0:0] comp_feat_8_575;
input [0:0] comp_feat_11_807;
input [0:0] comp_feat_6_391;
input [0:0] comp_feat_9_535;
input [0:0] comp_feat_11_719;
input [0:0] comp_feat_10_671;
input [0:0] comp_feat_8_567;
input [0:0] comp_feat_11_831;
input [0:0] comp_feat_7_495;
input [0:0] comp_feat_14_503;
input [0:0] comp_feat_16_687;
input [0:0] comp_feat_8_495;
input [0:0] comp_feat_15_799;
input [0:0] comp_feat_10_759;
input [0:0] comp_feat_4_2;
input [0:0] comp_feat_15_687;
input [0:0] comp_feat_8_423;
input [0:0] comp_feat_17_839;
input [0:0] comp_feat_15_719;
input [0:0] comp_feat_16_719;
input [0:0] comp_feat_15_671;
input [0:0] comp_feat_12_551;
input [0:0] comp_feat_16_735;
input [0:0] comp_feat_9_7;
input [0:0] comp_feat_15_759;
input [0:0] comp_feat_16_727;
input [0:0] comp_feat_10_767;
input [0:0] comp_feat_11_695;
input [0:0] comp_feat_11_735;
input [0:0] comp_feat_8_631;
input [0:0] comp_feat_15_791;
input [0:0] comp_feat_10_751;
input [0:0] comp_feat_12_511;
input [0:0] comp_feat_17_719;
input [0:0] comp_feat_9_215;
input [0:0] comp_feat_3_1;
input [0:0] comp_feat_10_223;
input [0:0] comp_feat_10_255;
input [0:0] comp_feat_15_863;
input [0:0] comp_feat_12_383;
input [0:0] comp_feat_10_607;
input [0:0] comp_feat_16_751;
input [0:0] comp_feat_17_791;
input [0:0] comp_feat_10_687;
input [0:0] comp_feat_7_455;
input [0:0] comp_feat_8_487;
input [0:0] comp_feat_11_703;
input [0:0] comp_feat_15_831;
input [0:0] comp_feat_7_487;
input [0:0] comp_feat_16_775;
input [0:0] comp_feat_8_399;
input [0:0] comp_feat_15_639;
input [0:0] comp_feat_17_847;
output [4:0] reg_decision;

wire [2:0] add_0;
wire [2:0] add_1;
wire [2:0] add_2;
wire [2:0] add_3;
wire [2:0] add_4;
wire [0:0] comp_add_0_1;
wire [0:0] comp_add_2_3;
wire [0:0] comp_add_0_1_2_3;
wire [0:0] comp_add_0_1_2_3_4;
wire [2:0] add_0_1;
wire [2:0] add_2_3;
wire [2:0] add_0_1_2_3;
wire [2:0] add_0_1_2_3_4;
wire [2:0] sel_decision_0;
wire [2:0] sel_decision_1;
wire [2:0] sel_decision_2;
wire [2:0] sel_decision_3;
wire [0:0] sel_decision_4;
wire [0:0] and_0;
wire [0:0] and_1;
wire [0:0] and_2;
wire [0:0] and_3;
wire [0:0] or_0;
wire [0:0] and_4;
wire [0:0] and_5;
wire [0:0] and_6;
wire [0:0] and_7;
wire [0:0] and_8;
wire [0:0] and_9;
wire [0:0] and_10;
wire [0:0] and_11;
wire [0:0] and_12;
wire [0:0] and_13;
wire [0:0] and_14;
wire [0:0] or_1;
wire [0:0] and_15;
wire [0:0] and_16;
wire [0:0] and_17;
wire [0:0] and_18;
wire [0:0] and_19;
wire [0:0] and_20;
wire [0:0] and_21;
wire [0:0] or_2;
wire [0:0] and_22;
wire [0:0] and_23;
wire [0:0] and_24;
wire [0:0] and_25;
wire [0:0] and_26;
wire [0:0] and_27;
wire [0:0] and_28;
wire [0:0] and_29;
wire [0:0] and_30;
wire [0:0] and_31;
wire [0:0] and_32;
wire [0:0] and_33;
wire [0:0] or_3;
wire [0:0] and_34;
wire [0:0] and_35;
wire [0:0] and_36;
wire [0:0] and_37;
wire [0:0] and_38;
wire [0:0] and_39;
wire [0:0] and_40;
wire [0:0] and_41;
wire [0:0] and_42;
wire [0:0] and_43;
wire [0:0] and_44;
wire [0:0] and_45;
wire [0:0] and_46;
wire [0:0] and_47;
wire [0:0] and_48;
wire [0:0] and_49;
wire [0:0] and_50;
wire [0:0] and_51;
wire [0:0] and_52;
wire [0:0] or_4;
wire [0:0] and_53;
wire [0:0] and_54;
wire [0:0] and_55;
wire [0:0] and_56;
wire [0:0] and_57;
wire [0:0] and_58;
wire [0:0] and_59;
wire [0:0] and_60;
wire [0:0] and_61;
wire [0:0] or_5;
wire [0:0] and_62;
wire [0:0] and_63;
wire [0:0] and_64;
wire [0:0] and_65;
wire [0:0] and_66;
wire [0:0] and_67;
wire [0:0] and_68;
wire [0:0] and_69;
wire [0:0] and_70;
wire [0:0] and_71;
wire [0:0] and_72;
wire [0:0] or_6;
wire [0:0] and_73;
wire [0:0] and_74;
wire [0:0] and_75;
wire [0:0] and_76;
wire [0:0] and_77;
wire [0:0] and_78;
wire [0:0] and_79;
wire [0:0] and_80;
wire [0:0] and_81;
wire [0:0] and_82;
wire [0:0] or_7;
wire [0:0] and_83;
wire [0:0] and_84;
wire [0:0] and_85;
wire [0:0] and_86;
wire [0:0] and_87;
wire [0:0] and_88;
wire [0:0] and_89;
wire [0:0] or_8;
wire [0:0] and_90;
wire [0:0] and_91;
wire [0:0] and_92;
wire [0:0] and_93;
wire [0:0] and_94;
wire [0:0] and_95;
wire [0:0] and_96;
wire [0:0] and_97;
wire [0:0] and_98;
wire [0:0] and_99;
wire [0:0] and_100;
wire [0:0] and_101;
wire [0:0] and_102;
wire [0:0] or_9;
wire [0:0] and_103;
wire [0:0] and_104;
wire [0:0] and_105;
wire [0:0] and_106;
wire [0:0] and_107;
wire [0:0] and_108;
wire [0:0] and_109;
wire [0:0] and_110;
wire [0:0] or_10;
wire [0:0] and_111;
wire [0:0] and_112;
wire [0:0] and_113;
wire [0:0] and_114;
wire [0:0] and_115;
wire [0:0] and_116;
wire [0:0] and_117;
wire [0:0] and_118;
wire [0:0] and_119;
wire [0:0] and_120;
wire [0:0] and_121;
wire [0:0] and_122;
wire [0:0] or_11;
wire [0:0] and_123;
wire [0:0] and_124;
wire [0:0] and_125;
wire [0:0] and_126;
wire [0:0] and_127;
wire [0:0] and_128;
wire [0:0] and_129;
wire [0:0] or_12;
wire [0:0] and_130;
wire [0:0] and_131;
wire [0:0] and_132;
wire [0:0] and_133;
wire [0:0] and_134;
wire [0:0] and_135;
wire [0:0] and_136;
wire [0:0] and_137;
wire [0:0] and_138;
wire [0:0] and_139;
wire [0:0] and_140;
wire [0:0] and_141;
wire [0:0] or_13;
wire [0:0] and_142;
wire [0:0] and_143;
wire [0:0] and_144;
wire [0:0] and_145;
wire [0:0] and_146;
wire [0:0] and_147;
wire [0:0] and_148;
wire [0:0] and_149;
wire [0:0] and_150;
wire [0:0] and_151;
wire [0:0] and_152;
wire [0:0] and_153;
wire [0:0] and_154;
wire [0:0] and_155;
wire [0:0] and_156;
wire [0:0] and_157;
wire [0:0] or_14;
wire [0:0] and_158;
wire [0:0] and_159;
wire [0:0] and_160;
wire [0:0] and_161;
wire [0:0] and_162;
wire [0:0] and_163;
wire [0:0] and_164;
wire [0:0] and_165;
wire [0:0] and_166;
wire [0:0] or_15;
wire [0:0] and_167;
wire [0:0] and_168;
wire [0:0] and_169;
wire [0:0] and_170;
wire [0:0] and_171;
wire [0:0] and_172;
wire [0:0] and_173;
wire [0:0] and_174;
wire [0:0] and_175;
wire [0:0] and_176;
wire [0:0] and_177;
wire [0:0] and_178;
wire [0:0] or_16;
wire [0:0] and_179;
wire [0:0] and_180;
wire [0:0] and_181;
wire [0:0] and_182;
wire [0:0] and_183;
wire [0:0] or_17;
wire [0:0] and_184;
wire [0:0] and_185;
wire [0:0] and_186;
wire [0:0] and_187;
wire [0:0] and_188;
wire [0:0] and_189;
wire [0:0] and_190;
wire [0:0] and_191;
wire [0:0] and_192;
wire [0:0] and_193;
wire [0:0] and_194;
wire [0:0] or_18;
wire [0:0] and_195;
wire [0:0] and_196;
wire [0:0] and_197;
wire [0:0] and_198;
wire [0:0] and_199;
wire [0:0] and_200;
wire [0:0] and_201;
wire [0:0] and_202;
wire [0:0] and_203;
wire [0:0] and_204;
wire [0:0] and_205;
wire [0:0] and_206;
wire [0:0] and_207;
wire [0:0] and_208;
wire [0:0] and_209;
wire [0:0] and_210;
wire [0:0] and_211;
wire [0:0] or_19;
wire [0:0] and_212;
wire [0:0] and_213;
wire [0:0] and_214;
wire [0:0] and_215;
wire [0:0] and_216;
wire [0:0] and_217;
wire [0:0] or_20;
wire [0:0] and_218;
wire [0:0] and_219;
wire [0:0] and_220;
wire [0:0] and_221;
wire [0:0] and_222;
wire [0:0] and_223;
wire [0:0] and_224;
wire [0:0] and_225;
wire [0:0] and_226;
wire [0:0] or_21;
wire [0:0] and_227;
wire [0:0] and_228;
wire [0:0] and_229;
wire [0:0] and_230;
wire [0:0] or_22;
wire [0:0] and_231;
wire [0:0] and_232;
wire [0:0] and_233;
wire [0:0] and_234;
wire [0:0] and_235;
wire [0:0] and_236;
wire [0:0] and_237;
wire [0:0] and_238;
wire [0:0] and_239;
wire [0:0] and_240;
wire [0:0] and_241;
wire [0:0] or_23;
wire [0:0] and_242;
wire [0:0] and_243;
wire [0:0] and_244;
wire [0:0] and_245;
wire [0:0] and_246;
wire [0:0] and_247;
wire [0:0] and_248;
wire [0:0] and_249;
wire [0:0] and_250;
wire [0:0] and_251;
wire [0:0] and_252;
wire [0:0] and_253;
wire [0:0] and_254;
wire [0:0] and_255;
wire [0:0] and_256;
wire [0:0] and_257;
wire [0:0] and_258;
wire [0:0] and_259;
wire [0:0] or_24;

assign add_0 = {2'b00, or_0} + {2'b00, or_5} + {2'b00, or_10} + {2'b00, or_15} + {2'b00, or_20};

assign add_1 = {2'b00, or_1} + {2'b00, or_6} + {2'b00, or_11} + {2'b00, or_16} + {2'b00, or_21};

assign add_2 = {2'b00, or_2} + {2'b00, or_7} + {2'b00, or_12} + {2'b00, or_17} + {2'b00, or_22};

assign add_3 = {2'b00, or_3} + {2'b00, or_8} + {2'b00, or_13} + {2'b00, or_18} + {2'b00, or_23};

assign add_4 = {2'b00, or_4} + {2'b00, or_9} + {2'b00, or_14} + {2'b00, or_19} + {2'b00, or_24};

assign sel_decision_0 = {comp_add_0_1 , comp_add_0_1_2_3 , comp_add_0_1_2_3_4};

assign sel_decision_1 = {comp_add_0_1 , comp_add_0_1_2_3 , comp_add_0_1_2_3_4};

assign sel_decision_2 = {comp_add_2_3 , comp_add_0_1_2_3 , comp_add_0_1_2_3_4};

assign sel_decision_3 = {comp_add_2_3 , comp_add_0_1_2_3 , comp_add_0_1_2_3_4};

assign sel_decision_4 = {comp_add_0_1_2_3_4};

assign and_0 = comp_feat_10_703 & ~(comp_feat_10_175) & comp_feat_9_519 & comp_feat_7_471 & comp_feat_7_439 & ~(comp_feat_15_783);

assign and_1 = comp_feat_10_703 & ~(comp_feat_10_175) & comp_feat_9_519 & comp_feat_7_471 & ~(comp_feat_7_439) & comp_feat_0_1;

assign and_2 = comp_feat_10_703 & ~(comp_feat_10_175) & ~(comp_feat_9_519) & comp_feat_16_703 & ~(comp_feat_15_783) & ~(comp_feat_3_0);

assign and_3 = ~(comp_feat_10_703) & ~(comp_feat_7_479) & ~(comp_feat_6_407) & ~(comp_feat_15_735) & ~(comp_feat_8_527) & ~(comp_feat_11_815);

assign or_0 = and_0 | and_1 | and_2 | and_3;

assign and_4 = comp_feat_10_703 & comp_feat_10_175 & ~(comp_feat_10_3) & comp_feat_1_0 & ~(comp_feat_17_807) & ~(comp_feat_6_359);

assign and_5 = comp_feat_10_703 & comp_feat_10_175 & comp_feat_10_3 & ~(comp_feat_14_527) & ~(comp_feat_2_0);

assign and_6 = comp_feat_10_703 & ~(comp_feat_10_175) & comp_feat_9_519 & ~(comp_feat_7_471) & comp_feat_11_743 & comp_feat_11_335;

assign and_7 = comp_feat_10_703 & ~(comp_feat_10_175) & comp_feat_9_519 & ~(comp_feat_7_471) & ~(comp_feat_11_743) & comp_feat_3_2;

assign and_8 = comp_feat_10_703 & ~(comp_feat_10_175) & ~(comp_feat_9_519) & comp_feat_16_703 & comp_feat_15_783 & ~(comp_feat_17_799);

assign and_9 = comp_feat_10_703 & ~(comp_feat_10_175) & ~(comp_feat_9_519) & comp_feat_16_703 & ~(comp_feat_15_783) & comp_feat_3_0;

assign and_10 = comp_feat_10_703 & ~(comp_feat_10_175) & ~(comp_feat_9_519) & ~(comp_feat_16_703) & comp_feat_13_591 & ~(comp_feat_11_823);

assign and_11 = comp_feat_10_703 & ~(comp_feat_10_175) & ~(comp_feat_9_519) & ~(comp_feat_16_703) & ~(comp_feat_13_591) & comp_feat_13_623;

assign and_12 = ~(comp_feat_10_703) & comp_feat_7_479 & comp_feat_9_511 & ~(comp_feat_5_2) & comp_feat_8_471 & ~(comp_feat_14_527);

assign and_13 = ~(comp_feat_10_703) & ~(comp_feat_7_479) & ~(comp_feat_6_407) & comp_feat_15_735 & ~(comp_feat_8_535);

assign and_14 = ~(comp_feat_10_703) & ~(comp_feat_7_479) & ~(comp_feat_6_407) & ~(comp_feat_15_735) & ~(comp_feat_8_527) & comp_feat_11_815;

assign or_1 = and_4 | and_5 | and_6 | and_7 | and_8 | and_9 | and_10 | and_11 | and_12 | and_13 | and_14;

assign and_15 = comp_feat_10_703 & comp_feat_10_175 & ~(comp_feat_10_3) & ~(comp_feat_1_0) & ~(comp_feat_8_511) & comp_feat_12_535;

assign and_16 = comp_feat_10_703 & comp_feat_10_175 & comp_feat_10_3 & comp_feat_14_527 & comp_feat_16_759 & comp_feat_12_535;

assign and_17 = comp_feat_10_703 & comp_feat_10_175 & comp_feat_10_3 & ~(comp_feat_14_527) & comp_feat_2_0 & comp_feat_11_3;

assign and_18 = ~(comp_feat_10_703) & comp_feat_7_479 & comp_feat_9_511 & comp_feat_5_2 & ~(comp_feat_17_783) & comp_feat_11_687;

assign and_19 = ~(comp_feat_10_703) & comp_feat_7_479 & ~(comp_feat_9_511) & comp_feat_6_359 & ~(comp_feat_15_775) & ~(comp_feat_0_2);

assign and_20 = ~(comp_feat_10_703) & comp_feat_7_479 & ~(comp_feat_9_511) & ~(comp_feat_6_359) & comp_feat_13_631;

assign and_21 = ~(comp_feat_10_703) & ~(comp_feat_7_479) & comp_feat_6_407 & ~(comp_feat_6_383) & ~(comp_feat_12_527) & comp_feat_0_0;

assign or_2 = and_15 | and_16 | and_17 | and_18 | and_19 | and_20 | and_21;

assign and_22 = comp_feat_10_703 & comp_feat_10_175 & ~(comp_feat_10_3) & comp_feat_1_0 & ~(comp_feat_17_807) & comp_feat_6_359;

assign and_23 = comp_feat_10_703 & comp_feat_10_175 & ~(comp_feat_10_3) & ~(comp_feat_1_0) & comp_feat_8_511 & ~(comp_feat_17_799);

assign and_24 = comp_feat_10_703 & comp_feat_10_175 & comp_feat_10_3 & ~(comp_feat_14_527) & comp_feat_2_0 & ~(comp_feat_11_3);

assign and_25 = comp_feat_10_703 & ~(comp_feat_10_175) & comp_feat_9_519 & comp_feat_7_471 & comp_feat_7_439 & comp_feat_15_783;

assign and_26 = comp_feat_10_703 & ~(comp_feat_10_175) & comp_feat_9_519 & comp_feat_7_471 & ~(comp_feat_7_439) & ~(comp_feat_0_1);

assign and_27 = comp_feat_10_703 & ~(comp_feat_10_175) & comp_feat_9_519 & ~(comp_feat_7_471) & ~(comp_feat_11_743) & ~(comp_feat_3_2);

assign and_28 = comp_feat_10_703 & ~(comp_feat_10_175) & ~(comp_feat_9_519) & comp_feat_16_703 & comp_feat_15_783 & comp_feat_17_799;

assign and_29 = comp_feat_10_703 & ~(comp_feat_10_175) & ~(comp_feat_9_519) & ~(comp_feat_16_703) & comp_feat_13_591 & comp_feat_11_823;

assign and_30 = ~(comp_feat_10_703) & comp_feat_7_479 & comp_feat_9_511 & ~(comp_feat_5_2) & comp_feat_8_471 & comp_feat_14_527;

assign and_31 = ~(comp_feat_10_703) & ~(comp_feat_7_479) & comp_feat_6_407 & comp_feat_6_383 & ~(comp_feat_11_799) & comp_feat_13_615;

assign and_32 = ~(comp_feat_10_703) & ~(comp_feat_7_479) & comp_feat_6_407 & ~(comp_feat_6_383) & comp_feat_12_527 & comp_feat_15_655;

assign and_33 = ~(comp_feat_10_703) & ~(comp_feat_7_479) & ~(comp_feat_6_407) & ~(comp_feat_15_735) & comp_feat_8_527 & comp_feat_13_591;

assign or_3 = and_22 | and_23 | and_24 | and_25 | and_26 | and_27 | and_28 | and_29 | and_30 | and_31 | and_32 | and_33;

assign and_34 = comp_feat_10_703 & comp_feat_10_175 & ~(comp_feat_10_3) & ~(comp_feat_1_0) & comp_feat_8_511 & comp_feat_17_799;

assign and_35 = comp_feat_10_703 & comp_feat_10_175 & ~(comp_feat_10_3) & ~(comp_feat_1_0) & ~(comp_feat_8_511) & ~(comp_feat_12_535);

assign and_36 = comp_feat_10_703 & comp_feat_10_175 & comp_feat_10_3 & comp_feat_14_527 & ~(comp_feat_16_759);

assign and_37 = comp_feat_10_703 & comp_feat_10_175 & comp_feat_10_3 & comp_feat_14_527 & ~(comp_feat_12_535);

assign and_38 = comp_feat_10_703 & comp_feat_10_175 & ~(comp_feat_10_3) & comp_feat_1_0 & comp_feat_17_807;

assign and_39 = comp_feat_10_703 & ~(comp_feat_10_175) & comp_feat_9_519 & ~(comp_feat_7_471) & comp_feat_11_743 & ~(comp_feat_11_335);

assign and_40 = comp_feat_10_703 & ~(comp_feat_10_175) & ~(comp_feat_9_519) & ~(comp_feat_16_703) & ~(comp_feat_13_591) & ~(comp_feat_13_623);

assign and_41 = ~(comp_feat_10_703) & comp_feat_7_479 & comp_feat_9_511 & comp_feat_5_2 & comp_feat_17_783;

assign and_42 = ~(comp_feat_10_703) & comp_feat_7_479 & comp_feat_9_511 & comp_feat_5_2 & ~(comp_feat_11_687);

assign and_43 = ~(comp_feat_10_703) & comp_feat_7_479 & comp_feat_9_511 & ~(comp_feat_5_2) & ~(comp_feat_8_471);

assign and_44 = ~(comp_feat_10_703) & comp_feat_7_479 & ~(comp_feat_9_511) & comp_feat_6_359 & comp_feat_15_775;

assign and_45 = ~(comp_feat_10_703) & comp_feat_7_479 & ~(comp_feat_9_511) & comp_feat_6_359 & comp_feat_0_2;

assign and_46 = ~(comp_feat_10_703) & comp_feat_7_479 & ~(comp_feat_9_511) & ~(comp_feat_6_359) & ~(comp_feat_13_631);

assign and_47 = ~(comp_feat_10_703) & ~(comp_feat_7_479) & comp_feat_6_407 & comp_feat_6_383 & comp_feat_11_799;

assign and_48 = ~(comp_feat_10_703) & ~(comp_feat_7_479) & comp_feat_6_407 & comp_feat_6_383 & ~(comp_feat_13_615);

assign and_49 = ~(comp_feat_10_703) & ~(comp_feat_7_479) & comp_feat_6_407 & ~(comp_feat_6_383) & comp_feat_12_527 & ~(comp_feat_15_655);

assign and_50 = ~(comp_feat_10_703) & ~(comp_feat_7_479) & comp_feat_6_407 & ~(comp_feat_6_383) & ~(comp_feat_12_527) & ~(comp_feat_0_0);

assign and_51 = ~(comp_feat_10_703) & ~(comp_feat_7_479) & ~(comp_feat_6_407) & comp_feat_15_735 & comp_feat_8_535;

assign and_52 = ~(comp_feat_10_703) & ~(comp_feat_7_479) & ~(comp_feat_6_407) & ~(comp_feat_15_735) & comp_feat_8_527 & ~(comp_feat_13_591);

assign or_4 = and_34 | and_35 | and_36 | and_37 | and_38 | and_39 | and_40 | and_41 | and_42 | and_43 | and_44 | and_45 | and_46 | and_47 | and_48 | and_49 | and_50 | and_51 | and_52;

assign and_53 = ~(comp_feat_8_543) & ~(comp_feat_6_399) & ~(comp_feat_12_527) & comp_feat_11_815 & ~(comp_feat_14_543) & comp_feat_7_463;

assign and_54 = ~(comp_feat_8_543) & ~(comp_feat_6_399) & ~(comp_feat_12_527) & ~(comp_feat_11_815) & ~(comp_feat_17_799);

assign and_55 = ~(comp_feat_8_543) & ~(comp_feat_6_399) & ~(comp_feat_12_527) & ~(comp_feat_11_815) & ~(comp_feat_3_2);

assign and_56 = comp_feat_13_615 & ~(comp_feat_8_543) & comp_feat_6_399 & ~(comp_feat_7_471) & comp_feat_9_527 & comp_feat_9_511;

assign and_57 = comp_feat_8_543 & comp_feat_10_735 & ~(comp_feat_11_743) & comp_feat_12_463 & ~(comp_feat_2_2) & ~(comp_feat_10_591);

assign and_58 = ~(comp_feat_8_543) & ~(comp_feat_15_783) & comp_feat_6_399 & comp_feat_7_471 & comp_feat_10_711;

assign and_59 = ~(comp_feat_8_543) & comp_feat_6_399 & comp_feat_7_471 & comp_feat_10_711 & ~(comp_feat_7_471);

assign and_60 = ~(comp_feat_8_543) & ~(comp_feat_6_399) & comp_feat_12_527 & comp_feat_7_463 & comp_feat_13_607;

assign and_61 = ~(comp_feat_8_543) & ~(comp_feat_6_399) & comp_feat_12_527 & ~(comp_feat_7_463) & ~(comp_feat_14_575) & ~(comp_feat_12_415);

assign or_5 = and_53 | and_54 | and_55 | and_56 | and_57 | and_58 | and_59 | and_60 | and_61;

assign and_62 = ~(comp_feat_8_543) & ~(comp_feat_6_399) & ~(comp_feat_12_527) & comp_feat_11_815 & comp_feat_14_543 & ~(comp_feat_11_767);

assign and_63 = ~(comp_feat_8_543) & ~(comp_feat_6_399) & ~(comp_feat_12_527) & comp_feat_11_815 & ~(comp_feat_14_543) & ~(comp_feat_7_463);

assign and_64 = ~(comp_feat_8_543) & ~(comp_feat_6_399) & ~(comp_feat_12_527) & ~(comp_feat_11_815) & comp_feat_17_799 & comp_feat_3_2;

assign and_65 = comp_feat_3_0 & comp_feat_8_543 & ~(comp_feat_10_735) & ~(comp_feat_17_767) & comp_feat_13_639 & ~(comp_feat_11_687);

assign and_66 = ~(comp_feat_0_2) & comp_feat_8_543 & comp_feat_10_735 & comp_feat_11_743 & ~(comp_feat_14_527) & comp_feat_9_567;

assign and_67 = comp_feat_8_543 & comp_feat_10_735 & ~(comp_feat_11_743) & comp_feat_12_463 & comp_feat_2_2 & ~(comp_feat_5_1);

assign and_68 = comp_feat_8_543 & comp_feat_10_735 & ~(comp_feat_11_743) & ~(comp_feat_12_463) & comp_feat_14_519;

assign and_69 = ~(comp_feat_8_543) & comp_feat_6_399 & ~(comp_feat_7_471) & comp_feat_9_527 & ~(comp_feat_9_511) & comp_feat_12_519;

assign and_70 = ~(comp_feat_8_543) & comp_feat_6_399 & ~(comp_feat_7_471) & ~(comp_feat_9_527) & comp_feat_13_615 & ~(comp_feat_15_807);

assign and_71 = ~(comp_feat_8_543) & ~(comp_feat_6_399) & comp_feat_12_527 & comp_feat_7_463 & ~(comp_feat_13_607) & ~(comp_feat_14_535);

assign and_72 = ~(comp_feat_8_543) & ~(comp_feat_6_399) & comp_feat_12_527 & ~(comp_feat_7_463) & comp_feat_14_575;

assign or_6 = and_62 | and_63 | and_64 | and_65 | and_66 | and_67 | and_68 | and_69 | and_70 | and_71 | and_72;

assign and_73 = ~(comp_feat_8_543) & ~(comp_feat_6_399) & ~(comp_feat_12_527) & comp_feat_11_815 & comp_feat_14_543 & comp_feat_11_767;

assign and_74 = ~(comp_feat_3_2) & comp_feat_8_543 & ~(comp_feat_10_735) & ~(comp_feat_17_767) & ~(comp_feat_13_639) & comp_feat_13_639;

assign and_75 = ~(comp_feat_3_0) & comp_feat_8_543 & ~(comp_feat_10_735) & ~(comp_feat_17_767) & comp_feat_13_639 & ~(comp_feat_11_687);

assign and_76 = ~(comp_feat_3_0) & ~(comp_feat_8_543) & comp_feat_6_399 & comp_feat_7_471 & ~(comp_feat_10_711);

assign and_77 = comp_feat_5_2 & comp_feat_8_543 & ~(comp_feat_10_735) & comp_feat_17_767 & comp_feat_13_631 & ~(comp_feat_6_367);

assign and_78 = comp_feat_8_543 & comp_feat_10_735 & comp_feat_11_743 & comp_feat_14_527 & ~(comp_feat_8_503) & comp_feat_11_15;

assign and_79 = comp_feat_8_543 & comp_feat_10_735 & comp_feat_11_743 & ~(comp_feat_14_527) & ~(comp_feat_9_567) & ~(comp_feat_15_783);

assign and_80 = comp_feat_8_543 & ~(comp_feat_10_735) & ~(comp_feat_17_767) & comp_feat_13_639 & comp_feat_11_687 & comp_feat_12_559;

assign and_81 = ~(comp_feat_8_543) & comp_feat_6_399 & ~(comp_feat_7_471) & comp_feat_9_527 & ~(comp_feat_9_511) & ~(comp_feat_12_519);

assign and_82 = ~(comp_feat_8_543) & ~(comp_feat_6_399) & comp_feat_12_527 & comp_feat_7_463 & ~(comp_feat_13_607) & comp_feat_14_535;

assign or_7 = and_73 | and_74 | and_75 | and_76 | and_77 | and_78 | and_79 | and_80 | and_81 | and_82;

assign and_83 = comp_feat_3_0 & ~(comp_feat_8_543) & comp_feat_6_399 & comp_feat_7_471 & ~(comp_feat_10_711);

assign and_84 = ~(comp_feat_5_2) & comp_feat_8_543 & ~(comp_feat_10_735) & comp_feat_17_767 & comp_feat_13_631 & comp_feat_15_735;

assign and_85 = comp_feat_8_543 & comp_feat_10_735 & ~(comp_feat_11_743) & comp_feat_12_463 & comp_feat_2_2 & comp_feat_5_1;

assign and_86 = comp_feat_8_543 & comp_feat_10_735 & ~(comp_feat_11_743) & comp_feat_12_463 & ~(comp_feat_2_2) & comp_feat_10_591;

assign and_87 = comp_feat_8_543 & comp_feat_10_735 & ~(comp_feat_11_743) & ~(comp_feat_12_463) & ~(comp_feat_14_519);

assign and_88 = ~(comp_feat_8_543) & comp_feat_15_783 & comp_feat_6_399 & comp_feat_7_471 & comp_feat_10_711 & comp_feat_7_471;

assign and_89 = ~(comp_feat_8_543) & comp_feat_6_399 & ~(comp_feat_7_471) & ~(comp_feat_9_527) & comp_feat_13_615 & comp_feat_15_807;

assign or_8 = and_83 | and_84 | and_85 | and_86 | and_87 | and_88 | and_89;

assign and_90 = comp_feat_3_2 & comp_feat_8_543 & ~(comp_feat_10_735) & ~(comp_feat_17_767) & ~(comp_feat_13_639);

assign and_91 = comp_feat_5_2 & comp_feat_8_543 & ~(comp_feat_10_735) & comp_feat_17_767 & comp_feat_6_367;

assign and_92 = ~(comp_feat_5_2) & comp_feat_8_543 & ~(comp_feat_10_735) & comp_feat_17_767 & ~(comp_feat_15_735);

assign and_93 = comp_feat_0_2 & comp_feat_8_543 & comp_feat_10_735 & comp_feat_11_743 & ~(comp_feat_14_527) & comp_feat_9_567;

assign and_94 = ~(comp_feat_13_615) & ~(comp_feat_8_543) & comp_feat_6_399 & ~(comp_feat_7_471) & comp_feat_9_527 & comp_feat_9_511;

assign and_95 = comp_feat_8_543 & comp_feat_10_735 & comp_feat_11_743 & comp_feat_14_527 & comp_feat_8_503;

assign and_96 = comp_feat_8_543 & comp_feat_10_735 & comp_feat_11_743 & comp_feat_14_527 & ~(comp_feat_11_15);

assign and_97 = comp_feat_8_543 & comp_feat_10_735 & comp_feat_11_743 & ~(comp_feat_14_527) & ~(comp_feat_9_567) & comp_feat_15_783;

assign and_98 = comp_feat_8_543 & ~(comp_feat_10_735) & comp_feat_17_767 & ~(comp_feat_13_631);

assign and_99 = comp_feat_8_543 & ~(comp_feat_10_735) & ~(comp_feat_17_767) & comp_feat_13_639 & comp_feat_11_687 & ~(comp_feat_12_559);

assign and_100 = comp_feat_8_543 & ~(comp_feat_10_735) & ~(comp_feat_17_767) & ~(comp_feat_13_639) & ~(comp_feat_13_639);

assign and_101 = ~(comp_feat_8_543) & comp_feat_6_399 & ~(comp_feat_7_471) & ~(comp_feat_9_527) & ~(comp_feat_13_615);

assign and_102 = ~(comp_feat_8_543) & ~(comp_feat_6_399) & comp_feat_12_527 & ~(comp_feat_7_463) & ~(comp_feat_14_575) & comp_feat_12_415;

assign or_9 = and_90 | and_91 | and_92 | and_93 | and_94 | and_95 | and_96 | and_97 | and_98 | and_99 | and_100 | and_101 | and_102;

assign and_103 = comp_feat_8_543 & ~(comp_feat_2_2) & ~(comp_feat_11_655) & ~(comp_feat_11_687) & ~(comp_feat_15_847) & ~(comp_feat_11_799);

assign and_104 = ~(comp_feat_8_543) & comp_feat_9_527 & comp_feat_15_775 & ~(comp_feat_17_815) & ~(comp_feat_15_751) & comp_feat_15_767;

assign and_105 = ~(comp_feat_8_543) & comp_feat_9_527 & ~(comp_feat_15_775) & comp_feat_12_431 & comp_feat_2_1 & ~(comp_feat_8_575);

assign and_106 = ~(comp_feat_8_543) & comp_feat_6_399 & comp_feat_9_527 & ~(comp_feat_15_775) & ~(comp_feat_12_431) & comp_feat_13_615;

assign and_107 = ~(comp_feat_8_543) & comp_feat_12_527 & ~(comp_feat_9_527) & ~(comp_feat_11_807) & comp_feat_6_399 & ~(comp_feat_8_567);

assign and_108 = ~(comp_feat_8_543) & comp_feat_12_527 & ~(comp_feat_9_527) & ~(comp_feat_11_807) & ~(comp_feat_6_399) & ~(comp_feat_11_831);

assign and_109 = ~(comp_feat_8_543) & ~(comp_feat_12_527) & ~(comp_feat_9_527) & ~(comp_feat_11_807) & comp_feat_7_495 & ~(comp_feat_8_575);

assign and_110 = ~(comp_feat_11_815) & ~(comp_feat_8_543) & ~(comp_feat_12_527) & ~(comp_feat_9_527) & ~(comp_feat_11_807) & ~(comp_feat_7_495);

assign or_10 = and_103 | and_104 | and_105 | and_106 | and_107 | and_108 | and_109 | and_110;

assign and_111 = ~(comp_feat_3_2) & ~(comp_feat_17_799) & comp_feat_8_543 & comp_feat_11_655 & comp_feat_13_623 & ~(comp_feat_6_359);

assign and_112 = ~(comp_feat_3_2) & ~(comp_feat_17_799) & comp_feat_8_543 & comp_feat_11_655 & ~(comp_feat_13_623) & comp_feat_11_527;

assign and_113 = comp_feat_3_0 & comp_feat_13_631 & comp_feat_8_543 & ~(comp_feat_11_655) & ~(comp_feat_11_687) & comp_feat_15_847;

assign and_114 = ~(comp_feat_8_543) & comp_feat_9_527 & comp_feat_15_775 & comp_feat_17_815 & ~(comp_feat_10_711);

assign and_115 = ~(comp_feat_0_2) & ~(comp_feat_8_543) & comp_feat_9_527 & comp_feat_15_775 & ~(comp_feat_17_815) & comp_feat_15_751;

assign and_116 = ~(comp_feat_8_543) & comp_feat_9_527 & comp_feat_15_775 & ~(comp_feat_17_815) & ~(comp_feat_15_751) & ~(comp_feat_15_767);

assign and_117 = ~(comp_feat_8_543) & ~(comp_feat_6_399) & comp_feat_9_527 & ~(comp_feat_15_775) & ~(comp_feat_12_431) & comp_feat_13_615;

assign and_118 = ~(comp_feat_8_543) & comp_feat_13_615 & ~(comp_feat_9_527) & comp_feat_11_807 & comp_feat_6_391 & ~(comp_feat_9_535);

assign and_119 = ~(comp_feat_8_543) & ~(comp_feat_9_527) & comp_feat_11_807 & ~(comp_feat_6_391) & comp_feat_11_719 & ~(comp_feat_14_543);

assign and_120 = ~(comp_feat_8_543) & ~(comp_feat_9_527) & comp_feat_11_807 & ~(comp_feat_6_391) & ~(comp_feat_11_719) & ~(comp_feat_10_671);

assign and_121 = ~(comp_feat_8_543) & comp_feat_12_527 & ~(comp_feat_9_527) & ~(comp_feat_11_807) & ~(comp_feat_6_399) & comp_feat_11_831;

assign and_122 = comp_feat_11_815 & ~(comp_feat_8_543) & ~(comp_feat_12_527) & ~(comp_feat_9_527) & ~(comp_feat_11_807) & ~(comp_feat_7_495);

assign or_11 = and_111 | and_112 | and_113 | and_114 | and_115 | and_116 | and_117 | and_118 | and_119 | and_120 | and_121 | and_122;

assign and_123 = comp_feat_17_799 & comp_feat_8_543 & comp_feat_11_655 & comp_feat_13_623 & ~(comp_feat_8_503) & comp_feat_11_15;

assign and_124 = comp_feat_17_799 & comp_feat_8_543 & comp_feat_11_655 & ~(comp_feat_13_623) & ~(comp_feat_11_647) & comp_feat_13_623;

assign and_125 = comp_feat_13_631 & comp_feat_8_543 & ~(comp_feat_11_655) & comp_feat_11_687 & comp_feat_14_511 & comp_feat_4_0;

assign and_126 = comp_feat_13_631 & comp_feat_8_543 & ~(comp_feat_11_655) & comp_feat_11_687 & ~(comp_feat_14_511) & ~(comp_feat_17_767);

assign and_127 = ~(comp_feat_3_0) & comp_feat_13_631 & comp_feat_8_543 & ~(comp_feat_11_655) & ~(comp_feat_11_687) & comp_feat_15_847;

assign and_128 = ~(comp_feat_8_543) & ~(comp_feat_9_527) & comp_feat_11_807 & comp_feat_6_391 & comp_feat_9_535 & ~(comp_feat_7_471);

assign and_129 = ~(comp_feat_8_543) & ~(comp_feat_9_527) & comp_feat_11_807 & ~(comp_feat_6_391) & comp_feat_11_719 & comp_feat_14_543;

assign or_12 = and_123 | and_124 | and_125 | and_126 | and_127 | and_128 | and_129;

assign and_130 = comp_feat_17_799 & comp_feat_8_543 & comp_feat_11_655 & comp_feat_13_623 & comp_feat_8_503 & ~(comp_feat_14_527);

assign and_131 = comp_feat_3_2 & ~(comp_feat_17_799) & comp_feat_8_543 & comp_feat_5_1 & comp_feat_11_655 & comp_feat_13_623;

assign and_132 = ~(comp_feat_3_2) & ~(comp_feat_17_799) & comp_feat_8_543 & comp_feat_11_655 & comp_feat_13_623 & comp_feat_6_359;

assign and_133 = comp_feat_8_543 & comp_feat_2_2 & ~(comp_feat_11_655) & ~(comp_feat_11_687) & ~(comp_feat_15_847) & ~(comp_feat_11_767);

assign and_134 = ~(comp_feat_8_543) & comp_feat_9_527 & comp_feat_15_775 & comp_feat_17_815 & comp_feat_10_711;

assign and_135 = comp_feat_0_2 & ~(comp_feat_8_543) & comp_feat_9_527 & comp_feat_15_775 & ~(comp_feat_17_815) & comp_feat_15_751;

assign and_136 = ~(comp_feat_8_543) & comp_feat_9_527 & ~(comp_feat_15_775) & comp_feat_12_431 & comp_feat_2_1 & comp_feat_8_575;

assign and_137 = ~(comp_feat_8_543) & comp_feat_9_527 & ~(comp_feat_15_775) & ~(comp_feat_12_431) & ~(comp_feat_13_615) & comp_feat_7_479;

assign and_138 = ~(comp_feat_8_543) & ~(comp_feat_9_527) & comp_feat_11_807 & comp_feat_6_391 & comp_feat_9_535 & comp_feat_7_471;

assign and_139 = ~(comp_feat_8_543) & ~(comp_feat_9_527) & comp_feat_11_807 & ~(comp_feat_6_391) & ~(comp_feat_11_719) & comp_feat_10_671;

assign and_140 = ~(comp_feat_8_543) & comp_feat_12_527 & ~(comp_feat_9_527) & ~(comp_feat_11_807) & comp_feat_6_399 & comp_feat_8_567;

assign and_141 = ~(comp_feat_8_543) & ~(comp_feat_12_527) & ~(comp_feat_9_527) & ~(comp_feat_11_807) & comp_feat_7_495 & comp_feat_8_575;

assign or_13 = and_130 | and_131 | and_132 | and_133 | and_134 | and_135 | and_136 | and_137 | and_138 | and_139 | and_140 | and_141;

assign and_142 = comp_feat_17_799 & comp_feat_8_543 & comp_feat_11_655 & comp_feat_13_623 & comp_feat_8_503 & comp_feat_14_527;

assign and_143 = comp_feat_17_799 & comp_feat_8_543 & comp_feat_11_655 & comp_feat_13_623 & ~(comp_feat_8_503) & ~(comp_feat_11_15);

assign and_144 = comp_feat_17_799 & comp_feat_8_543 & comp_feat_11_655 & ~(comp_feat_13_623) & comp_feat_11_647;

assign and_145 = comp_feat_17_799 & comp_feat_8_543 & comp_feat_11_655 & ~(comp_feat_13_623) & ~(comp_feat_13_623);

assign and_146 = comp_feat_3_2 & ~(comp_feat_17_799) & comp_feat_8_543 & comp_feat_11_655 & ~(comp_feat_13_623);

assign and_147 = ~(comp_feat_3_2) & ~(comp_feat_17_799) & comp_feat_8_543 & comp_feat_11_655 & ~(comp_feat_13_623) & ~(comp_feat_11_527);

assign and_148 = comp_feat_3_2 & ~(comp_feat_17_799) & comp_feat_8_543 & ~(comp_feat_5_1) & comp_feat_11_655;

assign and_149 = comp_feat_8_543 & ~(comp_feat_11_655) & comp_feat_11_687 & comp_feat_14_511 & ~(comp_feat_4_0);

assign and_150 = comp_feat_8_543 & ~(comp_feat_11_655) & comp_feat_11_687 & ~(comp_feat_14_511) & comp_feat_17_767;

assign and_151 = ~(comp_feat_13_631) & comp_feat_8_543 & ~(comp_feat_11_655) & comp_feat_11_687;

assign and_152 = comp_feat_8_543 & comp_feat_2_2 & ~(comp_feat_11_655) & ~(comp_feat_11_687) & ~(comp_feat_15_847) & comp_feat_11_767;

assign and_153 = comp_feat_8_543 & ~(comp_feat_2_2) & ~(comp_feat_11_655) & ~(comp_feat_11_687) & ~(comp_feat_15_847) & comp_feat_11_799;

assign and_154 = ~(comp_feat_13_631) & comp_feat_8_543 & ~(comp_feat_11_655) & comp_feat_15_847;

assign and_155 = ~(comp_feat_8_543) & comp_feat_9_527 & ~(comp_feat_15_775) & comp_feat_12_431 & ~(comp_feat_2_1);

assign and_156 = ~(comp_feat_8_543) & comp_feat_9_527 & ~(comp_feat_15_775) & ~(comp_feat_12_431) & ~(comp_feat_13_615) & ~(comp_feat_7_479);

assign and_157 = ~(comp_feat_8_543) & ~(comp_feat_13_615) & ~(comp_feat_9_527) & comp_feat_11_807 & comp_feat_6_391 & ~(comp_feat_9_535);

assign or_14 = and_142 | and_143 | and_144 | and_145 | and_146 | and_147 | and_148 | and_149 | and_150 | and_151 | and_152 | and_153 | and_154 | and_155 | and_156 | and_157;

assign and_158 = ~(comp_feat_8_543) & ~(comp_feat_9_535) & ~(comp_feat_10_703) & ~(comp_feat_17_783) & ~(comp_feat_8_631);

assign and_159 = comp_feat_7_479 & comp_feat_8_543 & comp_feat_13_631 & comp_feat_14_503 & comp_feat_16_687 & ~(comp_feat_8_495);

assign and_160 = ~(comp_feat_8_543) & comp_feat_15_783 & comp_feat_10_703 & comp_feat_2_1 & comp_feat_7_439 & ~(comp_feat_12_551);

assign and_161 = ~(comp_feat_8_543) & ~(comp_feat_15_783) & comp_feat_10_703 & comp_feat_2_1 & comp_feat_7_439 & comp_feat_16_735;

assign and_162 = ~(comp_feat_8_543) & comp_feat_10_703 & comp_feat_2_1 & ~(comp_feat_7_439) & ~(comp_feat_6_383) & ~(comp_feat_15_759);

assign and_163 = ~(comp_feat_8_543) & comp_feat_14_519 & comp_feat_10_703 & ~(comp_feat_2_1) & comp_feat_6_391 & ~(comp_feat_16_719);

assign and_164 = ~(comp_feat_8_543) & ~(comp_feat_14_519) & comp_feat_10_703 & ~(comp_feat_2_1) & comp_feat_6_391 & comp_feat_16_727;

assign and_165 = comp_feat_16_703 & ~(comp_feat_8_543) & comp_feat_10_703 & ~(comp_feat_2_1) & ~(comp_feat_6_391) & ~(comp_feat_12_527);

assign and_166 = ~(comp_feat_16_703) & ~(comp_feat_8_543) & comp_feat_10_703 & ~(comp_feat_2_1) & ~(comp_feat_6_391) & ~(comp_feat_11_815);

assign or_15 = and_158 | and_159 | and_160 | and_161 | and_162 | and_163 | and_164 | and_165 | and_166;

assign and_167 = ~(comp_feat_7_479) & comp_feat_8_543 & comp_feat_2_2 & comp_feat_6_367 & comp_feat_6_367 & comp_feat_8_423;

assign and_168 = ~(comp_feat_7_479) & comp_feat_8_543 & comp_feat_2_2 & comp_feat_6_367 & ~(comp_feat_6_367) & ~(comp_feat_17_839);

assign and_169 = ~(comp_feat_7_479) & comp_feat_8_543 & ~(comp_feat_6_367) & ~(comp_feat_15_671) & ~(comp_feat_11_807) & ~(comp_feat_17_783);

assign and_170 = ~(comp_feat_8_543) & comp_feat_9_511 & comp_feat_9_535 & ~(comp_feat_10_703) & ~(comp_feat_17_783) & comp_feat_13_623;

assign and_171 = ~(comp_feat_8_543) & ~(comp_feat_9_511) & comp_feat_9_535 & ~(comp_feat_10_703) & ~(comp_feat_17_783) & ~(comp_feat_11_735);

assign and_172 = ~(comp_feat_8_543) & ~(comp_feat_9_535) & ~(comp_feat_10_703) & ~(comp_feat_17_783) & comp_feat_8_631 & ~(comp_feat_11_695);

assign and_173 = comp_feat_7_479 & comp_feat_8_543 & comp_feat_13_631 & comp_feat_14_503 & ~(comp_feat_16_687) & ~(comp_feat_17_799);

assign and_174 = comp_feat_7_479 & comp_feat_8_543 & ~(comp_feat_13_631) & comp_feat_10_759 & ~(comp_feat_4_2) & ~(comp_feat_15_783);

assign and_175 = ~(comp_feat_8_543) & comp_feat_10_703 & comp_feat_2_1 & ~(comp_feat_7_439) & ~(comp_feat_6_383) & comp_feat_15_759;

assign and_176 = comp_feat_16_703 & ~(comp_feat_8_543) & comp_feat_10_703 & ~(comp_feat_2_1) & ~(comp_feat_6_391) & comp_feat_12_527;

assign and_177 = ~(comp_feat_16_703) & ~(comp_feat_8_543) & comp_feat_10_703 & ~(comp_feat_2_1) & ~(comp_feat_6_391) & comp_feat_11_815;

assign and_178 = ~(comp_feat_8_543) & ~(comp_feat_10_703) & comp_feat_17_783 & comp_feat_10_767 & ~(comp_feat_11_695) & ~(comp_feat_6_383);

assign or_16 = and_167 | and_168 | and_169 | and_170 | and_171 | and_172 | and_173 | and_174 | and_175 | and_176 | and_177 | and_178;

assign and_179 = comp_feat_7_479 & comp_feat_8_543 & ~(comp_feat_10_735) & comp_feat_13_631 & ~(comp_feat_17_767) & ~(comp_feat_14_503);

assign and_180 = comp_feat_7_479 & comp_feat_8_543 & ~(comp_feat_13_631) & comp_feat_13_639 & ~(comp_feat_10_759) & ~(comp_feat_12_527);

assign and_181 = ~(comp_feat_8_543) & ~(comp_feat_9_511) & comp_feat_9_535 & ~(comp_feat_10_703) & ~(comp_feat_17_783) & comp_feat_11_735;

assign and_182 = ~(comp_feat_8_543) & ~(comp_feat_10_703) & comp_feat_17_783 & comp_feat_10_767 & comp_feat_11_695 & comp_feat_8_543;

assign and_183 = ~(comp_feat_8_543) & ~(comp_feat_10_703) & comp_feat_17_783 & comp_feat_10_767 & ~(comp_feat_11_695) & comp_feat_6_383;

assign or_17 = and_179 | and_180 | and_181 | and_182 | and_183;

assign and_184 = comp_feat_7_479 & comp_feat_8_543 & comp_feat_13_631 & comp_feat_17_767 & ~(comp_feat_14_503) & ~(comp_feat_15_799);

assign and_185 = comp_feat_7_479 & comp_feat_8_543 & comp_feat_10_735 & comp_feat_13_631 & ~(comp_feat_17_767) & ~(comp_feat_14_503);

assign and_186 = ~(comp_feat_7_479) & comp_feat_8_543 & ~(comp_feat_2_2) & comp_feat_6_367 & comp_feat_15_719 & comp_feat_16_719;

assign and_187 = ~(comp_feat_7_479) & comp_feat_8_543 & ~(comp_feat_6_367) & comp_feat_15_671;

assign and_188 = comp_feat_7_479 & comp_feat_8_543 & comp_feat_13_631 & comp_feat_14_503 & comp_feat_16_687 & comp_feat_8_495;

assign and_189 = comp_feat_7_479 & comp_feat_8_543 & ~(comp_feat_13_631) & comp_feat_10_759 & comp_feat_4_2 & comp_feat_15_687;

assign and_190 = ~(comp_feat_8_543) & comp_feat_15_783 & comp_feat_10_703 & comp_feat_2_1 & comp_feat_7_439 & comp_feat_12_551;

assign and_191 = ~(comp_feat_8_543) & ~(comp_feat_15_783) & comp_feat_10_703 & comp_feat_2_1 & comp_feat_7_439 & ~(comp_feat_16_735);

assign and_192 = ~(comp_feat_8_543) & comp_feat_10_703 & comp_feat_2_1 & ~(comp_feat_7_439) & comp_feat_6_383 & ~(comp_feat_9_7);

assign and_193 = ~(comp_feat_8_543) & comp_feat_14_519 & comp_feat_10_703 & ~(comp_feat_2_1) & comp_feat_6_391 & comp_feat_16_719;

assign and_194 = ~(comp_feat_8_543) & ~(comp_feat_14_519) & comp_feat_10_703 & ~(comp_feat_2_1) & comp_feat_6_391 & ~(comp_feat_16_727);

assign or_18 = and_184 | and_185 | and_186 | and_187 | and_188 | and_189 | and_190 | and_191 | and_192 | and_193 | and_194;

assign and_195 = comp_feat_7_479 & comp_feat_8_543 & comp_feat_13_631 & comp_feat_17_767 & ~(comp_feat_14_503) & comp_feat_15_799;

assign and_196 = ~(comp_feat_7_479) & comp_feat_8_543 & comp_feat_2_2 & comp_feat_6_367 & comp_feat_6_367 & ~(comp_feat_8_423);

assign and_197 = ~(comp_feat_7_479) & comp_feat_8_543 & comp_feat_2_2 & comp_feat_6_367 & ~(comp_feat_6_367) & comp_feat_17_839;

assign and_198 = ~(comp_feat_7_479) & comp_feat_8_543 & ~(comp_feat_2_2) & comp_feat_6_367 & ~(comp_feat_15_719);

assign and_199 = ~(comp_feat_7_479) & comp_feat_8_543 & ~(comp_feat_2_2) & comp_feat_6_367 & ~(comp_feat_16_719);

assign and_200 = ~(comp_feat_7_479) & comp_feat_8_543 & ~(comp_feat_6_367) & ~(comp_feat_15_671) & comp_feat_11_807;

assign and_201 = ~(comp_feat_7_479) & comp_feat_8_543 & ~(comp_feat_6_367) & ~(comp_feat_15_671) & comp_feat_17_783;

assign and_202 = comp_feat_7_479 & comp_feat_8_543 & ~(comp_feat_13_631) & ~(comp_feat_13_639) & ~(comp_feat_10_759);

assign and_203 = ~(comp_feat_8_543) & comp_feat_9_511 & comp_feat_9_535 & ~(comp_feat_10_703) & ~(comp_feat_17_783) & ~(comp_feat_13_623);

assign and_204 = ~(comp_feat_8_543) & ~(comp_feat_9_535) & ~(comp_feat_10_703) & ~(comp_feat_17_783) & comp_feat_8_631 & comp_feat_11_695;

assign and_205 = comp_feat_7_479 & comp_feat_8_543 & comp_feat_13_631 & comp_feat_14_503 & ~(comp_feat_16_687) & comp_feat_17_799;

assign and_206 = comp_feat_7_479 & comp_feat_8_543 & ~(comp_feat_13_631) & comp_feat_10_759 & comp_feat_4_2 & ~(comp_feat_15_687);

assign and_207 = comp_feat_7_479 & comp_feat_8_543 & ~(comp_feat_13_631) & comp_feat_10_759 & ~(comp_feat_4_2) & comp_feat_15_783;

assign and_208 = comp_feat_7_479 & comp_feat_8_543 & ~(comp_feat_13_631) & ~(comp_feat_10_759) & comp_feat_12_527;

assign and_209 = ~(comp_feat_8_543) & comp_feat_10_703 & comp_feat_2_1 & ~(comp_feat_7_439) & comp_feat_6_383 & comp_feat_9_7;

assign and_210 = ~(comp_feat_8_543) & ~(comp_feat_10_703) & comp_feat_17_783 & ~(comp_feat_10_767);

assign and_211 = ~(comp_feat_8_543) & ~(comp_feat_10_703) & comp_feat_17_783 & comp_feat_11_695 & ~(comp_feat_8_543);

assign or_19 = and_195 | and_196 | and_197 | and_198 | and_199 | and_200 | and_201 | and_202 | and_203 | and_204 | and_205 | and_206 | and_207 | and_208 | and_209 | and_210 | and_211;

assign and_212 = comp_feat_10_703 & comp_feat_13_631 & ~(comp_feat_9_511) & ~(comp_feat_7_455) & comp_feat_11_831 & ~(comp_feat_15_831);

assign and_213 = comp_feat_7_439 & comp_feat_6_399 & comp_feat_13_615 & comp_feat_9_511 & ~(comp_feat_15_791) & ~(comp_feat_9_215);

assign and_214 = comp_feat_7_439 & ~(comp_feat_6_399) & comp_feat_9_511 & ~(comp_feat_10_591) & ~(comp_feat_15_863);

assign and_215 = ~(comp_feat_7_439) & ~(comp_feat_2_2) & comp_feat_9_511 & ~(comp_feat_15_863) & comp_feat_8_535;

assign and_216 = ~(comp_feat_7_439) & comp_feat_9_511 & ~(comp_feat_8_535) & ~(comp_feat_10_607) & comp_feat_10_687;

assign and_217 = comp_feat_13_631 & ~(comp_feat_9_511) & comp_feat_3_1 & comp_feat_7_455 & comp_feat_10_687 & ~(comp_feat_15_799);

assign or_20 = and_212 | and_213 | and_214 | and_215 | and_216 | and_217;

assign and_218 = comp_feat_10_703 & comp_feat_13_631 & comp_feat_4_0 & ~(comp_feat_9_511) & ~(comp_feat_7_455) & ~(comp_feat_11_831);

assign and_219 = comp_feat_10_703 & comp_feat_13_631 & ~(comp_feat_9_511) & ~(comp_feat_7_455) & comp_feat_11_831 & comp_feat_15_831;

assign and_220 = ~(comp_feat_7_439) & comp_feat_2_2 & comp_feat_14_527 & comp_feat_9_511 & ~(comp_feat_15_863) & comp_feat_8_535;

assign and_221 = ~(comp_feat_13_631) & ~(comp_feat_7_471) & ~(comp_feat_9_511) & ~(comp_feat_8_399) & ~(comp_feat_15_639) & ~(comp_feat_17_847);

assign and_222 = ~(comp_feat_7_439) & ~(comp_feat_17_799) & comp_feat_2_1 & comp_feat_9_511 & comp_feat_15_863 & comp_feat_8_535;

assign and_223 = comp_feat_7_439 & comp_feat_6_399 & comp_feat_9_511 & ~(comp_feat_15_791) & comp_feat_9_215 & ~(comp_feat_3_1);

assign and_224 = ~(comp_feat_7_439) & comp_feat_9_511 & ~(comp_feat_8_535) & comp_feat_10_607 & ~(comp_feat_16_751) & ~(comp_feat_17_791);

assign and_225 = ~(comp_feat_7_439) & comp_feat_9_511 & ~(comp_feat_8_535) & ~(comp_feat_10_607) & ~(comp_feat_10_687) & comp_feat_7_495;

assign and_226 = comp_feat_13_631 & ~(comp_feat_9_511) & comp_feat_3_1 & comp_feat_7_455 & ~(comp_feat_10_687) & comp_feat_8_487;

assign or_21 = and_218 | and_219 | and_220 | and_221 | and_222 | and_223 | and_224 | and_225 | and_226;

assign and_227 = ~(comp_feat_10_703) & comp_feat_13_631 & ~(comp_feat_11_687) & ~(comp_feat_9_511) & ~(comp_feat_7_455);

assign and_228 = ~(comp_feat_10_703) & comp_feat_13_631 & ~(comp_feat_9_511) & ~(comp_feat_7_455) & comp_feat_7_487;

assign and_229 = ~(comp_feat_13_631) & comp_feat_7_471 & ~(comp_feat_9_511) & ~(comp_feat_16_775) & comp_feat_13_639 & ~(comp_feat_11_655);

assign and_230 = comp_feat_13_631 & ~(comp_feat_9_511) & ~(comp_feat_3_1) & comp_feat_7_455 & ~(comp_feat_11_703) & comp_feat_14_511;

assign or_22 = and_227 | and_228 | and_229 | and_230;

assign and_231 = comp_feat_10_703 & comp_feat_13_631 & ~(comp_feat_4_0) & ~(comp_feat_9_511) & ~(comp_feat_7_455) & ~(comp_feat_11_831);

assign and_232 = ~(comp_feat_7_439) & comp_feat_2_2 & ~(comp_feat_14_527) & comp_feat_9_511 & ~(comp_feat_15_863) & comp_feat_8_535;

assign and_233 = ~(comp_feat_13_631) & ~(comp_feat_7_471) & ~(comp_feat_9_511) & comp_feat_8_399;

assign and_234 = ~(comp_feat_13_631) & ~(comp_feat_7_471) & ~(comp_feat_9_511) & comp_feat_15_639;

assign and_235 = comp_feat_7_439 & comp_feat_6_399 & comp_feat_9_511 & comp_feat_15_791 & comp_feat_10_751 & comp_feat_12_511;

assign and_236 = comp_feat_7_439 & comp_feat_6_399 & comp_feat_9_511 & comp_feat_15_791 & ~(comp_feat_10_751) & comp_feat_17_719;

assign and_237 = comp_feat_7_439 & ~(comp_feat_6_399) & comp_feat_9_511 & comp_feat_10_591 & ~(comp_feat_10_223) & comp_feat_10_255;

assign and_238 = comp_feat_7_439 & ~(comp_feat_6_399) & comp_feat_9_511 & ~(comp_feat_10_591) & comp_feat_15_863 & comp_feat_12_383;

assign and_239 = ~(comp_feat_7_439) & comp_feat_9_511 & ~(comp_feat_8_535) & comp_feat_10_607 & comp_feat_16_751;

assign and_240 = comp_feat_13_631 & ~(comp_feat_9_511) & comp_feat_3_1 & comp_feat_7_455 & comp_feat_10_687 & comp_feat_15_799;

assign and_241 = comp_feat_13_631 & ~(comp_feat_9_511) & ~(comp_feat_3_1) & comp_feat_7_455 & ~(comp_feat_11_703) & ~(comp_feat_14_511);

assign or_23 = and_231 | and_232 | and_233 | and_234 | and_235 | and_236 | and_237 | and_238 | and_239 | and_240 | and_241;

assign and_242 = ~(comp_feat_10_703) & comp_feat_13_631 & comp_feat_11_687 & ~(comp_feat_9_511) & ~(comp_feat_7_455) & ~(comp_feat_7_487);

assign and_243 = comp_feat_7_439 & comp_feat_6_399 & ~(comp_feat_13_615) & comp_feat_9_511 & ~(comp_feat_15_791) & ~(comp_feat_9_215);

assign and_244 = ~(comp_feat_13_631) & comp_feat_7_471 & ~(comp_feat_9_511) & comp_feat_16_775;

assign and_245 = ~(comp_feat_13_631) & comp_feat_7_471 & ~(comp_feat_9_511) & ~(comp_feat_13_639);

assign and_246 = ~(comp_feat_13_631) & comp_feat_7_471 & ~(comp_feat_9_511) & comp_feat_11_655;

assign and_247 = ~(comp_feat_13_631) & ~(comp_feat_7_471) & ~(comp_feat_9_511) & ~(comp_feat_8_399) & ~(comp_feat_15_639) & comp_feat_17_847;

assign and_248 = ~(comp_feat_7_439) & comp_feat_17_799 & comp_feat_9_511 & comp_feat_15_863 & comp_feat_8_535;

assign and_249 = comp_feat_7_439 & comp_feat_6_399 & comp_feat_9_511 & comp_feat_15_791 & comp_feat_10_751 & ~(comp_feat_12_511);

assign and_250 = comp_feat_7_439 & comp_feat_6_399 & comp_feat_9_511 & comp_feat_15_791 & ~(comp_feat_10_751) & ~(comp_feat_17_719);

assign and_251 = comp_feat_7_439 & comp_feat_6_399 & comp_feat_9_511 & ~(comp_feat_15_791) & comp_feat_9_215 & comp_feat_3_1;

assign and_252 = comp_feat_7_439 & ~(comp_feat_6_399) & comp_feat_9_511 & comp_feat_10_591 & comp_feat_10_223;

assign and_253 = comp_feat_7_439 & ~(comp_feat_6_399) & comp_feat_9_511 & comp_feat_10_591 & ~(comp_feat_10_255);

assign and_254 = comp_feat_7_439 & ~(comp_feat_6_399) & comp_feat_9_511 & ~(comp_feat_10_591) & comp_feat_15_863 & ~(comp_feat_12_383);

assign and_255 = ~(comp_feat_7_439) & ~(comp_feat_2_1) & comp_feat_9_511 & comp_feat_15_863 & comp_feat_8_535;

assign and_256 = ~(comp_feat_7_439) & comp_feat_9_511 & ~(comp_feat_8_535) & comp_feat_10_607 & ~(comp_feat_16_751) & comp_feat_17_791;

assign and_257 = ~(comp_feat_7_439) & comp_feat_9_511 & ~(comp_feat_8_535) & ~(comp_feat_10_607) & ~(comp_feat_10_687) & ~(comp_feat_7_495);

assign and_258 = comp_feat_13_631 & ~(comp_feat_9_511) & comp_feat_3_1 & comp_feat_7_455 & ~(comp_feat_10_687) & ~(comp_feat_8_487);

assign and_259 = comp_feat_13_631 & ~(comp_feat_9_511) & ~(comp_feat_3_1) & comp_feat_7_455 & comp_feat_11_703;

assign or_24 = and_242 | and_243 | and_244 | and_245 | and_246 | and_247 | and_248 | and_249 | and_250 | and_251 | and_252 | and_253 | and_254 | and_255 | and_256 | and_257 | and_258 | and_259;


	assign comp_add_0_1 = (add_0 >= add_1);
	assign add_0_1 = comp_add_0_1 ? add_0 : add_1;
	assign comp_add_2_3 = (add_2 >= add_3);
	assign add_2_3 = comp_add_2_3 ? add_2 : add_3;
	assign comp_add_0_1_2_3 = (add_0_1 >= add_2_3);
	assign add_0_1_2_3 = comp_add_0_1_2_3 ? add_0_1 : add_2_3;
	assign comp_add_0_1_2_3_4 = (add_0_1_2_3 >= add_4);
	assign add_0_1_2_3_4 = comp_add_0_1_2_3_4 ? add_0_1_2_3 : add_4;
assign reg_decision[0] =  (sel_decision_0 == 3'b111) ? 1'b1 : 1'b0;

assign reg_decision[1] =  (sel_decision_1 == 3'b011) ? 1'b1 : 1'b0;

assign reg_decision[2] =  (sel_decision_2 == 3'b101) ? 1'b1 : 1'b0;

assign reg_decision[3] =  (sel_decision_3 == 3'b001) ? 1'b1 : 1'b0;

assign reg_decision[4] =  (sel_decision_4 == 1'b0) ? 1'b1 : 1'b0;




endmodule

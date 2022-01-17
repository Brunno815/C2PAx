`timescale 1ns / 1ps

module decision(
	feat_1,
	feat_2,
	feat_3,
	CLK,
	RST,
	decision
);


	input [9:0] feat_1;
	input [9:0] feat_2;
	input [9:0] feat_3;
	input wire CLK;
	input wire RST;
	output [2:0] decision;

	wire [9:0] reg_feat_1;
	wire [9:0] reg_feat_2;
	wire [9:0] reg_feat_3;
	wire [2:0] reg_decision;

wire [0:0] comp_feat_1_367;
wire [0:0] comp_feat_1_287;
wire [0:0] comp_feat_2_655;
wire [0:0] comp_feat_3_639;
COMPS INST_COMP(
reg_feat_1, reg_feat_2, reg_feat_3, comp_feat_1_367, comp_feat_1_287, comp_feat_2_655, comp_feat_3_639
);

ANDS INST_ANDS(
comp_feat_1_367, comp_feat_1_287, comp_feat_2_655, comp_feat_3_639, reg_decision
);


	assign reg_feat_1 = feat_1;

	assign reg_feat_2 = feat_2;

	assign reg_feat_3 = feat_3;

	assign decision = reg_decision;

endmodule


module COMPS(
reg_feat_1, reg_feat_2, reg_feat_3, comp_feat_1_367, comp_feat_1_287, comp_feat_2_655, comp_feat_3_639
);

input [9:0] reg_feat_1;
input [9:0] reg_feat_2;
input [9:0] reg_feat_3;
output [0:0] comp_feat_1_367;
output [0:0] comp_feat_1_287;
output [0:0] comp_feat_2_655;
output [0:0] comp_feat_3_639;

wire [9:0] const_367_10;
assign const_367_10 = 10'b0101101111;
wire [9:0] const_287_10;
assign const_287_10 = 10'b0100011111;
wire [9:0] const_655_10;
assign const_655_10 = 10'b1010001111;
wire [9:0] const_639_10;
assign const_639_10 = 10'b1001111111;

	assign comp_feat_1_367 = (reg_feat_1 <= const_367_10);
	assign comp_feat_1_287 = (reg_feat_1 <= const_287_10);
	assign comp_feat_2_655 = (reg_feat_2 <= const_655_10);
	assign comp_feat_3_639 = (reg_feat_3 <= const_639_10);
endmodule


module ANDS(
comp_feat_1_367, comp_feat_1_287, comp_feat_2_655, comp_feat_3_639, reg_decision
);

input [0:0] comp_feat_1_367;
input [0:0] comp_feat_1_287;
input [0:0] comp_feat_2_655;
input [0:0] comp_feat_3_639;
output [2:0] reg_decision;

wire [0:0] and_0;
wire [0:0] or_0;
wire [0:0] and_1;
wire [0:0] and_2;
wire [0:0] or_1;
wire [0:0] and_3;
wire [0:0] and_4;
wire [0:0] or_2;

assign and_0 = comp_feat_1_367 & comp_feat_1_287 & comp_feat_2_655;

assign or_0 = and_0;

assign and_1 = ~(comp_feat_1_367);

assign and_2 = ~(comp_feat_1_287) & ~(comp_feat_3_639);

assign or_1 = and_1 | and_2;

assign and_3 = comp_feat_1_367 & comp_feat_1_287 & ~(comp_feat_2_655);

assign and_4 = comp_feat_1_367 & ~(comp_feat_1_287) & comp_feat_3_639;

assign or_2 = and_3 | and_4;



assign reg_decision[0] = or_0;
assign reg_decision[1] = or_1;
assign reg_decision[2] = or_2;


endmodule


module mips_pipeline(
	input clk, reset,
	output [31:0] pcF,
	input [31:0] instrF,
	output memwriteM,
	output [31:0] aluoutM, writedataM,
	input [31:0] readdataM);
	logic [5:0] opD, functD;
	logic regdstE, alusrcE,pcsrcD,memtoregE, memtoregM, 
			memtoregW, regwriteE, regwriteM, regwriteW;
	logic [5:0] alucontrolE;
	logic flushE, equalD, branchD, jumpD, zeroextendD;
	controller c(clk, reset, opD, functD, flushE, equalD,
				memtoregE, memtoregM, memtoregW, memwriteM, 
				pcsrcD, branchD,alusrcE, regdstE, regwriteE, 
				regwriteM, regwriteW, jumpD,zeroextendD, alucontrolE);
	datapath dp(clk, reset, memtoregE, memtoregM, memtoregW, pcsrcD, branchD,
				alusrcE, regdstE, regwriteE, regwriteM, regwriteW, jumpD,
				zeroextendD, alucontrolE,equalD, pcF, instrF,aluoutM, writedataM, 
				readdataM,opD, functD, flushE);
endmodule
//module for the control unit of the pipeline processor
module controller(
	input clk, reset,
	input [5:0] opD, functD,
	input flushE, equalD,
	output memtoregE, memtoregM, memtoregW, memwriteM,
	output pcsrcD, branchD, alusrcE,
	output regdstE, regwriteE, regwriteM, regwriteW,
	output jumpD,
	output zeroextendD,
	output [5:0] alucontrolE);
	logic [3:0] aluopD;
	logic memtoregD, memwriteD, alusrcD,
	regdstD, regwriteD;
	logic [5:0] alucontrolD;
	logic memwriteE;
	// main decoder
	maindec md(opD, memtoregD, memwriteD, branchD,
	alusrcD, regdstD, regwriteD, jumpD,
	zeroextendD, aluopD);
	// alu decoder
	aludec ad(functD, aluopD, alucontrolD);
	// check for branch
	assign pcsrcD = branchD & equalD;
	// register between Decode and Execute stages
	floprc #(11) regE(clk, reset, flushE,
	{memtoregD, memwriteD, alusrcD, regdstD, regwriteD, alucontrolD},
	{memtoregE, memwriteE, alusrcE, regdstE, regwriteE, alucontrolE});
	// register between Execute and Memory stages
	flopr #(3) regM(clk, reset,
	{memtoregE, memwriteE, regwriteE},
	{memtoregM, memwriteM, regwriteM});
	// register between Memory and Writeback stages
	flopr #(2) regW(clk, reset,{memtoregM, regwriteM},{memtoregW, regwriteW});
endmodule
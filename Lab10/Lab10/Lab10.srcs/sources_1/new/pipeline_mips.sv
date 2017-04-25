`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Lafayette College
// Engineer: Zainab Hussein
// 
// Create Date: 04/25/2017 01:44:06 PM
// Design Name: Controller of pipeline
// Module Name: pipeline_mips
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//////////////////////////////////////////////////////////////////////////////////
module pipeline_mips(
    input logic         clk, reset,
    output logic [31:0] pcF,
    input logic [31:0]  instrF,
    output logic        memwriteM,
    output logic [31:0] aluoutM, writedataM,
    input logic [31:0]  readdataM);
    
    logic [5:0] opD, functD;
    logic       regdstE, alusrcE,pcsrcD,memtoregE, memtoregM, 
                memtoregW, regwriteE, regwriteM, regwriteW;
    logic [5:0] alucontrolE;
    logic       flushE, equalD, branchD, jumpD, zeroextendD;
    
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
module controller(  input logic clk, reset,
                    input logic [5:0] opD, functD,
                    input logic flushE, equalD,
                    output logic memtoregE, memtoregM, memtoregW, memwriteM,
                    output logic pcsrcD, branchD, alusrcE,
                    output logic regdstE, regwriteE, regwriteM, regwriteW,
                    output logic jumpD,
                    output logic zeroextendD,
                    output logic [5:0] alucontrolE);
    
    logic [3:0] aluopD;
    logic       memToRegM, memwriteD, alusrcD,regdstD, regwriteD;
    logic [5:0] alucontrolD;
    logic       memwriteE;
    
    // main decoder
    maindec md(opD, memtoregD, memwriteD, branchD,alusrcD, regdstD, 
    regwriteD, jumpD,zeroextendD, aluopD);
    
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

//module for the DataPath of the processor
module datapath(input logic clk, reset,
                input logic memtoregE, memtoregM, memtoregW,
                input logic pcsrcD, branchD,
                input logic alusrcE, regdstE,
                input logic regwriteE, regwriteM, regwriteW,
                input logic jumpD,
                input logic zeroextendD,
                input logic [5:0] alucontrolE,
                output logic equalD,
                output logic [31:0] pcF,
                input logic [31:0] instrF,
                output logic [31:0] aluoutM, writedataM,
                input logic [31:0] readdataM,
                output logic [5:0] opD, functD,
                output logic flushE);
	
	logic forwardaD, forwardbD;
	logic [1:0] forwardaE, forwardbE;
	logic stallF,stallD;
	logic [4:0] rsD, rtD, rdD, rsE, rtE, rdE;
	logic [4:0] writeregE, writeregM, writeregW;
	logic brjflush;
	logic [31:0] pcnextFD, pcnextbrFD, pcplus4F, pcbranchD;
	logic [31:0] signimmD, signimmE, signimmshD;
	logic [31:0] srcaD, srca2D, srcaE, srca2E;
	logic [31:0] srcbD, srcb2D, srcbE, srcb2E, srcb3E;
	logic [31:0] pcplus4D, instrD;
	logic [31:0] aluoutE, aluoutW;
	logic aluoverflowE;
	logic [31:0] readdataW, resultW;
	
	// Hazard Unit
	hazard h(rsD, rtD, rsE, rtE, writeregE, writeregM, writeregW,
	regwriteE, regwriteM, regwriteW,
	memtoregE, memtoregM, branchD,
	forwardaD, forwardbD, forwardaE, forwardbE,
	stallF, stallD, flushE);
	
	// next PC logic
	mux2 #(32) pcbrmux(pcplus4F, pcbranchD, pcsrcD, pcnextbrFD);
	mux2 #(32) pcmux(pcnextbrFD,{pcplus4D[31:28], instrD[25:0], 2'b00},
	jumpD, pcnextFD);
	
	// register file -used in decode and writeback
	regfile rf(clk, regwriteW, rsD, rtD, writeregW,
	resultW, srcaD, srcbD);
	
	//Fetch stage logic
	flopenr #(32) pcreg(clk, reset, ~stallF, pcnextFD, pcF);
	
	// add 4 to PC
	adder pcadd1(pcF, 32'b100, pcplus4F);
	
	// Decode stage
	// Decode stage register (upper part)
	flopenrc #(32) r2D(clk, reset, ~stallD, brjflush, instrF, instrD);
	
	// Decode stage register (lower part)
	flopenr #(32) r1D(clk, reset, ~stallD, pcplus4F, pcplus4D);
	
	// sign extend immediate value
	signext se(instrD[15:0], zeroextendD, signimmD);
	
	// shift left immediate value by 2
	sl2 immsh(signimmD, signimmshD);
	
	// add 2 to PC sign extended and shifted immediate value -branch
	adder pcadd2(pcplus4D, signimmshD, pcbranchD);
	
	// forwarding mux's
	mux2 #(32) forwardadmux(srcaD, aluoutM, forwardaD, srca2D);
	mux2 #(32) forwardbdmux(srcbD, aluoutM, forwardbD, srcb2D);
	
	// branch prediction
	eqcmp comp(srca2D, srcb2D, equalD);
	
	// get op code (6 bit)
	assign opD = instrD[31:26];
	
	// get function code (6 bit)
	assign functD = instrD[5:0];
	
	// get source register (5 bit)
	assign rsD = instrD[25:21];
	
	// get target register (5 bit)
	assign rtD = instrD[20:16];
	
	// get destination register (5 bit)
	assign rdD = instrD[15:11];
	
	// flush D latch if branch or jump
	assign brjflush = pcsrcD | jumpD;
	
	//-- Execute stage ---
	// latch E
	floprc #(32) r1E(clk, reset, flushE, srcaD, srcaE);
	floprc #(32) r2E(clk, reset, flushE, srcbD, srcbE);
	floprc #(32) r3E(clk, reset, flushE, signimmD, signimmE);
	floprc #(5) r4E(clk, reset, flushE, rsD, rsE);
	floprc #(5) r5E(clk, reset, flushE, rtD, rtE);
	floprc #(5) r6E(clk, reset, flushE, rdD, rdE);
	
	// forwarding mux's
	mux3 #(32) forwardaemux(srcaE, resultW, aluoutM, forwardaE, srca2E);
	mux3 #(32) forwardbemux(srcbE, resultW, aluoutM, forwardbE, srcb2E);
	
	// ALU B source selector
	mux2 #(32) srcbmux(srcb2E, signimmE, alusrcE, srcb3E);
	
	// ALU
	alu alu(srca2E, srcb3E, alucontrolE, aluoutE, aluoverflowE);
	
	// Write register (rt or td)
	mux2 #(5) wrmux(rtE, rdE, regdstE, writeregE);
	
	//-- Memory stage ---
	// latch M
	flopr #(32) r1M(clk, reset, srcb2E, writedataM);
	flopr #(32) r2M(clk, reset, aluoutE, aluoutM);
	flopr #(5) r3M(clk, reset, writeregE, writeregM);
	
	//-- Writeback stage ---
	// latch W
	flopr #(32) r1W(clk, reset, aluoutM, aluoutW);
	flopr #(32) r2W(clk, reset, readdataM, readdataW);
	flopr #(5) r3W(clk, reset, writeregM, writeregW);
	
	// result selector (from ALU or Memory)
	mux2 #(32) resmux(aluoutW, readdataW, memtoregW, resultW);
endmodule
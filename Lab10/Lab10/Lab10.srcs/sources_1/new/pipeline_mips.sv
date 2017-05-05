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
    input clk, reset,
    output memwriteM,
    output [31:0] aluoutM, writedataM,
    input [31:0] readdataM);
    
    logic [31:0] pcF;
    logic [31:0] instrF;
    logic [5:0] opD, functD;
    logic regdstE, alusrcE,pcsrcD,
          memtoregE, memtoregM, memtoregW, regwriteE, regwriteM, regwriteW;
    logic [5:0] alucontrolE;
    logic flushE, equalD, branchD, jumpD, zeroextendD;
    controller c(clk, reset, opD, functD, flushE, equalD,
                memtoregE, memtoregM, memtoregW, memwriteM, pcsrcD, branchD,
                alusrcE, regdstE, regwriteE, regwriteM, regwriteW, jumpD,
                zeroextendD, alucontrolE);
    datapath dp(clk, reset, memtoregE, memtoregM, memtoregW, pcsrcD, branchD,
                alusrcE, regdstE, regwriteE, regwriteM, regwriteW, jumpD,
                zeroextendD, alucontrolE,
                equalD, pcF, instrF,
                aluoutM, writedataM, readdataM,
                opD, functD, flushE);
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
    logic       memToRegM, memwriteD, alusrcD,regdstD, regwriteD, memwriteE;
    logic [5:0] alucontrolD;
    
    // main decoder
    maindec md( opD, memtoregD, memwriteD, branchD,alusrcD, regdstD, 
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
    flopr #(2) regW(clk, reset,
    {memtoregM, regwriteM},{memtoregW, regwriteW});
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
                input logic [31:0] readdataM,
                input logic [31:0] instrF,
                output logic equalD,
                output logic [31:0] pcF,
                output logic [31:0] aluoutM, writedataM,
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
	hazard haz(  rsD, rtD, rsE, rtE, writeregE, writeregM, writeregW,
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
	Alu alu(srca2E, srcb3E, alucontrolE, aluoutE, aluoverflowE);
	
	// Write register (rt or rd)
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

// adder
module adder(  input logic [31:0] a, b,
	           output logic [31:0] y);
	assign #1 y = a + b;
endmodule

// branch prediction comparator
module eqcmp(  input logic [31:0] a, b,
	           output logic eq);
	assign #1 eq = (a == b);
endmodule

// shift left 2 bits
module sl2(input logic [31:0] a,
	       output logic [31:0] y);
	// shift left 2 bits
	assign #1 y = {a[29:0], 2'b00};
endmodule

// extend sign of immediate value to 32 bits
module signext(input logic [15:0] a,
	           input logic zero,
	           output logic [31:0] y);
	assign #1 y = zero ? {16'b0, a} : {{16{a[15]}}, a};
endmodule

//latch
module flopr #(parameter WIDTH = 8)(
	input logic clk, reset,
	input logic [WIDTH-1:0] d,
	output logic [WIDTH-1:0] q);
	always @(posedge clk, posedge reset)
		if (reset) q <= #1 0;
		else       q <= #1 d;
endmodule

// latch with clear
module floprc #(parameter WIDTH = 8)(
	input logic clk, reset, clear,
	input logic [WIDTH-1:0] d,
	output logic [WIDTH-1:0] q);
	always @(posedge clk, posedge reset)
		if (reset) q <= #1 0;
		else if (clear) q <= #1 0;
		else q <= #1 d;
endmodule

// latch with enable
module flopenr #(parameter WIDTH = 8)(
	input logic clk, reset,
	input logic en,
	input logic [WIDTH-1:0] d,
	output logic [WIDTH-1:0] q);
	always @(posedge clk, posedge reset)
		if (reset) q <= #1 0;
		else if (en) q <= #1 d;
endmodule

// latch with enable and clear
module flopenrc #(parameter WIDTH = 8)(
	input logic clk, reset,
	input logic en, clear,
	input logic [WIDTH-1:0] d,
	output logic [WIDTH-1:0] q);
	always @(posedge clk, posedge reset)
	if (reset) q <= #1 0;
	else if (clear) q <= #1 0;
	else if (en) q <= #1 d;
endmodule

// 2 input multiplexer
module mux2 #(parameter WIDTH = 8)(
	input logic [WIDTH-1:0] d0, d1,
	input logic s,
	output logic [WIDTH-1:0] y);
	assign #1 y = s ? d1 : d0;
endmodule

// 3 input multiplexer
module mux3 #(parameter WIDTH = 8)(	
	input logic [WIDTH-1:0] d0, d1, d2,
	input logic [1:0] s,
	output logic [WIDTH-1:0] y);
	assign #1 y = s[1] ? d2 : (s[0] ? d1 : d0);
endmodule

// 4 input multiplexer
module mux4 #(parameter WIDTH = 8)(
	input logic [WIDTH-1:0] d0, d1, d2, d3,
	input logic [1:0] s,
	output logic [WIDTH-1:0] y);
	assign #1 y = s[2] ? d3 : (s[1] ? d2 : (s[0] ? d1 : d0));
endmodule

//main decoder
module maindec(input logic [5:0] op,
	           output logic memtoreg, memwrite,
               output logic branch, alusrc,
               output logic regdst, regwrite,
               output logic jump,
               output logic zeroextend,
               output logic [3:0] aluop);
	logic [11:0] controls;
	assign {regwrite, regdst, alusrc, branch, memwrite, memtoreg, 
			jump, zeroextend,aluop} = controls;
	always @(*)
		case(op)
		6'b000000: controls = 12'b11000000_1111; //Rtype
		6'b000010: controls = 12'b00000010_0000; //J
		6'b000100: controls = 12'b00010000_0001; //BEQ
		6'b001000: controls = 12'b10100000_0000; // ADDI
		6'b001001: controls = 12'b10100000_0000; // ADDIU
		6'b001010: controls = 12'b10100000_0010; // SLTI
		6'b001100: controls = 12'b10100001_0100; // ANDI
		6'b001101: controls = 12'b10100001_0101; // ORI
		6'b001110: controls = 12'b10100001_0110; // XORI
		6'b001111: controls = 12'b10100001_0111; // LUI
		6'b100011: controls = 12'b10100100_0000; //LW
		6'b101011: controls = 12'b00101000_0000; //SW
		default: begin
            $display("Error-MainDec", op);
            controls = 12'bxxxxxxxxxxxx; // unknown instruction
		end
		endcase
endmodule

module aludec(input logic [5:0] funct,
	          input logic [3:0] aluop,
	          output reg [5:0] alucontrol);
	always @(*)
		case(aluop)
		4'b0000: alucontrol = 6'b0_00010; // ADDI
		4'b0001: alucontrol = 6'b1_00010; // SUBI
		4'b0010: alucontrol = 6'b1_00011; // SLTI
		4'b0100: alucontrol = 6'b0_00000; // ANDI
		4'b0101: alucontrol = 6'b0_00001; // ORI
		4'b0110: alucontrol = 6'b0_00100; // XORI
		4'b0111: alucontrol = 6'b0_00110; // LUI
        4'b1111: case(funct) // RTYPE
            6'b100000: alucontrol = 6'b0_00010; // ADD
            6'b100001: alucontrol = 6'b0_00010; // ADDU
            6'b100010: alucontrol = 6'b1_00010; // SUB
            6'b100011: alucontrol = 6'b1_00010; // SUBU
            6'b100100: alucontrol = 6'b0_00000; // AND
            6'b100101: alucontrol = 6'b0_00001; // OR
            6'b100110: alucontrol = 6'b0_00100; // XOR
            6'b100111: alucontrol = 6'b0_00101; // NOR
            6'b101010: alucontrol = 6'b1_00011; // SLT
            default: begin
              $display("Error- Funct", funct);
              alucontrol = 6'bxxxxxx; // ??? unknown function
            end
            endcase
		default: begin
		  $display("Error -ALU", aluop);
		end
		endcase
endmodule

// Register file:
// three ported register file
// read two ports combinationally
// write third port on falling edge of clock
// register 0 hardwired to 0
module regfile (clk, w_enable, r_addr1, r_addr2, w_addr1, w_data1, r_data1, r_data2);
	input clk; // clock
	input w_enable; // write enable
	input [4:0] r_addr1,r_addr2,w_addr1; // address lines
	input [31:0] w_data1; // data input
	output [31:0] r_data1,r_data2; // data outputs
	logic [31:0] rfile[31:0]; // register file
	// write on neg clock edge
	always @(negedge clk)
		if(w_enable) rfile[w_addr1] <= w_data1;
	assign r_data1 = (r_addr1 != 0) ? rfile[r_addr1] : 0;
	assign r_data2 = (r_addr2 != 0) ? rfile[r_addr2] : 0;
endmodule


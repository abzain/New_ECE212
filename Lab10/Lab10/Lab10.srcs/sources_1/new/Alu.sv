`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Lafayette College
// Engineer: Zainab Hussein
// 
// Create Date: 04/12/2017 12:33:33 AM
// Design Name: 
// Module Name: Alu
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
// 
//////////////////////////////////////////////////////////////////////////////////

module Alu(
    input logic [31:0] a,
    input logic [31:0] b,
    input logic [5:0] alucont,
    output logic [31:0] result,
    output logic overflow
    );

	logic [31:0] b2, sum, slt;
	// invert sign if substraction
	assign #1 b2 = alucont[5] ? ~b : b;
	// sum operands
	assign #1 {overflow, sum} = a + b2 + alucont[5];
	// check sign bit (32th)
	assign #1 slt = sum[31];
	// if any input changes
	always @(*) begin
		case(alucont[4:0])
		5'b00000: result = a & b; // AND, ANDI
		5'b00001: result = a | b; // OR, ORI
		5'b00010: result = sum; // sum: ADD, ADDI, ADDU, ADDUI, SUB, SUBI, SUBU, SUBUI
		5'b00011: result = slt; // set if less than: SLT, SLTI
		5'b00100: result = a ^ b; // XOR, XORI
		5'b00101: result = ~(a | b); // NOR, NORI
		5'b00110: result = {b, 16'b0}; // LUI
		default: begin
			$display("...Error: Unkown Funct", alucont);
		end
		endcase
	end
endmodule
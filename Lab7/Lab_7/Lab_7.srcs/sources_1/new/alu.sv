`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Lafayette College
// Engineer: Zainab Hussein
// 
// Create Date: 04/04/2017 09:19:40 AM
// Design Name: Arithmetic Logic Unit
// Module Name: alu
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


module alu(
    input logic [31:0] a,
    input logic [31:0] b,
    input logic [2:0] f,
    output logic [31:0] y,
    output logic zero
    );
    
    logic [31:0] A_nd, O_r, Add, Aand, Aor, Sub, Slt;
    
    assign A_nd = a & b;
    assign O_r = a|b;
    assign Add = a + b;
    assign Aand = a & ~b;
    assign Aor = a|~b;
    assign Sub = a - b;
    assign Slt = (a < b ) ? 1 : 0;  //if(a<b) y=1; else y=0;
    assign zero = 1'b0;
      
    always_comb
        case( f )
            3'b000: y <= A_nd;
            3'b001: y <= O_r;
            3'b010: y <= Add;
            //2'b011: y <= 32'dx;
            3'b100: y <= Aand;
            3'b101: y <= Aor;
            3'b110: y <= Sub;
            3'b111: y <= Slt;
            default: y <= 32'dx;
        endcase
    
endmodule

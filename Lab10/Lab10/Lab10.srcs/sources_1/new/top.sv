`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/25/2017 08:59:39 PM
// Design Name: 
// Module Name: top
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
module top(input  logic        clk, reset, 
           output logic [31:0] writedataM, adr, 
           output logic        memwriteM);

  logic [31:0] readdataM, pcF, instrF, aluoutM;
  
  // microprocessor (control & datapath)
  //mips mips(clk, reset, adr, writedata, memwrite, readdata);
  pipeline_mips mips( clk, reset, pcF, instrF, memwriteM, aluoutM, writedataM, readdataM );

  // memory 
  mem mem(clk, memwriteM, adr, writedataM, readdataM);

endmodule

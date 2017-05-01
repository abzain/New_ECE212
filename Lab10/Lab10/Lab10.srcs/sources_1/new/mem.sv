`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/25/2017 09:10:07 PM
// Design Name: 
// Module Name: mem
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


module mem( input logic clk,
            input logic we,
            input logic [31:0] a,
            input logic [31:0] wd,
            output logic [31:0] rd );
     logic  [31:0] RAM[63:0];
           
     // initialize memory with instructions
     initial
       begin
         $readmemh("memfile.dat",RAM);  // "memfile.dat" contains your instructions in hex
                                        // you must create this file
       end
   
     assign rd = RAM[a[31:2]]; // word aligned
   
     always_ff @(posedge clk)
       if (we)
         RAM[a[31:2]] <= wd;
endmodule

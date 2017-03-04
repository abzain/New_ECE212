`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/13/2017 09:31:28 PM
// Design Name: 
// Module Name: row_counter
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

//this module countes up the number of rows 
module row_counter(
    input logic clk, 
    input logic reset, 
    input logic enb, 
    output logic [2:0] q);
               
    always_ff @(posedge clk)
        if ( reset ) q <= 3'd0;
        else if ( enb ) q <= q + 1;
        
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/13/2017 09:31:28 PM
// Design Name: 
// Module Name: col_counter
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

//this module counts up the number of colums 
module col_counter(
    input logic clk, 
    input logic reset,  
    input logic enb, 
    output logic [4:0] q);
               
    always_ff @(posedge clk)
        if ( reset ) q <= 5'd0;
        else if (enb) q <= q + 1;
        
endmodule
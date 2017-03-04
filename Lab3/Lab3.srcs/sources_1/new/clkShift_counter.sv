`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/13/2017 09:36:34 PM
// Design Name: 
// Module Name: clkShift_counter
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

//this module determines the amount to shift through the leds displayed at any given time 
module clkShift_counter(
    input logic clk, 
    input logic reset, 
    input logic enb, 
    output logic [4:0] q);
               
    always_ff @(posedge clk)
        if (reset) q <= 5'd0;
        else if (enb) q <= q + 1;
        
endmodule

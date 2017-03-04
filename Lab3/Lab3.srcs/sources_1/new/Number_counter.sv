`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Lafayette College
// Engineer: Zainab Hussein
// 
// Create Date: 02/22/2017 07:42:27 PM
// Design Name: Lab 3
// Module Name: Number_counter
// Project Name: LED Scroll matrix
// Target Devices: Nexys4
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

module Number_counter(
    input logic clk, reset, enb,
    output logic [3:0] q
    );
    
    always_ff@( posedge clk )
        begin
            if( reset ) 
                q <= 4'd0;
            else if( enb && q < 9 )
                q <= q + 1;
            else
                q <= q;
        end

endmodule
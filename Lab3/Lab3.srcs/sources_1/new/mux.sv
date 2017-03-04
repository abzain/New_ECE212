`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/13/2017 10:42:00 PM
// Design Name: Zainab Husssein
// Module Name: mux
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// color select mux that specifies what combination of a 3-bit number
// is red (R), green (G), and blue (B)
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module mux(
    input logic clk, reset,
    output logic [2:0] cnt,
    output logic R, G, B, color
    );
    
    //counter
    always_ff @( posedge clk )
        if( reset ) cnt <= 3'd0;
        else cnt <= cnt + 1;
        
    always_comb
        unique case (cnt)
            3'b001 : color = B;              
            3'b010 : color = G;
            3'b100 : color = R;
            default : color = 0;  // fills all bits with 0s
        endcase // case(cnt)
endmodule

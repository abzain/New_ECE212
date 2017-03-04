//////////////////////////////////////////////////////////////////////////////////
// Company: Lafayette College
// Engineer: Zainab Hussein
// 
// Create Date: 02/22/2017 07:42:27 PM
// Design Name: Lab 3
// Module Name: Scroller
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

module Scroller(
    // signals
    input logic clk, reset,
    input logic [4:0] col_cnt,
    output logic [11:0] colScroll
    );
    
    // logic
    logic [6:0] refresh_cnt;
    
    // column refresh counter
    always_ff@( posedge clk )
    begin
        if( reset )
            refresh_cnt <= 7'd0;
        else
            refresh_cnt <= refresh_cnt + 1;
    end
        
    // scroll columns
    // add blank columns to to programmed columns
    assign colScroll = col_cnt + refresh_cnt;
        
endmodule
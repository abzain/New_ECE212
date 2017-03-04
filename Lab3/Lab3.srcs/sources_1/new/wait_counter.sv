`timescale 1ns / 1ps

module wait_counter(
    input logic clk, 
    input logic reset, 
    input logic enb, 
    output logic [8:0] q );
               
    always_ff @(posedge clk)
        if ( reset ) q <= 9'd0;
        else if ( enb ) q <= q + 1;
        
endmodule
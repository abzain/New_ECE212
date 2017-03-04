`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Lafayette College
// Engineer: Zainab Hussein
// 
// Create Date: 02/22/2017 07:42:27 PM
// Design Name: Lab 3
// Module Name: Number_FSM
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


module Number_FSM(
    
    //signals
    input logic clk, pb, reset,
    output logic [2:0] col_no,
    output logic [3:0] we,
    output logic [8:0] wraddr
    );
    
    //logic
    logic colStart = 7'd96;
    
    //fsm logic 
    typedef enum logic [2:0] {
        idle = 3'b000,
        col_1 = 3'b001,
        col_2 = 3'b010,
        col_3 = 3'b011,
        col_4 = 3'b100,
        col_5 = 3'b101
    } states_t;
    
    states_t state, next;
    
    always_ff @( posedge clk ) //ensure each control signal held for 300ns
     if( reset )  state <= idle;
     else state <= next;    
    
    always_comb begin 
        next = idle;
        case( state )
        
        idle: 
            begin
                col_no = 3'b000;
                wraddr = 9'd0;
                we = 4'b0000;
                if( pb ) 
                    begin next = col_1; end
                else 
                    begin next = idle; end
            end
        col_1: 
            begin
                col_no = 3'b001;
                wraddr = colStart;
                we = 4'b1111;
                next = col_2;
            end
        col_2: 
            begin
                col_no = 3'b010;
                wraddr = colStart + 1;
                we = 4'b1111;
                next = col_3;
            end
        col_3: 
            begin
                col_no = 3'b011;
                wraddr = colStart + 2;
                we = 4'b1111;
                next = col_4;
            end
        col_4: 
            begin
                col_no = 3'b100;
                wraddr = colStart + 3;
                we = 4'b1111;
                next = col_5;
            end
 
        col_5: 
            begin
                col_no = 3'b101;
                wraddr = colStart + 4;
                we = 4'b1111;
                next = idle;
            end
            
        default:
            begin       
                col_no = 3'b000;
                wraddr = 9'd0;
                we = 4'b0000;
                next = idle;            
            end
        endcase
    end 
endmodule

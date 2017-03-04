//-----------------------------------------------------------------------------
// Title         : Nexys4 Simple Top-Level File
// Project       : ECE 212
//-----------------------------------------------------------------------------
// File          : Nexys.sv
// Author        : Zainab Hussein
// Created       : 2.8.2017
// Last modified : 2.8.2017
//-----------------------------------------------------------------------------
// Description :
// This file provides a starting point for Lab 1 and includes some basic I/O
// ports.  To use, un-comment the port declarations and the corresponding
// configuration statements in the constraints file "Nexys4.xdc".
// This module only declares some basic i/o ports; additional ports
// can be added - see the board documentation and constraints file
// more information
//-----------------------------------------------------------------------------
// Modification history :
// 2.8.2017 : created
//-----------------------------------------------------------------------------
//`define TEST;   //debugging tool
module Nexys4 (
    // un-comment the ports that you will use
    input logic         CLK100MHZ,
    input logic         BTNU, //reset
    output logic [6:0]  JA, 
    output logic [6:0]  JB                 		  
            );
            
    //internal signals
    logic [3:0] row_cnt;
    logic [4:0] col_cnt;
    logic threeNs_clk, clk_shift ;
    logic lat, OE, en_row, en_col;
    logic JA1, JA2, JA3, JA7, JA8, JA9;
    logic JB1, JB2, JB3, JB7, JB8, JB9;
    logic R_top, G_top, B_top, R_bot, G_bot, B_bot;
    //logic GND;        //needs to be connected to any 3 grounds
    
    parameter BAUD = 3333333;  // desired frequency in Hz 1/300ns
    parameter DUAB = 100;      // each row should be refreshed 100 times/sed, f=100
    
    // add SystemVerilog code & module instantiations here
    counter #(4) rowCounter( .clk(CLK100MHZ), .reset(BTNU), .enb(en_row),  .q(row_cnt), .carry(1'b0) );
    counter #(5) colCounter( .clk(CLK100MHZ), .reset(BTNU), .enb(en_col),  .q(col_cnt), .carry(1'b0) );
    counter #(2) waitCounter( .clk(CLK100MHZ), .reset(BTNU), .enb(wait_clk),  .q(wait_cnt), .carry(1'b0) );
    clkdiv #(.DIVFREQ(BAUD)) holdRowCD(.clk(CLK100MHZ), .reset(BTNU), .sclk(threeNs_clk));
    clkdiv #(.DIVFREQ(BAUD)) waitCD(.clk(CLK100MHZ), .reset(BTNU), .sclk(wait_clk));
    
    //RGB color assignment
    assign JA1 = row_cnt[0]; //R0
    assign JA2 = row_cnt[1]; //G0
    assign JA3 = row_cnt[2]; //B0
    //bot   //unsure whther use of col_cnt is necessary cause just using row_cnt would work 
    assign JA7 = row_cnt[0];  //R1
    assign JA8 = row_cnt[1];  //G1
    assign JA9 = row_cnt[2];  //B1
    
    //Connect JB PORTS
    assign JB1 = row_cnt[0]; //A 
    assign JB2 = row_cnt[1]; //B
    assign JB3 = row_cnt[2]; //C
    assign JB7 = clk_shift; //CLK
    assign JB8 = OE; //OE
    assign JB9 = lat; //LAT

    //fsm logic for enable assignment
    typedef enum logic [2:0] {
    S0 = 3'b000,
    S1 = 3'b001,
    S2 = 3'b010,
    S3 = 3'b011,
    S4 = 3'b100,
    WAIT = 3'b101
    } states_t;
    
    states_t state, next;
    
    always_ff @(posedge CLK100MHZ)
     if (BTNU)  state <= S0;
     else if(threeNs_clk) state <= next;    //ensure each control signal held for 300ns
    
    always_comb begin 
        next = S0;
        case( state )
        S0: //default state
            begin
              next = S1;
              lat = 0;
              OE = 0;   //high
              en_row = 1;
              en_col = 1;
              clk_shift = 0; 
            end
        S1: 
            begin
                if( col_cnt < 5'd31 ) //shift in values for 32 columns
                    begin 
                        next = S1; 
                        lat = 0;
                        OE = 1; //low
                        en_row = 0;
                        en_col = 1;
                        clk_shift = 1;
                    end
                else 
                    begin 
                        next = S2;
                        lat = 0;
                        OE = 1; //low
                        en_row = 0;
                        en_col = 0; 
                        clk_shift = 1;
                    end    
            end   
            
        S2: //turn off display and update ABC
            begin
                next = S3;
                lat = 0;
                OE = 1;
                en_row = 1;
                en_col = 0;
            end
        S3: //stop writing to latch and enable row to display latch values & hold row for 300ns
            begin
                next = S4;
                lat = 1;
                OE = 1; //high
                en_row = 0;
                en_col = 0;
            end
        S4: //assert output enable to enable display
            begin
                next = WAIT;
                lat = 0;
                OE = 0;
                en_row = 0;
                en_col = 0;
            end
  //wait time for LED's to fully turn on, 100 times/s per row, thus count till o.o1s 
  //(using a counter that is enabled with a 100Hz clock (100 times/sec)
        WAIT: 
            begin
                if( wait_cnt < 1)
                    begin next = WAIT; end
                else
                    begin next = S0; end
            end
            
        default:
        next = S0;
        endcase
    end 
 
 
 //debugging tool, don't delete it isn't active
`ifdef TEST
`else

 
 
`endif 
 //SPECIFIED IN CONSTRAINT FILE    
 assign JB1 = JB[0]; 
 assign JB2 = JB[1];
 assign JB3 = JB[2]; 
 assign JB7 = JB[4];
 assign JB8 = JB[5];
 assign JB9 = JB[6];
 
 assign JA1 = JA[0];  
 assign JA2 = JA[1];
 assign JA3 = JA[2]; 
 assign JA7 = JA[4];
 assign JA8 = JA[5];
 assign JA9 = JA[6];
  
endmodule // nexys4

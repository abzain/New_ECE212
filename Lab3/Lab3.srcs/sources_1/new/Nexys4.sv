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
module toplevel (
    input logic         CLK100MHZ,
    input logic         BTNU, BTNC, //reset
    input logic  [2:0]  SW, //color control
    output logic        JA1, JA2, JA3, JA7, JA8, JA9, 
    output logic        JB1, JB2, JB3, JB7, JB8, JB9                 		  
    );
            
    //internal signals
    logic [2:0] row_cnt, col_no, ledRow;
    logic [4:0] col_cnt, scol_cnt;
    logic threeNs_clk, clk_shift ;
    logic lat, OE, en_row, en_col, en_wait;
    logic [2:0] cnt;
    logic btnu_dbn, btnu_pls;
    logic [11:0] scroll_cnt;
    logic clk, reset;
    logic [31:0] DI, character;
    logic [9:0] rdAddr, charAddr;
    logic [3:0] we;
    logic rd_en, wr_en; 
    logic [8:0] wrAddr;
    logic [3:0] DO_bot, DO_top, number;
    logic [31:0] color_control;
    
    assign color_control = {8{1'b0, SW}};
    assign scol_cnt = col_cnt+1;
    assign ledRow = row_cnt+1;
    assign rdAddr = {scroll_cnt, ledRow};
    assign charAddr = {scroll_cnt, col_no};
    assign DI = character & color_control ; //control serving number and color
    
    parameter BAUD = 3000000;  // desired frequency in Hz 1/300ns
    parameter scroll = 10;   //scroll specified at 100ms-200ms
   
    // add SystemVerilog code & module instantiations here
    Pulse_debounce U_DBN0( .clk(threeNs_clk), .button_in(BTNU), .button_out(btnu_dbn), .pulse(btnu_pls) );
    Pulse_debounce U_DBN1( .clk(threeNs_clk), .button_in(BTNC), .button_out(btnc_dbn), .pulse(pb) );
    clkdiv #( .DIVFREQ(BAUD)) hold300ns(.clk(CLK100MHZ), .reset(btnu_pls), .sclk(threeNs_clk) );
    clkdiv #( .DIVFREQ(scroll)) scrollClk(.clk(CLK100MHZ), .reset(btnu_pls), .sclk(scrClk) );
    col_counter U_col( .clk(threeNs_clk) , .reset(btnu_pls), .enb(en_col),  .q(col_cnt) );
    fsm U_fsm(  .clk(CLK100MHZ), .reset(btnu_pls), .en_col(en_col), .en_wait(en_wait), .en_row(en_row), 
                .OE(OE), .lat(lat), .clk_shift(clk_shift) );
    row_counter U_row( .clk(threeNs_clk), .reset(btnu_pls), .enb(en_row), .q(row_cnt) );
    
    BOTTOM_BRAM U_bot( .clk(threeNs_clk), .reset(btnu_pls), .DI(DI), .rdAddr(rdAddr), .we(we), .rd_en(1'b1), 
                        .wr_en(1'b1), .wrAddr(wrAddr), .DO(DO_bot) );
    TOP_BRAM U_top( .clk(threeNs_clk), .reset(btnu_pls), .DI(1'b1), .rdAddr(rdAddr), .we(4'd0), .rd_en(1'b1), 
                    .wr_en(1'b0), .wrAddr(12'd0), .DO(DO_top) );
    Scroller U_scroll( .clk(scrClk), .reset(btnu_pls), .col_cnt(scol_cnt), .colScroll(scroll_cnt) );
    Character_creator U_create( .clk(CLK100MHZ), .reset(btnu_pls), .number(number), .rdAddr(charAddr), .we(we), 
                                .rd_en(1'b1), .wr_en(1'b1), .wrAddr(wrAddr), .character(character)  );
    Number_FSM U_Num( .clk(threeNs_clk), .pb(pb), .reset(btnu_pls), .col_no(col_no), .we(we), .wraddr(wrAddr)  );
    Number_counter U_counter( .clk(threeNs_clk), .reset(btnu_pls), .enb(pb), .q(number) );
    
    //RGB color assignment
        //top
        assign JA1 = DO_top[2]; //R0
        assign JA2 = DO_top[1]; //G0
        assign JA3 = DO_top[0]; //B0
       
        //bot
        assign JA7 = DO_bot[2]; //R1
        assign JA8 = DO_bot[1]; //G1
        assign JA9 = DO_bot[0]; //B1
        
        //abc
        assign JB1 = row_cnt[0]; //A 
        assign JB2 = row_cnt[1]; //B
        assign JB3 = row_cnt[2]; //C
        
        assign JB7 = clk_shift; //CLK
        assign JB8 = OE; //OE
        assign JB9 = lat; //LAT
    
endmodule 

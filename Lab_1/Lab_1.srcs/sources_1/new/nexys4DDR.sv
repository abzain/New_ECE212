//-----------------------------------------------------------------------------
// Title         : Nexys4 Simple Top-Level File
// Project       : ECE 212
//-----------------------------------------------------------------------------
// File          : nexys4DDR.sv
// Author        : John Nestor  <nestorj@nestorj-mbpro-15>
// Created       : 22.07.2016
// Last modified : 22.07.2016
//-----------------------------------------------------------------------------
// Description :
// This file provides a starting point for Lab 1 and includes some basic I/O
// ports.  To use, un-comment the port declarations and the corresponding
// configuration statements in the constraints file "Nexys4DDR.xdc".
// This module only declares some basic i/o ports; additional ports
// can be added - see the board documentation and constraints file
// more information
//-----------------------------------------------------------------------------
// Modification history :
// 22.07.2016 : created
//-----------------------------------------------------------------------------
//`define TEST;   //debugging tool
module nexys4DDR (
		  // un-comment the ports that you will use
          input logic         CLK100MHZ,
//		  input logic [15:0]  SW,
		  input logic 	      BTNC,
		  input logic 	      BTNU, //reset
		  input logic 	      BTNL, 
		  input logic 	      BTNR,
//		  input logic 	      BTND,
//		  output logic [6:0]  SEGS,
//		  output logic [7:0]  AN,
//		  output logic 	      DP,
		  output logic [15:0] led
//		  input logic         UART_TXD_IN,
//		  input logic         UART_RTS,		  
//		  output logic        UART_RXD_OUT,
//		  output logic        UART_CTS		  
            );
            
  //internal signals
  logic btnc_pls, btnr_pls, btnl_pls, btnu_pls;
  logic btnc_dbn, btnr_dbn, btnl_dbn, btnu_dbn;
  
  // add SystemVerilog code & module instantiations here
  //debouncing
 debounce U_DBN_C( .clk(CLK100MHZ), .button_in(BTNC), .button_out(btnc_dbn), .pulse(btnc_pls) );
 debounce U_DBN_R( .clk(CLK100MHZ), .button_in(BTNR), .button_out(btnr_dbn), .pulse(btnr_pls) );
 debounce U_DBN_L( .clk(CLK100MHZ), .button_in(BTNL), .button_out(btnl_dbn), .pulse(btnl_pls) );
 debounce U_DBN_U( .clk(CLK100MHZ), .button_in(BTNU), .button_out(btnu_dbn), .pulse(btnu_pls) );
 
 //fsm logic for blink mode
 logic [1:0] led_state;
 typedef enum logic [1:0] {
    solid = 2'b00,
    oneHz = 2'b01,
    twoHz = 2'b10
 } states_t;
 
 states_t state, next;
 
 always_ff @(posedge CLK100MHZ)
     if (btnu_pls)  state <= solid;
     else state <= next;
 
 always_comb
 begin 
    next = solid;
    case( state )
    solid:
        begin
            if (btnc_pls) next = oneHz;
            else next = solid;
        end
    oneHz:
        begin
            if (btnc_pls) next = twoHz;
            else next = oneHz;
        end   
    twoHz:
        begin
            if (btnc_pls) next = solid;
            else next = twoHz;
        end
        
    default:
    next = solid;
    endcase
 end
 assign led_state = state;
 
 //counter for led shift
 logic [3:0] cnt;
 always_ff @(posedge CLK100MHZ)
    if (btnu_pls) cnt <= 4'd0;
    else if (btnr_pls) cnt <= cnt - 1; //shift right
    else if (btnl_pls) cnt <= cnt + 1; //shift left

 // use demux to get 16 bits of LED
 logic [15:0] led_shift;
 
 //testing always comb block
`ifdef TEST
assign led_shift = 16'b0000000000000001;
`else

 always_comb
 case(cnt)
    4'd0: led_shift = 16'b0000000000000001;
    4'd1: led_shift = 16'b0000000000000010;
    4'd2: led_shift = 16'b0000000000000100;
    4'd3: led_shift = 16'b0000000000001000;
    4'd4: led_shift = 16'b0000000000010000;
    4'd5: led_shift = 16'b0000000000100000;
    4'd6: led_shift = 16'b0000000001000000;
    4'd7: led_shift = 16'b0000000010000000;
    4'd8: led_shift = 16'b0000000100000000;
    4'd9: led_shift = 16'b0000001000000000;
    4'd10: led_shift = 16'b0000100000000000;
    4'd11: led_shift = 16'b0001000000000000;
    4'd12: led_shift = 16'b0010000000000000;
    4'd13: led_shift = 16'b0100000000000000;
    4'd14: led_shift = 16'b1000000000000000;
    4'd15: led_shift = 16'b0000000000000001;
    default: led_shift = 16'b0000000000000001;
 endcase
 
 `endif 
    
  //blink rate mux
    parameter BAUD = 1;  // desired frequency in Hz 
    parameter TWICEBAUD = 2;
  
  //clkdiv 
    logic oneHz_clk, twoHz_clk, solid_clk;
    clkdiv #(.DIVFREQ(BAUD)) U_CD_oneHz(.clk(CLK100MHZ), .reset(BTNU), .sclk(oneHz_clk));
    clkdiv #(.DIVFREQ(TWICEBAUD)) U_CD_twoHz(.clk(CLK100MHZ), .reset(BTNU), .sclk(twoHz_clk));  
   // clkdiv #(.DIVFREQ(100)) U_CD_solid(.clk(CLK100MHZ), .reset(BTNU), .sclk(solid_clk));

  //mux for blink rate selection based on blink mode
    logic blink;
   
 //testing blink rate mux 
`ifdef TEST
assign blink = 1;
`else

    always_comb
      unique case (led_state)
        2'd0 : blink = 1;              
        2'd1 : blink = oneHz_clk;
        2'd2 : blink = twoHz_clk;
        default : blink = 0;  // fills all bits with 0s
      endcase // case(led_state)
      
`endif

 //display
 //replicate blink 16 bits and wire led
  assign led = ( {16{blink}} & led_shift );
  
// assign led = 16'b1010101010101010;  //for testing
endmodule // nexys4DDR

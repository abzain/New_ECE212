`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Lafayette College
// Engineer: Zainab Hussein
// 
// Create Date: 02/06/2017 12:34:56 PM
// Design Name: Nexys4Testbench
// Module Name: Nexys4Test
// Project Name: FPGA & Logic Design Refresher
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


module Nexys4Test();
    // inputs
    logic CLK100MHZ;
    logic BTNR;
    logic BTNL;
    logic BTNU;
    logic BTNC;
    //output
    logic  [15:0] led;

    // instantiate device under verification (nexys4DDR) 
    nexys4DDR  DUV(.CLK100MHZ, .BTNC, .BTNU, .BTNL, .BTNR, .led );

    // clock generator with period=20 time units
    always begin
        CLK100MHZ = 0;  #10; 
        CLK100MHZ = 1;  #10;
     end

    //stimulus
	initial begin
	   	// Initialize Inputs
		CLK100MHZ= 0;
		BTNU = 1;	//reset
		BTNC = 0; 
		BTNL = 0;
		BTNR = 0;
	
	  	// Wait 100 ns for global reset to finish
		#10;
	  	@(posedge CLK100MHZ) #1;
	   	BTNU = 0;
		BTNC = 1; 	//change in flash mode
		BTNL = 1;	//lsb led move left 1
		BTNR = 0;
		repeat(10) @(posedge CLK100MHZ) #1;
        BTNL = 0;    //lsb led move left 1
        BTNR = 1;
        repeat(10) @(posedge CLK100MHZ) #1;
		BTNC = 0;
		repeat(10) @(posedge CLK100MHZ) #1;
		BTNU = 1;	//reset led
		repeat(5) @(posedge CLK100MHZ) #1;
	  	 $stop;
	end
   
endmodule

   


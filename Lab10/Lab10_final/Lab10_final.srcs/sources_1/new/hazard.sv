`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Zainab Hussein
// 
// Create Date: 05/01/2017 12:12:03 AM
// Design Name: 
// Module Name: hazard
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

// Hazard Unit
module hazard(  input logic [4:0] rsD, rtD, rsE, rtE,
                input logic [4:0] writeregE, writeregM, writeregW,
                input logic       regwriteE, regwriteM, regwriteW,
                input logic       memtoregE, memtoregM, branchD,
                output logic      forwardaD, forwardbD,
                output logic [1:0] forwardaE, forwardbE,
                output logic      stallF, stallD, flushE);
	logic lwstallD, branchstallD;
	
	// forwarding sources to D stage (branch equality)
	assign forwardaD = ((rsD != 0) & (rsD == writeregM) & regwriteM);
	assign forwardbD = ((rtD != 0) & (rtD == writeregM) & regwriteM);
	
	// forwarding sources to E stage (ALU)
    always @(*)
        begin
            if( (rsE != 0) & (rsE == writeregM) & regwriteM ) forwardaE = 2'b10;
            else if( (rsE != 0) & (rsE == writeregW) & regwriteW ) forwardaE = 2'b01;
            else forwardaE = 2'b00;
        end
        
    always @(*)
          begin
              if( (rtE != 0) & (rtE == writeregM) & regwriteM ) forwardbE = 2'b10;
              else if( (rtE != 0) & (rsE == writeregW) & regwriteW ) forwardbE = 2'b01;
              else forwardbE = 2'b00;
          end
        
	// stalls
	assign lwstallD = ( (rsD == rtE) | (rtD == rtE) ) & memtoregE;
	assign  branchstallD = branchD &
	           (regwriteE & (writeregE == rsD | writeregE == rtD) |
	            memtoregM & (writeregM == rsD | writeregM == rtD));
	assign  stallD = lwstallD | branchstallD;
	assign  stallF = stallD; // stalling D stalls all previous stages
	assign   flushE = stallD; // stalling D flushes next stage
endmodule

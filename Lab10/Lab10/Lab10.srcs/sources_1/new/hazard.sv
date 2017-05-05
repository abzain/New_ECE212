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
	assign forwardaD = (rsD != 0 & rsD == writeregM & regwriteM);
	assign forwardbD = (rtD != 0 & rtD == writeregM & regwriteM);
	
	// forwarding sources to E stage (ALU)
	always @(*)
        begin
            forwardaE = 2'b00; forwardbE = 2'b00;
            if (rsE != 0)
                if (rsE == writeregM & regwriteM) forwardaE = 2'b10;
                else if (rsE == writeregW & regwriteW) forwardaE = 2'b01;
            if (rtE != 0)
                if (rtE == writeregM & regwriteM) forwardbE = 2'b10;
                else if (rtE == writeregW & regwriteW) forwardbE = 2'b01;
        end
	// stalls - execute after 1 clock cycles
	assign #1 lwstallD = memtoregE & (rtE == rsD | rtE == rtD);
	assign #1 branchstallD = branchD &
	           (regwriteE & (writeregE == rsD | writeregE == rtD) |
	            memtoregM & (writeregM == rsD | writeregM == rtD));
	assign #1 stallD = lwstallD | branchstallD;
	assign #1 stallF = stallD; // stalling D stalls all previous stages
	assign #1 flushE = stallD; // stalling D flushes next stage
endmodule

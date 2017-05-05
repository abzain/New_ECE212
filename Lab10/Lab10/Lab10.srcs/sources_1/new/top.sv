//////////////////////////////////////////////////////////////////////////////////
// Company: Lafayette College
// Engineer: Zainab Hussein
// 
// Create Date: 04/25/2017 08:59:39 PM
// Design Name: 
// Module Name: top
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
module top(input  logic        clk, reset, 
           output logic [31:0] writedataM, dataadr, 
           output logic        memwriteM);

  logic [31:0] readdataM;
  
  // microprocessor (control & datapath)
  pipeline_mips mips( clk, reset, memwriteM, dataadr, writedataM, readdataM );
  // memory 
  mem mem(clk, memwriteM, dataadr, writedataM, readdataM);

endmodule

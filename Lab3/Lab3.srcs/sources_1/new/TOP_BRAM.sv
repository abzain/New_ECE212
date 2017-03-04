`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Lafayette College
// Engineer: Zainab Hussein
// 
// Create Date: 02/22/2017 10:37:31 PM
// Design Name: Lab 3
// Module Name: TOP_BRAM
// Project Name: LED Scrolling Matrix
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

module TOP_BRAM(
    // signals
    input logic clk, reset,
    input logic  DI,
    input logic [9:0] rdAddr,
    input logic [3:0] we,
    input logic rd_en, wr_en, 
    input logic [8:0] wrAddr,
    output logic [3:0] DO
    );
    
    BRAM_SDP_MACRO #(
        .BRAM_SIZE("18Kb"), // Target BRAM, "18Kb" or "36Kb"
        .DEVICE("7SERIES"), // Target
        .WRITE_WIDTH(32), // Valid values are 1­72 (37­72 only valid when BRAM_SIZE="36Kb")
        .READ_WIDTH(4), // Valid values are 1­72 (37­72 only valid when BRAM_SIZE="36Kb")
        // ECE212 Message
        .INIT_00(256'h0000000000000000000000000000000000000000000000000000000000000000),
        .INIT_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
        .INIT_02(256'h0000000000000000000000000000000000000000000000000000000000000000),
        .INIT_03(256'h0000000000000000000000000000000000000000000000000000000000000000),
        .INIT_04(256'h10000004_01226640_00000000_10000004_10006004_10006004_10006004_11226644),
        .INIT_05(256'h10006004_10006004_10006004_11226644_00000000_01000040_10000004_10000004),
        .INIT_06(256'h10020004_10200004_11000040_00000000_00000000_00000000_00000000_10000004),
        .INIT_07(256'h11000040_00000000_10000000_11226644_10000040_00000000_10000640_10006004),
        .INIT_08(256'h00000000_00000000_00000000_00000000_10000640_10006004_10020004_10200004))

        
    BRAM_SDP_MACRO_two (
        .DO(DO), // Output read data port, width defined by READ_WIDTH parameter
        .DI(DI), // Input write data port, width defined by WRITE_WIDTH parameter
        .RDADDR(rdAddr), // Input read address, width defined by read port depth
        .RDCLK(clk), // 1­bit input read clock
        .RDEN(rd_en), // 1­bit input read port enable
        .RST(reset), // 1­bit input reset
        .WE(we), // Input write enable, width defined by write port depth
        .WRADDR(wrAddr), // Input write address, width defined by write port depth
        .WRCLK(clk), // 1­bit input write clock
        .WREN(wr_en) // 1­bit input write port enable
    );
    
endmodule

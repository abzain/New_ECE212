`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Lafayette College
// Engineer: Zainab Hussein
// 
// Create Date: 02/22/2017 10:37:31 PM
// Design Name: Lab 3
// Module Name: BOTTOM_BRAM
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

module BOTTOM_BRAM(
    // signals
    input logic clk, reset,
    input logic [31:0] DI,
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
        // Now Serving Message
        .INIT_00(256'h0000000000000000000000000000000000000000000000000000000000000000),
        .INIT_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
        .INIT_02(256'h0000000000000000000000000000000000000000000000000000000000000000),
        .INIT_03(256'h0000000000000000000000000000000000000000000000000000000000000000),
        .INIT_04(256'h10006000_01220000_00000000_11226644_00200000_00026000_00000600_11226644),
        .INIT_05(256'h10000000_01220000_10000000_01226000_00000000_01220000_10006000_10006000),
        .INIT_06(256'h10020004_10020004_10006640_00000000_00000000_00000000_00000000_01226000),
        .INIT_07(256'h00220000_10206000_10206000_10206000_01220000_00000000_01200004_10020004),
        .INIT_08(256'h00226000_00000000_00020000_00006000_00006000_00020000_11226000_00000000),
        .INIT_09(256'h11226000_00000000_11226040_00000000_00226000_01000000_10000000_01000000),
        .INIT_0A(256'h10020040_10020040_00006600_00000000_11226000_00000600_00000600_00006000),
        .INIT_0B(256'h000000000000000000000000000000000000000000000000_01226600_10020040))

        
    BRAM_SDP_MACRO_three (
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
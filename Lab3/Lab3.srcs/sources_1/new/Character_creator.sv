//////////////////////////////////////////////////////////////////////////////////
// Company: Lafayette College
// Engineer: Zainab Hussein
// 
// Create Date: 02/22/2017 07:42:27 PM
// Design Name: Lab 3
// Module Name: Character_creator
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

module Character_creator(
    // signals
    input logic clk, reset,
    input logic [3:0] number,
    input logic [9:0] rdAddr,
    input logic [3:0] we,
    input logic rd_en, wr_en, 
    input logic [8:0] wrAddr,
    output logic [31:0] character
    );
    //
    BRAM_SDP_MACRO #(
        .BRAM_SIZE("18Kb"), // Target BRAM, "18Kb" or "36Kb"
        .DEVICE("7SERIES"), // Target
        .WRITE_WIDTH(32), // Valid values are 1­72 (37­72 only valid when BRAM_SIZE="36Kb")
        .READ_WIDTH(4), // Valid values are 1­72 (37­72 only valid when BRAM_SIZE="36Kb")
        .INIT_00(256'h000000000000000000000000_07777770_70000007_70000007_70000007_07777770),       //character 0, 5 32_bit cols
        .INIT_01(256'h000000000000000000000000_00000000_70000000_77777777_70000070_00000000),        //character 1, 5 32_bit cols
        .INIT_02(256'h000000000000000000000000_70000770_70007007_70070007_70700007_77000070),       //character 2, 5 32_bit cols
        .INIT_03(256'h000000000000000000000000_07770770_70007007_70007007_70000007_07000070),       //character 3, 5 32_bit cols
        .INIT_04(256'h000000000000000000000000_77777777_00007000_00007000_00007000_00007777),       //character 4, 5 32_bit cols
        .INIT_05(256'h000000000000000000000000_07770007_70007007_70007007_70007007_07007777),       //character 5, 5 32_bit cols
        .INIT_06(256'h000000000000000000000000_07770000_70007007_70007070_70007700_07777000),       //character 6, 5 32_bit cols
        .INIT_07(256'h000000000000000000000000_00000077_00007707_00770007_77000007_00000007),        //character 7, 5 32_bit cols
        .INIT_08(256'h000000000000000000000000_07770770_70007007_70007007_70007007_07770770),       //character 8, 5 32_bit cols
        .INIT_09(256'h000000000000000000000000_77777770_00007007_00007007_00007007_00000770))       //character 9, 5 32_bit cols
        
    BRAM_SDP_MACRO_one (
        .DO(character), // Output read data port, width defined by READ_WIDTH parameter
        .DI(number), // Input write data port, width defined by WRITE_WIDTH parameter
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
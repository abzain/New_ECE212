module MACC(
    input logic clk, reset, enb,
    input logic [17:0] A, B,
    output logic [35:0] AccVal
);
    MACC_MACRO #(
      .DEVICE("7SERIES"), // Target Device: "7SERIES" 
      .LATENCY(3),        // Desired clock cycle latency, 1-4
      .WIDTH_A(25),       // Multiplier A-input bus width, 1-25
      .WIDTH_B(18),       // Multiplier B-input bus width, 1-18
      .WIDTH_P(48)        // Accumulator output bus width, 1-48
    ) MACC_MACRO_inst (
      .P(AccVal),     // MACC output bus, width determined by WIDTH_P parameter 
      .A(A),     // MACC input A bus, width determined by WIDTH_A parameter 
      .ADDSUB(ADDSUB), // 1-bit add/sub input, high selects add, low selects subtract
      .B(B),     // MACC input B bus, width determined by WIDTH_B parameter 
      .CARRYIN(CARRYIN), // 1-bit carry-in input to accumulator
      .CE(CE),     // 1-bit active high input clock enable
      .CLK(clk),   // 1-bit positive edge clock input
      .LOAD(enb), // 1-bit active high input load accumulator enable
      .LOAD_DATA(LOAD_DATA), // Load accumulator input data, width determined by WIDTH_P parameter
      .RST(reset)    // 1-bit input active high reset
    );
// End of MACC_MACRO_inst instantiation
endmodule			
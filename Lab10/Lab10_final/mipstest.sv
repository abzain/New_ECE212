//------------------------------------------------
// mipstest.sv
// David_Harris@hmc.edu 23 October 2005
// Updated to SystemVerilog dmh 12 November 2010
// Testbench for MIPS processor
//------------------------------------------------

module testbench();

  logic        clk;
  logic        reset;
  logic [31:0] writedataM, dataadr;
  logic        memwriteM;

  // instantiate device to be tested
  top dut(clk, reset,writedataM, dataadr, memwriteM);
  
  // initialize test
  initial
    begin
      reset <= 1; # 22; reset <= 0;
    end

  // generate clock to sequence tests
  always
    begin
      clk <= 1; # 5; clk <= 0; # 5;
    end

  // check that 7 gets written to address 84
  always@(negedge clk)
    begin
      if(memwriteM) begin
        if(dataadr === 84 & writedataM === 7) begin      
          $display("Simulation succeeded");
          $stop;
        end else if (dataadr !== 80) begin
          $display("Simulation failed");
          $stop;
        end
      end
    end
endmodule




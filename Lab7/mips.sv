//--------------------------------------------------------------
// mips.sv
// David_Harris@hmc.edu and Sarah_Harris@hmc.edu 23 October 2005
// Updated to SystemVerilog dmh 12 November 2010
// Single-cycle MIPS processor
//--------------------------------------------------------------

// files needed for simulation:
//  mipsttest.v
//  mipstop.v
//  mipsmem.v
//  mips.v
//  mipsparts.v

// single-cycle MIPS processor
module mips(input  logic        clk, reset,
            output logic [31:0] pc,
            input  logic [31:0] instr,
            output logic        memwrite,
            output logic [31:0] aluout, writedata,
            input  logic [31:0] readdata);

  logic        memtoreg, branch,
               pcsrc, zero,
               regdst, regwrite, jump;
  logic [2:0]  alucontrol;
  logic [1:0]  alusrc; // CONVERTED FROM 1 to 2 bits TO EXPAND MUX

  controller c(instr[31:26], instr[5:0], zero, 
               memtoreg, memwrite, pcsrc,
               alusrc, regdst, regwrite, jump,
               alucontrol);
  datapath dp(clk, reset, memtoreg, pcsrc,
              alusrc, regdst, regwrite, jump,
              alucontrol,
              zero, pc, instr, 
              aluout, writedata, readdata);
endmodule

module controller(input  logic [5:0] op, funct,
                  input  logic       zero, 
                  output logic       memtoreg, memwrite,
                  output logic       pcsrc, alusrc,
                  output logic       regdst, regwrite,
                  output logic       jump,
                  output logic [2:0] alucontrol);

  logic [1:0] aluop;
  logic       branch;
  logic  bne; //ADDED BNE
  
  maindec md(op, memtoreg, memwrite, branch,
             alusrc, regdst, regwrite, jump,
             aluop);
  aludec  ad(funct, aluop, alucontrol);

  assign pcsrc = branch & ( zero ^ bne );   //XOR zero and bne
endmodule

module maindec(input  logic [5:0] op,
               output logic       memtoreg, memwrite,
               output logic       branch, alusrc,
               output logic       regdst, regwrite,
               output logic       jump,
               output logic [1:0] aluop);

  logic [10:0] controls;        //EXPANDED FROM 9 to 11 BITS

  assign {regwrite, regdst, alusrc,
          branch, memwrite,
          memtoreg, jump, aluop, bne} = controls;   //ADDED BNE CONTROL
		  
  always_comb
    case(op)     
      6'b000000: controls <= 11'b11000000100; //Rtype
      6'b001101: controls <= 11'b10100000110; //ORI ADDED
      6'b100011: controls <= 11'b10010010000; //LW
      6'b101011: controls <= 11'b00010100000; //SW
      6'b000100: controls <= 11'b00001000010; //BEQ
      6'b001000: controls <= 11'b10010000000; //ADDI
      6'b000010: controls <= 11'b00000001000; //J
      6'b000101: controls <= 11'b00001000011; //BNE ADDED
      default:   controls <= 11'bxxxxxxxxxxx; //???
    endcase
endmodule

module aludec(input  logic [5:0] funct,
              input  logic [1:0] aluop,
              output logic [2:0] alucontrol);

  always_comb
    case(aluop)
      2'b00: alucontrol <= 3'b010;  // add
      2'b01: alucontrol <= 3'b110;  // sub
      2'b11: alucontrol <= 3'b001;  // ori  //ADDED
      default: case(funct)          // RTYPE
          6'b100000: alucontrol <= 3'b010; // ADD
          6'b100010: alucontrol <= 3'b110; // SUB
          6'b100100: alucontrol <= 3'b000; // AND
          6'b100101: alucontrol <= 3'b001; // OR
          6'b101010: alucontrol <= 3'b111; // SLT
          default:   alucontrol <= 3'bxxx; // ???
        endcase
    endcase
endmodule

module datapath(input  logic        clk, reset,
                input  logic        memtoreg, pcsrc,
                input  logic        alusrc, regdst,
                input  logic        regwrite, jump,
                input  logic [2:0]  alucontrol,
                output logic        zero,
                output logic [31:0] pc,
                input  logic [31:0] instr,
                output logic [31:0] aluout, writedata,
                input  logic [31:0] readdata);

  logic [4:0]  writereg;
  logic [31:0] pcnext, pcnextbr, pcplus4, pcbranch;
  logic [31:0] signimm, signimmsh, zeroext; //ADDED ZEROEXT
  logic [31:0] srca, srcb;
  logic [31:0] result;

  // next PC logic
  flopr #(32) pcreg(clk, reset, pcnext, pc);
  adder       pcadd1(pc, 32'b100, pcplus4);
  sl2         immsh(signimm, signimmsh);
  adder       pcadd2(pcplus4, signimmsh, pcbranch);
  mux2 #(32)  pcbrmux(pcplus4, pcbranch, pcsrc,
                      pcnextbr);
  mux2 #(32)  pcmux(pcnextbr, {pcplus4[31:28], 
                    instr[25:0], 2'b00}, 
                    jump, pcnext);

  // register file logic
  regfile     rf(clk, regwrite, instr[25:21],
                 instr[20:16], writereg,
                 result, srca, writedata);
  mux2 #(5)   wrmux(instr[20:16], instr[15:11],
                    regdst, writereg);
  mux2 #(32)  resmux(aluout, readdata,
                     memtoreg, result);
  signext     se(instr[15:0], signimm);
  zeroext     ze(instr[15:0], zeroext);
  // ALU logic
  mux3 #(32)  srcbmux(writedata, signimm, zeroext, alusrc,  //EXPANDED MUX WITH ADDITIONAL ZEROEXT input
                      srcb);
  alu         alu(.a(srca), .b(srcb), .f(alucontrol),
                  .y(aluout), .zero(zero));
endmodule


// Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2016.2 (win64) Build 1577090 Thu Jun  2 16:32:40 MDT 2016
// Date        : Thu Mar 02 16:52:04 2017
// Host        : ECE419-1WFQM02 running 64-bit Service Pack 1  (build 7601)
// Command     : write_verilog -force -mode funcsim
//               c:/Users/husseinz/Desktop/ece_212/HW4/HW4.srcs/sources_1/ip/mult_gen_0/mult_gen_0_sim_netlist.v
// Design      : mult_gen_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "mult_gen_0,mult_gen_v12_0_11,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "mult_gen_v12_0_11,Vivado 2016.2" *) 
(* NotValidForBitStream *)
module mult_gen_0
   (CLK,
    A,
    B,
    P);
  (* x_interface_info = "xilinx.com:signal:clock:1.0 clk_intf CLK" *) input CLK;
  (* x_interface_info = "xilinx.com:signal:data:1.0 a_intf DATA" *) input [17:0]A;
  (* x_interface_info = "xilinx.com:signal:data:1.0 b_intf DATA" *) input [17:0]B;
  (* x_interface_info = "xilinx.com:signal:data:1.0 p_intf DATA" *) output [35:0]P;

  wire [17:0]A;
  wire [17:0]B;
  wire CLK;
  wire [35:0]P;
  wire [47:0]NLW_U0_PCASC_UNCONNECTED;
  wire [1:0]NLW_U0_ZERO_DETECT_UNCONNECTED;

  (* C_A_TYPE = "0" *) 
  (* C_A_WIDTH = "18" *) 
  (* C_B_TYPE = "0" *) 
  (* C_B_VALUE = "10000001" *) 
  (* C_B_WIDTH = "18" *) 
  (* C_CCM_IMP = "0" *) 
  (* C_CE_OVERRIDES_SCLR = "0" *) 
  (* C_HAS_CE = "0" *) 
  (* C_HAS_SCLR = "0" *) 
  (* C_HAS_ZERO_DETECT = "0" *) 
  (* C_LATENCY = "1" *) 
  (* C_MODEL_TYPE = "0" *) 
  (* C_MULT_TYPE = "1" *) 
  (* C_OPTIMIZE_GOAL = "1" *) 
  (* C_OUT_HIGH = "35" *) 
  (* C_OUT_LOW = "0" *) 
  (* C_ROUND_OUTPUT = "0" *) 
  (* C_ROUND_PT = "0" *) 
  (* C_VERBOSITY = "0" *) 
  (* C_XDEVICEFAMILY = "artix7" *) 
  (* KEEP_HIERARCHY = "true" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  mult_gen_0_mult_gen_v12_0_11 U0
       (.A(A),
        .B(B),
        .CE(1'b1),
        .CLK(CLK),
        .P(P),
        .PCASC(NLW_U0_PCASC_UNCONNECTED[47:0]),
        .SCLR(1'b0),
        .ZERO_DETECT(NLW_U0_ZERO_DETECT_UNCONNECTED[1:0]));
endmodule

(* C_A_TYPE = "0" *) (* C_A_WIDTH = "18" *) (* C_B_TYPE = "0" *) 
(* C_B_VALUE = "10000001" *) (* C_B_WIDTH = "18" *) (* C_CCM_IMP = "0" *) 
(* C_CE_OVERRIDES_SCLR = "0" *) (* C_HAS_CE = "0" *) (* C_HAS_SCLR = "0" *) 
(* C_HAS_ZERO_DETECT = "0" *) (* C_LATENCY = "1" *) (* C_MODEL_TYPE = "0" *) 
(* C_MULT_TYPE = "1" *) (* C_OPTIMIZE_GOAL = "1" *) (* C_OUT_HIGH = "35" *) 
(* C_OUT_LOW = "0" *) (* C_ROUND_OUTPUT = "0" *) (* C_ROUND_PT = "0" *) 
(* C_VERBOSITY = "0" *) (* C_XDEVICEFAMILY = "artix7" *) (* ORIG_REF_NAME = "mult_gen_v12_0_11" *) 
(* downgradeipidentifiedwarnings = "yes" *) 
module mult_gen_0_mult_gen_v12_0_11
   (CLK,
    A,
    B,
    CE,
    SCLR,
    ZERO_DETECT,
    P,
    PCASC);
  input CLK;
  input [17:0]A;
  input [17:0]B;
  input CE;
  input SCLR;
  output [1:0]ZERO_DETECT;
  output [35:0]P;
  output [47:0]PCASC;

  wire [17:0]A;
  wire [17:0]B;
  wire CE;
  wire CLK;
  wire [35:0]P;
  wire [47:0]PCASC;
  wire SCLR;
  wire [1:0]ZERO_DETECT;

  (* C_A_TYPE = "0" *) 
  (* C_A_WIDTH = "18" *) 
  (* C_B_TYPE = "0" *) 
  (* C_B_VALUE = "10000001" *) 
  (* C_B_WIDTH = "18" *) 
  (* C_CCM_IMP = "0" *) 
  (* C_CE_OVERRIDES_SCLR = "0" *) 
  (* C_HAS_CE = "0" *) 
  (* C_HAS_SCLR = "0" *) 
  (* C_HAS_ZERO_DETECT = "0" *) 
  (* C_LATENCY = "1" *) 
  (* C_MODEL_TYPE = "0" *) 
  (* C_MULT_TYPE = "1" *) 
  (* C_OPTIMIZE_GOAL = "1" *) 
  (* C_OUT_HIGH = "35" *) 
  (* C_OUT_LOW = "0" *) 
  (* C_ROUND_OUTPUT = "0" *) 
  (* C_ROUND_PT = "0" *) 
  (* C_VERBOSITY = "0" *) 
  (* C_XDEVICEFAMILY = "artix7" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  mult_gen_0_mult_gen_v12_0_11_viv i_mult
       (.A(A),
        .B(B),
        .CE(CE),
        .CLK(CLK),
        .P(P),
        .PCASC(PCASC),
        .SCLR(SCLR),
        .ZERO_DETECT(ZERO_DETECT));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2014"
`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="cds_rsa_key", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=64)
`pragma protect key_block
gD7l84kB+WAh1ATog3H36h0/cMgn9QL5jGe9p9PjvP7N+FJAVvGVlrxcgBw6dZaWDNZqNANQuRFv
ZSE8fsSCFg==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
YQUcxim/tlzHeVlJ7otHN7u41KO3Yg5DFb1yF4GCsbXGLtUvWNlkFjY+UPIlgYImR4Zo4dTHJQ+j
3BaUNSUOqAVzT9CfyUelv2YD2ZTfAtzIe1Mboyb3+StKnuzxnZmIhVPiZlowdW5lQ1r7BjDPOsge
ztxOfUTbvYcTUE1ABIE=

`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
eu4MFD/NMz3pssr62VCh1XDd9mthYydX9VaOq3lWUwHi5/7e5dl2SAWHtYwTnBgGPY+jCcMycJhy
WSlkhQxVj5BsMm2aAItwXFvH2mSbjlPggtI0/+DNGQ4x8LQSFLTDYnnQbBrHlJymsS+/asMkXACD
SJ2tF8LF5tMhAlMPZZ0=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
rNAzbNlIFUMjdhvgzZ2FokzvR4AuFtV+1AHGDKa9QgeBsZ1e0Fom48uKbJ9iakvqUoUcKKAvRzeY
OBkbx9P7Imx0gvIgzFsgiVw23cBYWOhbhSqVb7mef9aKx8yeF8T48n7gKldUkwBHIPeqaayRI9/Q
HCZO+k2+HCjRZE6L/Gzd+IOdEVUFOg3NtWFPk2JFkfZkxs8X7Vg/xxtvH7uvp+/EbVyiMbnwDT/p
NSqOyA+rJwBJYD3xRIPTFDI83XJLCF+1i4E8hyu7Y0F9MtjKugqEHwAG+JK3jde00nzNNaeLVUQ1
OfFMZJpkk0Cg66d2cvJY/G11oPkmvTq/JZ4+5g==

`pragma protect key_keyowner="ATRENTA", key_keyname="ATR-SG-2015-RSA-3", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
apuTRT8aJu0TR7Ciy6ONiGK4AT7TUEiokS4gFf1g+kDg6PdKk9VRun4HKszIadRtahjPQo0of9uS
yvu3GS4EQo+Y+T116wnAIXnZSa8EQaEsDkziOI+rCvXv8IgaPYN8Cq0aRlASFL7IHOWNI49V0c0A
FIG/+5U7ZyNQFCVwuE4gCgK/pA6apm5kY4FGJft/EdZ5YAbR/nCTzK4P53+XsKHrtGfw+/MthFWz
tI0OtloKqc7laKZWKOVFqWq8Qmq7UL6utFODtxEQqzczH+q+Gw4rkUyOosIY+cbB67hX+GlmXXEF
jMwvUcen9t6c+wiH6rmBDcUIiuUHHz6q+jCwJQ==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinx_2016_05", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
dfDj35aI8y6zqcW/IHFxmCDw2mpyex25qQAUnsL+tIRxivv/85PqpCOrf3b7NWnwUKMrsxtw+JBY
mtlPsVxQKR1gn6VkaHwbEgwxXXxFe71Z+1nWQhfF8Nt55jGvq1joWKMrurSV7Mo+HkvHMSszXj3v
8ElD0S6sN91oml0nObejOhxzHf0ybK+sGag+CFA7aBr4k4rYglf7AzOYrPl3nNoCkyrFDQFa46/w
SXJm/os7zUHbsDI5GGUH3BU+NktHZV6GK3iyhtHTwrMgDtpGk6vKHMKULM1Gjv9g1/jp9Ao4cUhr
bCVOXM1v2e8A3564rmh3if78zTzCKamPRAB5Ig==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="base64", line_length=76, bytes=256)
`pragma protect key_block
lE86YiTzjXXkLYNoj8AhJB15LWKRE6SCvua0OFCFvhmBSw6T3bbj4HqvKeOeqpfpfA1ey2jKgOv9
E5T0g8sTt6Tk5qGCABJVslBnW+w+YoMAWFF6SWCgybid/XvSU6nCmnZnisRszs7G+onwdGBlUdlK
f0V7chV0jxS/bZ/kvA6kGV61jgOhmrowD5mLPVt+w3bzCtpTTFsUtqI4+lLEywDicw1mpLKean4F
uKtuqwTJLE1a1URpmPLhqI3QXhjP3MxK2NlAnFH3efgsnmgggcH0UvfZYVSQAFoPBPKR4v5DyCbR
0K13S+BwEk4nJVxzqqXNpcvFGMAhQLjrr2mz5A==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP05_001", key_method="rsa"
`pragma protect encoding = (enctype="base64", line_length=76, bytes=256)
`pragma protect key_block
DY+IFZmOADu9ZJFi2wEBpAZv0y5bsoBkJYb+09DvTQ00ZsyLLj0f/XLjuMfJoLM/zGXNp9izgzqu
lEYeKO6V7JjNFOQJ2Rq04EpFsSK9DZEH7EtoJTHmQ/Cbhx2cLWwzhJxhnGWOQIOqrbqpjj/aykZA
70Luk4kaneqCcWpv5yGjKe7gWRkSgBCgG4feIQkqgrZbbKlhXlp6IEU5wQ3l/7OU6lET1OR9JrOr
hMSvO+XIFOCM11QCvFH7sr6pjmu2fEI3BlkbUOgjNmb1EJQLaYGgBgFGsIUMmH/ReP8L657H4aMR
kYShBqlZ1vvyI4sKulAV7pGcCC+Zy0k5xf5kFw==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 7216)
`pragma protect data_block
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
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (weak1, weak0) GSR = GSR_int;
    assign (weak1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule
`endif

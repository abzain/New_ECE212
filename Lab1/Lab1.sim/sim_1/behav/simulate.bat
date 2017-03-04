@echo off
set xv_path=C:\\Xilinx\\Vivado\\2016.2\\bin
call %xv_path%/xsim Nexys4Test_behav -key {Behavioral:sim_1:Functional:Nexys4Test} -tclbatch Nexys4Test.tcl -view C:/Users/husseinz/Desktop/ECE212/Lab1/Nexys4Test_behav.wcfg -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0

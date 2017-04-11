@echo off
<<<<<<< HEAD
set xv_path=C:\\Xilinx\\Vivado\\2016.2\\bin
=======
set xv_path=C:\\Xilinx\\Vivado\\2016.3\\bin
>>>>>>> origin/master
call %xv_path%/xsim testbench_behav -key {Behavioral:sim_1:Functional:testbench} -tclbatch testbench.tcl -view C:/Users/husseinz/Desktop/New_ECE212/Lab7/Lab_7/testbench_behav.wcfg -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0

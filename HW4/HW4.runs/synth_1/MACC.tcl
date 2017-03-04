# 
# Synthesis run script generated by Vivado
# 

set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
create_project -in_memory -part xc7a100tcsg324-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir C:/Users/husseinz/Desktop/ece_212/HW4/HW4.cache/wt [current_project]
set_property parent.project_path C:/Users/husseinz/Desktop/ece_212/HW4/HW4.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property board_part digilentinc.com:nexys4:part0:1.1 [current_project]
read_verilog -library xil_defaultlib -sv C:/Users/husseinz/Desktop/ece_212/HW4/HW4.srcs/sources_1/new/MACC.sv
foreach dcp [get_files -quiet -all *.dcp] {
  set_property used_in_implementation false $dcp
}

synth_design -top MACC -part xc7a100tcsg324-1


write_checkpoint -force -noxdef MACC.dcp

catch { report_utilization -file MACC_utilization_synth.rpt -pb MACC_utilization_synth.pb }

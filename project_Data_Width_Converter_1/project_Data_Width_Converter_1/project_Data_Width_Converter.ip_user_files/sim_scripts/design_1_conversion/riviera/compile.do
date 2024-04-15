vlib work
vlib riviera

vlib riviera/xil_defaultlib
vlib riviera/xpm
vlib riviera/xlconstant_v1_1_6

vmap xil_defaultlib riviera/xil_defaultlib
vmap xpm riviera/xpm
vmap xlconstant_v1_1_6 riviera/xlconstant_v1_1_6

vlog -work xil_defaultlib  -sv2k12 \
"G:/Xilinx/Vivado/2019.1/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"G:/Xilinx/Vivado/2019.1/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -93 \
"G:/Xilinx/Vivado/2019.1/data/ip/xpm/xpm_VCOMP.vhd" \

vcom -work xil_defaultlib -93 \
"../../../bd/design_1_conversion/ip/design_1_conversion_width_conv_AI_0_0/sim/design_1_conversion_width_conv_AI_0_0.vhd" \
"../../../bd/design_1_conversion/ip/design_1_conversion_fifo_generator_0_0/design_1_conversion_fifo_generator_0_0_sim_netlist.vhdl" \
"../../../bd/design_1_conversion/sim/design_1_conversion.vhd" \

vlog -work xlconstant_v1_1_6  -v2k5 \
"../../../../project_Data_Width_Converter.srcs/sources_1/bd/design_1_conversion/ipshared/66e7/hdl/xlconstant_v1_1_vl_rfs.v" \

vlog -work xil_defaultlib  -v2k5 \
"../../../bd/design_1_conversion/ip/design_1_conversion_xlconstant_1_0/sim/design_1_conversion_xlconstant_1_0.v" \

vlog -work xil_defaultlib \
"glbl.v"


-makelib xcelium_lib/xil_defaultlib -sv \
  "G:/Xilinx/Vivado/2019.1/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
  "G:/Xilinx/Vivado/2019.1/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib xcelium_lib/xpm \
  "G:/Xilinx/Vivado/2019.1/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/design_1_conversion/ip/design_1_conversion_width_conv_AI_0_0/sim/design_1_conversion_width_conv_AI_0_0.vhd" \
  "../../../bd/design_1_conversion/ip/design_1_conversion_fifo_generator_0_0/design_1_conversion_fifo_generator_0_0_sim_netlist.vhdl" \
  "../../../bd/design_1_conversion/sim/design_1_conversion.vhd" \
-endlib
-makelib xcelium_lib/xlconstant_v1_1_6 \
  "../../../../project_Data_Width_Converter.srcs/sources_1/bd/design_1_conversion/ipshared/66e7/hdl/xlconstant_v1_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/design_1_conversion/ip/design_1_conversion_xlconstant_1_0/sim/design_1_conversion_xlconstant_1_0.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  glbl.v
-endlib


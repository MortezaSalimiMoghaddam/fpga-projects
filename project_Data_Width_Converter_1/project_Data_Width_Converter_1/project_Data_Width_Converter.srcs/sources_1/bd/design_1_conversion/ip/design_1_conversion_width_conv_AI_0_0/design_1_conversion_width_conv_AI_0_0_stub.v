// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
// Date        : Wed Aug 23 22:36:24 2023
// Host        : DESKTOP-1JLH29I running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               e:/project_Data_Width_Converter/project_Data_Width_Converter.srcs/sources_1/bd/design_1_conversion/ip/design_1_conversion_width_conv_AI_0_0/design_1_conversion_width_conv_AI_0_0_stub.v
// Design      : design_1_conversion_width_conv_AI_0_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "width_conv_AI,Vivado 2019.1" *)
module design_1_conversion_width_conv_AI_0_0(in_data, in_dv, clk_in, resetn, out_dv, out_data)
/* synthesis syn_black_box black_box_pad_pin="in_data[19:0],in_dv,clk_in,resetn,out_dv,out_data[63:0]" */;
  input [19:0]in_data;
  input in_dv;
  input clk_in;
  input resetn;
  output out_dv;
  output [63:0]out_data;
endmodule

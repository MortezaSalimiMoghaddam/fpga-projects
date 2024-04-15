-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
-- Date        : Wed Aug 23 22:36:23 2023
-- Host        : DESKTOP-1JLH29I running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
--               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ design_1_conversion_width_conv_AI_0_0_stub.vhdl
-- Design      : design_1_conversion_width_conv_AI_0_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a35tcsg324-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix is
  Port ( 
    in_data : in STD_LOGIC_VECTOR ( 19 downto 0 );
    in_dv : in STD_LOGIC;
    clk_in : in STD_LOGIC;
    resetn : in STD_LOGIC;
    out_dv : out STD_LOGIC;
    out_data : out STD_LOGIC_VECTOR ( 63 downto 0 )
  );

end decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix;

architecture stub of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "in_data[19:0],in_dv,clk_in,resetn,out_dv,out_data[63:0]";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "width_conv_AI,Vivado 2019.1";
begin
end;

--Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
--Date        : Thu Aug 24 22:00:16 2023
--Host        : DESKTOP-1JLH29I running 64-bit major release  (build 9200)
--Command     : generate_target design_1_conversion_wrapper.bd
--Design      : design_1_conversion_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity design_1_conversion_wrapper is
  port (
    clk_in : in STD_LOGIC;
    clk_out : in STD_LOGIC;
    in_data : in STD_LOGIC_VECTOR ( 19 downto 0 );
    in_dv : in STD_LOGIC;
    out_data : out STD_LOGIC_VECTOR ( 63 downto 0 );
    out_dv : out STD_LOGIC;
    resetn : in STD_LOGIC
  );
end design_1_conversion_wrapper;

architecture STRUCTURE of design_1_conversion_wrapper is
  component design_1_conversion is
  port (
    in_data : in STD_LOGIC_VECTOR ( 19 downto 0 );
    in_dv : in STD_LOGIC;
    resetn : in STD_LOGIC;
    out_data : out STD_LOGIC_VECTOR ( 63 downto 0 );
    out_dv : out STD_LOGIC;
    clk_in : in STD_LOGIC;
    clk_out : in STD_LOGIC
  );
  end component design_1_conversion;
begin
design_1_conversion_i: component design_1_conversion
     port map (
      clk_in => clk_in,
      clk_out => clk_out,
      in_data(19 downto 0) => in_data(19 downto 0),
      in_dv => in_dv,
      out_data(63 downto 0) => out_data(63 downto 0),
      out_dv => out_dv,
      resetn => resetn
    );
end STRUCTURE;

--Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
--Date        : Thu Aug 24 01:28:50 2023
--Host        : DESKTOP-1JLH29I running 64-bit major release  (build 9200)
--Command     : generate_target design_1_conversion.bd
--Design      : design_1_conversion
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity design_1_conversion is
  port (
    clk_in : in STD_LOGIC;
    clk_out : in STD_LOGIC;
    in_data : in STD_LOGIC_VECTOR ( 19 downto 0 );
    in_dv : in STD_LOGIC;
    out_data : out STD_LOGIC_VECTOR ( 63 downto 0 );
    out_dv : out STD_LOGIC;
    resetn : in STD_LOGIC
  );
  attribute CORE_GENERATION_INFO : string;
  attribute CORE_GENERATION_INFO of design_1_conversion : entity is "design_1_conversion,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=design_1_conversion,x_ipVersion=1.00.a,x_ipLanguage=VHDL,numBlks=3,numReposBlks=3,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=1,numPkgbdBlks=0,bdsource=USER,synth_mode=OOC_per_IP}";
  attribute HW_HANDOFF : string;
  attribute HW_HANDOFF of design_1_conversion : entity is "design_1_conversion.hwdef";
end design_1_conversion;

architecture STRUCTURE of design_1_conversion is
  component design_1_conversion_fifo_generator_0_0 is
  port (
    rst : in STD_LOGIC;
    wr_clk : in STD_LOGIC;
    rd_clk : in STD_LOGIC;
    din : in STD_LOGIC_VECTOR ( 63 downto 0 );
    wr_en : in STD_LOGIC;
    rd_en : in STD_LOGIC;
    dout : out STD_LOGIC_VECTOR ( 63 downto 0 );
    full : out STD_LOGIC;
    empty : out STD_LOGIC;
    valid : out STD_LOGIC;
    wr_rst_busy : out STD_LOGIC;
    rd_rst_busy : out STD_LOGIC
  );
  end component design_1_conversion_fifo_generator_0_0;
  component design_1_conversion_width_conv_AI_0_0 is
  port (
    in_data : in STD_LOGIC_VECTOR ( 19 downto 0 );
    in_dv : in STD_LOGIC;
    clk_in : in STD_LOGIC;
    resetn : in STD_LOGIC;
    out_dv : out STD_LOGIC;
    out_data : out STD_LOGIC_VECTOR ( 63 downto 0 )
  );
  end component design_1_conversion_width_conv_AI_0_0;
  component design_1_conversion_xlconstant_1_0 is
  port (
    dout : out STD_LOGIC_VECTOR ( 0 to 0 )
  );
  end component design_1_conversion_xlconstant_1_0;
  signal clk_in_1 : STD_LOGIC;
  signal clk_out_1 : STD_LOGIC;
  signal fifo_generator_0_dout : STD_LOGIC_VECTOR ( 63 downto 0 );
  signal fifo_generator_0_valid : STD_LOGIC;
  signal in_data_1 : STD_LOGIC_VECTOR ( 19 downto 0 );
  signal in_dv_1 : STD_LOGIC;
  signal resetn_1 : STD_LOGIC;
  signal width_conv_AI_0_out_data : STD_LOGIC_VECTOR ( 63 downto 0 );
  signal width_conv_AI_0_out_dv : STD_LOGIC;
  signal xlconstant_1_dout : STD_LOGIC_VECTOR ( 0 to 0 );
  signal NLW_fifo_generator_0_empty_UNCONNECTED : STD_LOGIC;
  signal NLW_fifo_generator_0_full_UNCONNECTED : STD_LOGIC;
  signal NLW_fifo_generator_0_rd_rst_busy_UNCONNECTED : STD_LOGIC;
  signal NLW_fifo_generator_0_wr_rst_busy_UNCONNECTED : STD_LOGIC;
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of in_dv : signal is "xilinx.com:signal:data:1.0 DATA.IN_DV DATA";
  attribute X_INTERFACE_PARAMETER : string;
  attribute X_INTERFACE_PARAMETER of in_dv : signal is "XIL_INTERFACENAME DATA.IN_DV, LAYERED_METADATA undef";
  attribute X_INTERFACE_INFO of out_dv : signal is "xilinx.com:signal:data:1.0 DATA.OUT_DV DATA";
  attribute X_INTERFACE_PARAMETER of out_dv : signal is "XIL_INTERFACENAME DATA.OUT_DV, LAYERED_METADATA undef";
  attribute X_INTERFACE_INFO of resetn : signal is "xilinx.com:signal:reset:1.0 RST.RESETN RST";
  attribute X_INTERFACE_PARAMETER of resetn : signal is "XIL_INTERFACENAME RST.RESETN, INSERT_VIP 0, POLARITY ACTIVE_LOW";
  attribute X_INTERFACE_INFO of in_data : signal is "xilinx.com:signal:data:1.0 DATA.IN_DATA DATA";
  attribute X_INTERFACE_PARAMETER of in_data : signal is "XIL_INTERFACENAME DATA.IN_DATA, LAYERED_METADATA undef";
  attribute X_INTERFACE_INFO of out_data : signal is "xilinx.com:signal:data:1.0 DATA.OUT_DATA DATA";
  attribute X_INTERFACE_PARAMETER of out_data : signal is "XIL_INTERFACENAME DATA.OUT_DATA, LAYERED_METADATA undef";
begin
  clk_in_1 <= clk_in;
  clk_out_1 <= clk_out;
  in_data_1(19 downto 0) <= in_data(19 downto 0);
  in_dv_1 <= in_dv;
  out_data(63 downto 0) <= fifo_generator_0_dout(63 downto 0);
  out_dv <= fifo_generator_0_valid;
  resetn_1 <= resetn;
fifo_generator_0: component design_1_conversion_fifo_generator_0_0
     port map (
      din(63 downto 0) => width_conv_AI_0_out_data(63 downto 0),
      dout(63 downto 0) => fifo_generator_0_dout(63 downto 0),
      empty => NLW_fifo_generator_0_empty_UNCONNECTED,
      full => NLW_fifo_generator_0_full_UNCONNECTED,
      rd_clk => clk_out_1,
      rd_en => width_conv_AI_0_out_dv,
      rd_rst_busy => NLW_fifo_generator_0_rd_rst_busy_UNCONNECTED,
      rst => xlconstant_1_dout(0),
      valid => fifo_generator_0_valid,
      wr_clk => clk_in_1,
      wr_en => width_conv_AI_0_out_dv,
      wr_rst_busy => NLW_fifo_generator_0_wr_rst_busy_UNCONNECTED
    );
width_conv_AI_0: component design_1_conversion_width_conv_AI_0_0
     port map (
      clk_in => clk_in_1,
      in_data(19 downto 0) => in_data_1(19 downto 0),
      in_dv => in_dv_1,
      out_data(63 downto 0) => width_conv_AI_0_out_data(63 downto 0),
      out_dv => width_conv_AI_0_out_dv,
      resetn => resetn_1
    );
xlconstant_1: component design_1_conversion_xlconstant_1_0
     port map (
      dout(0) => xlconstant_1_dout(0)
    );
end STRUCTURE;

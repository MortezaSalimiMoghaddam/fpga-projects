library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity BitSync_tb is
end;

architecture rtl of BitSync_tb is
  -- Clock period
  constant clk_period : time := 3.333 ns;
  -- Generics
  constant stages : natural := 2;
  -- Ports
  signal bit_in  : std_logic;
  signal clk     : std_logic;
  signal reset   : std_logic;
  signal bit_out : std_logic;
begin

  BitSync_inst : entity work.BitSync
    generic
    map (
    stages => stages
    )
    port map
    (
      bit_in  => bit_in,
      clk     => clk,
      reset   => reset,
      bit_out => bit_out
    );

  process
  begin
    clk <= '1';
    wait for clk_period/2;
    clk <= '0';
    wait for clk_period/2;
  end process;

  process
  begin
  
    bit_in <= '0';
    reset  <= '0';
    wait for clk_period * 4;
    bit_in <= '1';
    reset  <= '0';
    wait for clk_period * 4;
    bit_in <= '0';
    reset  <= '0';
    wait for clk_period * 5;
    bit_in <= '1';
    reset  <= '0';
    wait;
    
  end process;
  
end;
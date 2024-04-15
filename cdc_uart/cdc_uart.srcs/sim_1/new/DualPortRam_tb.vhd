library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DualPortRam_tb is
end;

architecture rtl of DualPortRam_tb is

  --# Clock period
  constant clk_in_period  : time := 5 ns;
  constant clk_out_period : time := 3.333 ns;
  --# Generics
  constant MEM_SIZE : natural := 1024;
  --# Ports
  signal Wr_clock : std_logic := '0';
  signal We       : std_logic;
  signal Wr_addr  : natural range 0 to MEM_SIZE - 1;
  signal Wr_data  : std_logic_vector(7 downto 0);
  signal Rd_clock : std_logic := '0';
  signal Re       : std_logic;
  signal Rd_addr  : natural range 0 to MEM_SIZE - 1;
  signal Rd_data  : std_logic_vector(7 downto 0);
  signal Rd_valid : std_logic;
begin

  DualPortRam_inst : entity work.DualPortRam
    generic
    map (
    MEM_SIZE => MEM_SIZE
    )
    port map
    (
      Wr_clock => Wr_clock,
      We       => We,
      Wr_addr  => Wr_addr,
      Wr_data  => Wr_data,
      Rd_clock => Rd_clock,
      Re       => Re,
      Rd_addr  => Rd_addr,
      Rd_data  => Rd_data,
      Rd_valid => Rd_valid
    );

  process
  begin
    Wr_clock <= not Wr_clock;
    wait for clk_in_period/2;
  end process;

  process
  begin
    Rd_clock <= not Rd_clock;
    wait for clk_out_period/2;
  end process;

  process
  begin
  
    We <= '0';
    Wr_addr <= 0;
    Wr_data <= "11100010";
    wait for clk_in_period*5;
    We <= '1';
    Wr_addr <= 0;
    Wr_data <= "11110000";
    wait for clk_in_period;
    We <= '1';
    Wr_addr <= 1;
    Wr_data <= "11111110";
    wait for clk_in_period;
    We <= '1';
    Wr_addr <= 2;
    Wr_data <= "10000000";
    wait for clk_in_period;
    We <= '1';
    Wr_addr <= 3;
    Wr_data <= "00001111";
    wait for clk_in_period;
    We <= '0';
    Wr_addr <= 4;
    Wr_data <= "11100010";
    wait for clk_in_period;
    We <= '1';
    Wr_addr <= 4;
    Wr_data <= "11111010";
    wait for clk_in_period;
    We <= '1';
    Wr_addr <= 5;
    Wr_data <= "00000110";
    wait for clk_in_period;
    We <= '1';
    Wr_addr <= 6;
    Wr_data <= "00100010";
    wait for clk_in_period;
    We <= '1';
    Wr_addr <= 7;
    Wr_data <= "11100000";
    wait;
     
  end process;

  process
  begin
  
    Re <= '0';
    Rd_addr <= 0;
    wait for clk_out_period * 10;
    Re <= '1';
    Rd_addr <= 0;
    wait for clk_out_period;
    Re <= '1';
    Rd_addr <= 1;
    wait for clk_out_period;
    Re <= '1';
    Rd_addr <= 2;
    wait for clk_out_period;
    Re <= '0';
    Rd_addr <= 3;
    wait for clk_out_period;
    Re <= '1';
    Rd_addr <= 3;
    wait for clk_out_period;
    Re <= '1';
    Rd_addr <= 4;
    wait;

  end process;

  end;
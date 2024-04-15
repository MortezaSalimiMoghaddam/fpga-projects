library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fifo_tb is
end;

architecture rtl of fifo_tb is
  -- Clock period
  constant clk_in_period : time := 5 ns;
  constant clk_out_period : time := 3.333 ns;
  -- Generics
  constant MEM_SIZE : natural := 1024;
  constant ADDR_SIZE : natural := 10;
  -- Ports
  signal Wr_clock : std_logic;
  signal Wr_reset : std_logic;
  signal We : std_logic;
  signal Wr_data : std_logic_vector(7 downto 0);
  signal Rd_clock : std_logic;
  signal Rd_reset : std_logic;
  signal Re : std_logic;
  signal Rd_data : std_logic_vector(7 downto 0);
  signal Rd_valid : std_logic;
  signal Empty : std_logic;
  signal Full : std_logic;
begin

  fifo_inst : entity work.Fifo
  generic map (
    MEM_SIZE => MEM_SIZE,
    ADDR_SIZE => ADDR_SIZE
  )
  port map (
    Wr_clock => Wr_clock,
    Wr_reset => Wr_reset,
    We => We,
    Wr_data => Wr_data,
    Rd_clock => Rd_clock,
    Rd_reset => Rd_reset,
    Re => Re,
    Rd_data => Rd_data,
    Rd_valid => Rd_valid,
    Empty => Empty,
    Full => Full
  );
  
  process
  begin
    Wr_clock <= '1';
    wait for clk_in_period/2;
    Wr_clock <= '0';
    wait for clk_in_period/2;  
  end process;

  process
  begin
    Rd_clock <= '1';
    wait for clk_out_period/2;
    Rd_clock <= '0';
    wait for clk_out_period/2;  
  end process;
  
  process
  begin
    wait for clk_in_period*2;
    Wr_data <= x"5c";
    we      <= '0';
    wait for clk_in_period*4;
    Wr_data <= x"5c";
    We      <= '1';
    wait for clk_in_period*5;
    Wr_data <= x"8a";
    We      <= '1';
    wait for clk_in_period*5;
    Wr_data <= x"26";
    We      <= '1';
    wait for clk_in_period*5;
    Wr_data <= x"26";
    We      <= '0';
    wait for clk_in_period;
    Wr_data <= x"f2";
    We      <= '0';
    wait for clk_in_period*4;
    Wr_data <= x"58";
    wait for clk_in_period;
    Wr_data <= x"58";
    We      <= '1';
    wait for clk_in_period*5;
    Wr_data <= x"dc";
    We      <= '1';
  end process;
  
  process
  begin
    Re      <= '0';
    wait for clk_out_period*40;
    Re      <= '1';
    wait for clk_out_period;
    Re      <= '0';
    wait for clk_out_period*10;
    Re      <= '1';
    wait for clk_out_period;
    Re      <= '0';
    wait for clk_out_period*10;
    Re      <= '1';
    wait for clk_out_period;
  end process;
  
  process
  begin
    Rd_reset <= '1';
    wait for clk_out_period*20;
    Rd_reset <= '0';
    wait;
  end process;
  
  process
  begin
    Wr_reset <= '1';
    wait for clk_in_period*5;
    Wr_reset <= '0';
    wait;
  end process;
end;

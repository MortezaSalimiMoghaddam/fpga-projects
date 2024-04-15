library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TX_tb is
end;

architecture rtl of TX_tb is
  -- Clock period
  constant clk_period : time := 10 ns;
  -- Generics
  constant Parity : string := "Even";
  constant StopBits : integer := 1;
  constant ClockFreq : integer := 100_000_000;
  constant BaudRate : integer := 19200;
  -- Ports
  signal Clk : std_logic;
  signal Rst : std_logic;
  signal Byte : std_logic_vector(7 downto 0);
  signal Valid : std_logic;
  signal TX : std_logic;
  signal Done : std_logic;
begin

  TX_inst : entity work.TX
  generic map (
    Parity => Parity,
    StopBits => StopBits,
    ClockFreq => ClockFreq,
    BaudRate => BaudRate
  )
  port map (
    Clk => Clk,
    Rst => Rst,
    Byte => Byte,
    Valid => Valid,
    TX => TX,
    Done => Done
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
    valid <= '0';
    wait for clk_period*5;
    Byte  <= x"c6";
    Valid <= '1';
    wait for clk_period;
    valid <= '0';
    wait for clk_period*63000;
    Byte  <= x"fc";
    Valid <= '1';
    wait for clk_period;
    valid <= '0';
    wait for clk_period*63000;
  end process;
  
  process
  begin
    Rst   <= '1';
    wait for clk_period*5;
    Rst   <= '0';
    wait;
  end process;
end;
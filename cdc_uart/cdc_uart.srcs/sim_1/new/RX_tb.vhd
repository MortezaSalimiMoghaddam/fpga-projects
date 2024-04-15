library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RX_tb is
end;

architecture rtl of RX_tb is
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
  signal RX : std_logic;
  signal Byte : std_logic_vector(7 downto 0);
  signal Valid : std_logic;
  signal Error : std_logic;
  -- Time constant
  constant ClksPerBit : integer := ClockFreq/BaudRate + 1;
  constant BitTime : time := Clk_period * ClksPerBit;
begin

  RX_inst : entity work.RX
  generic map (
    Parity => Parity,
    StopBits => StopBits,
    ClockFreq => ClockFreq,
    BaudRate => BaudRate
  )
  port map (
    Clk => Clk,
    Rst => Rst,
    RX => RX,
    Byte => Byte,
    Valid => Valid,
    Error => Error
  );
  process
  begin
    Clk <= '1';
    wait for clk_period/2;
    Clk <= '0';
    wait for clk_period/2;
  end process;

  process
  begin
    Rst <= '1';
    wait for clk_period * 2;
    Rst <= '0';
    wait;
  end process;
  
  -- Sending x"93"
  process 
  begin
    RX <= '1';
    wait for clk_period * 4;
    RX <= '0';
    wait for clk_period;
    wait for BitTime;
    RX <= '1';
    wait for BitTime * 2;
    RX <= '0';
    wait for BitTime * 2;
    RX <= '1';
    wait for BitTime;
    RX <= '0';
    wait for BitTime * 2;
    RX <= '1';
    wait for BitTime;
    RX <= '0';        -- Parity bit
    wait for BitTime;
    RX <= '1';        -- Stop bit    
    wait for BitTime;

  -- Sending x"a7" with wrong parity  
    wait for clk_period;
    RX <= '0';
    wait for clk_period;
    wait for BitTime;
    RX <= '1';
    wait for BitTime * 2;
    RX <= '1';
    wait for BitTime;
    RX <= '0';
    wait for BitTime * 2;
    RX <= '1';
    wait for BitTime;
    RX <= '0';
    wait for BitTime;
    RX <= '1';
    wait for BitTime;
    RX <= '0';        -- Parity bit
    wait for BitTime * 2/3;
    RX <= '1';        -- Back to Idle     
    wait for clk_period;
    
  -- Sending x"a7" with wrong framing on start bit 
    RX <= '0';
    wait for clk_period;   
 
    RX <= '1';
    wait for clk_period;
    wait for BitTime;

  -- Sending x"a7" with wrong framing on stop bit
    RX <= '0';
    wait for clk_period;
    wait for BitTime;
    RX <= '1';
    wait for BitTime * 2;
    RX <= '1';
    wait for BitTime;
    RX <= '0';
    wait for BitTime * 2;
    RX <= '1';
    wait for BitTime;
    RX <= '0';
    wait for BitTime;
    RX <= '1';
    wait for BitTime;
    RX <= '1';        -- Parity bit
    wait for BitTime;
    RX <= '0';        -- Wrong stop bit 
    wait for BitTime * 2/3;
    RX <= '1';        -- Back to Idle
    wait for clk_period;

  -- Sending x"a7"
    RX <= '0';
    wait for clk_period;
    wait for BitTime;
    RX <= '1';
    wait for BitTime * 2;
    RX <= '1';
    wait for BitTime;
    RX <= '0';
    wait for BitTime * 2;
    RX <= '1';
    wait for BitTime;
    RX <= '0';
    wait for BitTime;
    RX <= '1';
    wait for BitTime;
    RX <= '1';        -- Parity bit
    wait for BitTime;
    RX <= '1';        -- Stop bit 
    wait for BitTime;
  end process;
end;

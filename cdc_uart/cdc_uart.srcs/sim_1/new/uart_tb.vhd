library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart_tb is
end;

architecture rtl of uart_tb is
  -- Clock period
  constant ClkPeriod : time := 10 ns;
  constant UserClkPeriod : time := 5 ns;
  -- Generics
  constant Parity : string := "Even";
  constant StopBits : integer := 1;
  constant FifoLength : integer := 1024;
  constant FifoAddress : integer := 10;
  constant ClockFreq : integer := 100_000_000;
  constant BaudRate : integer := 19200;
  -- Ports
  signal Clk : STD_LOGIC;
  signal Rst : STD_LOGIC;
  signal RX : STD_LOGIC;
  signal TX : STD_LOGIC;
  signal UserClk : STD_LOGIC;
  signal UserRst : STD_LOGIC;
  signal InputData : STD_LOGIC_VECTOR (7 downto 0);
  signal InputValid : STD_LOGIC;
  signal FifoFull : STD_LOGIC;
  signal OutputData : STD_LOGIC_VECTOR (7 downto 0);
  signal OutputValid : STD_LOGIC;
  signal Error : STD_LOGIC;
  -- Time constant
  constant ClksPerBit : integer := ClockFreq/BaudRate + 1;
  constant BitTime : time := ClkPeriod * ClksPerBit;
begin

  uart_inst : entity work.uart
  generic map (
    Parity => Parity,
    StopBits => StopBits,
    FifoLength => FifoLength,
    FifoAddress => FifoAddress,
    ClockFreq => ClockFreq,
    BaudRate => BaudRate
  )
  port map (
    Clk => Clk,
    Rst => Rst,
    RX => RX,
    TX => TX,
    UserClk => UserClk,
    UserRst => UserRst,
    InputData => InputData,
    InputValid => InputValid,
    FifoFull => FifoFull,
    OutputData => OutputData,
    OutputValid => OutputValid,
    Error => Error
  );
  
  process
  begin
    Clk <= '1';
    wait for ClkPeriod/2;
    Clk <= '0';
    wait for ClkPeriod/2;
  end process;
  
  process
  begin
    UserClk <= '1';
    wait for UserClkPeriod/2;
    UserClk <= '0';
    wait for UserClkPeriod/2;
  end process;
  
  process
  begin
    Rst <= '1';
    wait for ClkPeriod * 2;
    Rst <= '0';
    wait;
  end process;
  
  process
  begin
    UserRst <= '1';
    wait for UserClkPeriod;
    UserRst <= '0';
    wait;
  end process;
  
  process
  begin
    -- Sending x"93"
    RX <= '1';
    wait for ClkPeriod * 4;
    RX <= '0';
    wait for ClkPeriod;
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
    wait for ClkPeriod;
    RX <= '0';
    wait for ClkPeriod;
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
    wait for ClkPeriod;
    
    -- Sending x"a7"
    RX <= '0';
    wait for ClkPeriod;
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
    
    -- Sending x"a4"
    RX <= '0';
    wait for ClkPeriod;
    wait for BitTime;
    RX <= '0';
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
  
  process
begin
  InputValid <= '0';
  wait for UserClkPeriod*2;
  InputData <= x"5c";
  InputValid      <= '1';
  wait for UserClkPeriod*4;
  InputData <= x"5c";
  InputValid      <= '1';
  wait for UserClkPeriod*5;
  InputData <= x"8a";
  InputValid      <= '1';
  wait for UserClkPeriod*5;
  InputData <= x"26";
  InputValid      <= '1';
  wait for UserClkPeriod*5;
  InputData <= x"26";
  InputValid      <= '0';
  wait for UserClkPeriod;
  InputData <= x"f2";
  InputValid      <= '0';
  wait for UserClkPeriod*4;
  InputData <= x"58";
  wait for UserClkPeriod;
  InputData <= x"58";
  InputValid      <= '1';
  wait for UserClkPeriod*5;
  InputData <= x"dc";
  InputValid      <= '1';
  wait for UserClkPeriod*5;
end process;
end;
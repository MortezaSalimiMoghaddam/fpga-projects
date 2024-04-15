library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity TX is
  generic
  (
    Parity    : string  := "Even";      --# The kind of parity we have in mind, supports "Even", "Odd" and "None"
    StopBits  : integer := 1;           --# Number of stop bits
    ClockFreq : integer := 100_000_000; --# Frequency of the Clock
    BaudRate  : integer := 19200        --# The baud rate associated with our UART transmitter
  );
  port
  (
    Clk   : in std_logic;                    --# Clock signal
    Rst   : in std_logic;                    --# Reset signal
    Byte  : in std_logic_vector(7 downto 0); --# The Character to be transmitted through
    Valid : in std_logic;                    --# Indicator of the time at which the input character should be sampled
    TX    : out std_logic;                   --# The wire through which frame bits are transmitted
    Done  : out std_logic                    --# Set high for one clock when in Idle state 
  );
end TX;

architecture rtl of TX is
  type States is (Idle, Start, Data, ParityGen, Stop);                      --# States associated with the transmission state machine
  signal NextState        : States ;                                        --# Next state indicator signal
  constant ClksPerBit     : integer := ClockFreq/BaudRate + 1;              --# Number of clocks it takes TX to transimt one single bit
  signal ClkCount         : natural := 0;                                   --# Clock counter
  signal BitIndex         : natural range 0 to 7 := 0;                      --# Indicates which bit has been sent
  signal StopFreq         : natural := 1;                                   --# Helps with sending stop bit according to StopBits generic
  signal ParityReg        : std_logic;                                      --# Stores the parity bit
  signal TxByte           : std_logic_vector(7 downto 0):= (others => '1'); --# Registers the inputted byte
begin
  process (Clk)
  begin
    if rising_edge(clk) then
      if Rst = '1' then
        ClkCount   <= 0;
        BitIndex   <= 0;
        TxByte     <= (others => '1');
        StopFreq   <= 1;
        NextState  <= Idle;
        TX         <= '1';
        Done       <= '1';
      else
        case NextState is
          when Idle =>
            Done <= '0';
            TX <= '1';
            if Parity = "Odd" then
              ParityReg <= '1';
            else
              ParityReg <= '0';
            end if;
            if Valid = '1' then
              TxByte    <= Byte;
              NextState <= Start;
            end if;
          when Start =>
            TX <= '0';
            if ClkCount < ClksPerBit - 1 then

              ClkCount <= ClkCount + 1;
            else
              ClkCount  <= 0;
              NextState <= Data;
            end if;
          when Data =>
            TX <= TxByte(TxByte'low);
            if ClkCount < ClksPerBit - 1 then

              ClkCount <= ClkCount + 1;
            else
              ClkCount  <= 0;
              TxByte    <= '1' & TxByte(TxByte'high downto 1);
              ParityReg <= ParityReg xor TxByte(TxByte'low);
              if BitIndex < 7 then
                BitIndex <= BitIndex + 1;
              else
                BitIndex <= 0;
                if Parity /= "None" then
                  NextState <= ParityGen;
                else
                  NextState <= Stop;
                end if;
              end if;
            end if;
          when ParityGen =>
            TX <= ParityReg;
            if ClkCount < ClksPerBit - 1 then

              ClkCount <= ClkCount + 1;
            else
              ClkCount  <= 0;
              NextState <= Stop;
            end if;
          when Stop   => 
            TX <= '1';
            if ClkCount < ClksPerBit - 1 then

              ClkCount <= ClkCount + 1;
            else
              ClkCount  <= 0;
              if StopFreq < StopBits then
                StopFreq <= StopFreq + 1;
              else
                StopFreq  <= 1;
                NextState <= Idle;
                Done      <= '1';
              end if;
            end if;
        end case;
      end if;
    end if;
  end process;
end rtl;
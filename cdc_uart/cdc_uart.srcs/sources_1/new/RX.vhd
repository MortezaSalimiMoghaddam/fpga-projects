library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity RX is
  generic
  (
    Parity    : string  := "Even";      --# The kind of parity we have in mind, supports "Even", "Odd" and "None"
    StopBits  : integer := 1;           --# Number of stop bits
    ClockFreq : integer := 100_000_000; --# Frequency of the Clock
    BaudRate  : integer := 19200        --# The baud rate associated with our UART transmitter
  );
  port
  (
    Clk   : in std_logic;                     --# Clock signal
    Rst   : in std_logic;                     --# Reset signal
    RX    : in std_logic;                     --# Bit entry to RX
    Byte  : out std_logic_vector(7 downto 0); --# Character outputted from the RX
    Valid : out std_logic;                    --# Indicates validity of the outputted character for one clock cycle
    Error : out std_logic                     --# Indicates framing and/or parity error for one clock cycle
  );
end RX;

architecture rtl of RX is
  type States is (Idle, Start, Data, ParityCheck, Stop);                  --# States associated with the transmission state machine
  signal NextState      : States               := Idle;                   --# Next state indicator signal
  constant ClksPerBit   : integer              := ClockFreq/BaudRate + 1; --# Number of clocks it takes TX to transimt one single bit 
  signal ClkCount       : natural              := 0;                      --# Clock counter
  signal BitIndex       : natural range 0 to 7 := 0;                      --# Indicates which bit has been sent 
  signal StopFreq       : natural              := 1;                      --# Helps with sending stop bit according to StopBits generic
  signal RxSync         : std_logic;                                      --# Synchronized input (double flopped)
  signal ParityReg      : std_logic;                                      --# Stores the parity bit
  signal ErrorFlag      : std_logic;                                      --# Set high after error occures for as long as needed
  signal ByteReg        : std_logic_vector(7 downto 0);                   --# Registers the byte to be outputted
begin 
Rx_Sync: entity work.BitSync
    generic
    map (
    STAGES => 2
    )
    port
    map (
    clk   => Clk,
    reset => Rst,

    bit_in  => RX,
    bit_out => RxSync
    );

  process (clk)
  begin
    if rising_edge(clk) then
      if Rst = '1' then
        Byte      <= (others => '0');
        ByteReg   <= (others => '0');
        Valid     <= '0';
        Error     <= '0';
        ErrorFlag <= '0';
        BitIndex  <= 0;
        StopFreq  <= 1;
        NextState <= Idle;
      else
        case NextState is
          when Idle =>
            ClkCount  <= 0;
            Error     <= '0';
            ErrorFlag <= '0';
            Valid     <= '0';
            ParityReg <= '0';
            ByteReg   <= (others => '0');
            if RxSync = '0' then
              NextState <= Start;
            end if;

          when Start =>
            if ClkCount = (ClksPerBit - 1)/2 then
              if RxSync = '0' then
                ClkCount  <= 0;
                NextState <= Data;
              else
                Error     <= '1';
                ClkCount  <= 0;
                NextState <= Idle;
              end if;
            else
              ClkCount <= ClkCount + 1;
            end if;

          when Data =>
            if ClkCount < ClksPerBit - 1 then
              ClkCount <= ClkCount + 1;
            else
              ClkCount  <= 0;
              ByteReg   <= RxSync & ByteReg(ByteReg'high downto 1);
              ParityReg <= ParityReg xor RxSync; 
              if BitIndex < 7 then
                BitIndex <= BitIndex + 1;
              else
                BitIndex <= 0;
                if Parity /= "None" then
                  NextState <= ParityCheck;
                else
                  NextState <= Stop;  
                end if; 
              end if;
            end if;
          when ParityCheck =>
            if ClkCount < ClksPerBit - 1 then
                ClkCount <= ClkCount + 1;
            else
                ClkCount    <= 0;
                ParityReg <= ParityReg xor RxSync;
                NextState <= Stop;
            end if;
          when Stop =>
            Error <= '0';
            Byte  <= ByteReg;
            if ((ParityReg = '1' and Parity = "Even") or (ParityReg = '0' and Parity = "Odd")) and ErrorFlag /= '1' then
              Error  <= '1';
              ErrorFlag <= '1';
            end if;
            if RxSync = '1' and ErrorFlag = '1' then
              NextState <= Idle;
            end if;
            if ClkCount < ClksPerBit - 1 then
              ClkCount <= ClkCount + 1;
            else
              ClkCount  <= 0;
              if RxSync = '1' then
                if StopFreq < StopBits then
                  StopFreq <= StopFreq + 1;
                else
                  StopFreq  <= 1;
                  Valid     <= '1';
                  NextState <= Idle;
                end if;
              else
                Error     <= '1';
                ErrorFlag <= '1';
              end if;
            end if;
        end case;
      end if;
    end if;
  end process;
end rtl;
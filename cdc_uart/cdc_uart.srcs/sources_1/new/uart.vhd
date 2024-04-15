library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity uart is
  generic
  (
    Parity      : string  := "Even";
    StopBits    : integer := 1;
    FifoLength  : integer := 1024;
    FifoAddress : integer := 10;          -- FifoLength = 2**(FifoAddress)
    ClockFreq   : integer := 100_000_000;
    BaudRate    : integer := 19200
  );
  Port 
  (
    -- Clk Domain Signals 
    Clk         : in STD_LOGIC;
    Rst         : in STD_LOGIC;
    
    RX          : in STD_LOGIC;
    TX          : out STD_LOGIC;
    
    -- UserClk Domain Signals
    UserClk     : in STD_LOGIC;
    UserRst     : in STD_LOGIC;
    
    InputData   : in STD_LOGIC_VECTOR (7 downto 0);
    InputValid  : in STD_LOGIC;
    FifoFull    : out STD_LOGIC;
    OutputData  : out STD_LOGIC_VECTOR (7 downto 0);
    OutputValid : out STD_LOGIC;
    Error       : out STD_LOGIC
  );
end uart;

architecture rtl of uart is
signal Char         : std_logic_vector(InputData'high downto 0);
signal Received     : std_logic_vector(OutputData'high downto 0);
signal OutputReg    : std_logic_vector(OutputData'high downto 0);
signal ValidReg     : std_logic;
signal RValid       : std_logic;
signal ToSend       : std_logic;
signal Sending      : std_logic;
signal ErrorReg     : std_logic;
signal ErrorX       : std_logic;
signal ErrorY       : std_logic;
signal OutputValidX : std_logic;
signal OutputValidY : std_logic;

begin

---------------------
-- Fifo Instantiation
---------------------
  fifo : entity work.Fifo
  generic map (
    MEM_SIZE  => FifoLength,
    ADDR_SIZE => FifoAddress
  )
  port map (
    Wr_clock => UserClk,
    Wr_reset => UserRst,
    We       => InputValid,
    Wr_data  => InputData,
    Rd_clock => Clk,
    Rd_reset => Rst,
    Re       => ToSend,
    Rd_data  => Char,
    Rd_valid => Sending,
    Empty    => open,
    Full     => FifoFull
  );

-------------------
-- TX Instantiation
-------------------
  TX_inst : entity work.TX
  generic map (
    Parity => Parity,
    StopBits => StopBits,
    ClockFreq => ClockFreq,
    BaudRate => BaudRate
  )
  port map (
    Clk   => Clk,
    Rst   => Rst,
    Byte  => Char,
    Valid => Sending,
    TX    => TX,
    Done  => ToSend
  );

-------------------
-- RX Instantiation
-------------------
  RX_inst : entity work.RX
  generic map (
    Parity => Parity,
    StopBits => StopBits,
    ClockFreq => ClockFreq,
    BaudRate => BaudRate
  )
  port map (
    Clk   => Clk,
    Rst   => Rst,
    RX    => RX,
    Byte  => Received,
    Valid => RValid,
    Error => ErrorReg
  );
  
----------------------------------
-- Bit synchronizer instantiations
----------------------------------
  BitSync_inst : entity work.BitSync
    generic
    map (
    stages => 2
    )
    port map
    (
      bit_in  => RValid,
      clk     => UserClk,
      reset   => UserRst,
      bit_out => OutputValidX
    );
  BitSync_inst_2 : entity work.BitSync
    generic
    map (
    stages => 2
    )
    port map
    (
      bit_in  => ErrorReg,
      clk     => UserClk,
      reset   => UserRst,
      bit_out => ErrorX
    );
    
    process(UserClk)
    begin
      if rising_edge(UserClk) then
        OutputReg  <= received;
        outputData <= OutputReg;
      end if;
    end process;
    
    process(UserClk)
    begin
      if rising_edge(UserClk) then
        Error        <= '0';
        OutputValid  <= '0';
        ErrorY       <= ErrorX;
        OutputValidY <= OutputValidX;
        
        if ErrorY = '0' and ErrorX = '1' then
          Error <= '1';
        end if;

        if OutputValidY = '0' and OutputValidX = '1' then
          OutputValid <= '1';
        end if;        
 
      end if;
    end process;
end rtl;
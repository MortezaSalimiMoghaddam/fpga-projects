library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity HandshakeSync_tb is
end;

architecture rtl of HandshakeSync_tb is
  -- Clock period
  constant clk_tx_period : time := 5 ns;
  constant clk_rx_period : time := 3.333 ns;
  -- Generics
  constant STAGES : natural := 2;
  constant ADDR_SIZE : natural := 10;
  -- Ports
  signal Clock_tx : std_logic;
  signal Reset_tx : std_logic;
  signal Clock_rx : std_logic;
  signal Reset_rx : std_logic;
  signal Tx_data : std_logic_vector(ADDR_SIZE - 1 downto 0);
  signal Send_data : std_logic;
  signal Sending : std_logic;
  signal Data_sent : std_logic;
  signal Rx_data : std_logic_vector(ADDR_SIZE - 1 downto 0);
  signal New_data : std_logic;
begin

  HandshakeSync_inst : entity work.HandshakeSync
  generic map (
    STAGES => STAGES,
    ADDR_SIZE => ADDR_SIZE
  )
  port map (
    Clock_tx => Clock_tx,
    Reset_tx => Reset_tx,
    Clock_rx => Clock_rx,
    Reset_rx => Reset_rx,
    Tx_data => Tx_data,
    Send_data => Send_data,
    Sending => Sending,
    Data_sent => Data_sent,
    Rx_data => Rx_data,
    New_data => New_data
  );
  
  process
  begin
    Clock_tx <= '1';
    wait for clk_tx_period/2;
    Clock_tx <= '0';
    wait for clk_tx_period/2;
  end process;
  
  process
  begin
    Clock_rx <= '1';
    wait for clk_rx_period/2;
    Clock_rx <= '0';
    wait for clk_rx_period/2;
  end process;
  
  process
  begin
    reset_rx <= '0';
    reset_tx <= '0';
    Tx_data  <= "0100011001";
    Send_data <= '0';
    wait for clk_tx_period*10;
    Tx_data  <= "0100011001";
    Send_data <= '1';
    wait for clk_tx_period*10;
    Tx_data  <= "1101011001";
    Send_data <= '1';
    wait;
  end process;
end;
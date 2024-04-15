library IEEE;
use IEEE.STD_LOGIC_1164.all;

--# Four phase handshake protocol

entity HandshakeSync is
  generic
  (
    STAGES    : natural := 2; --# Number of flip-flops in the synchronizer
    ADDR_SIZE : natural := 10 --# Number of bits for the vector to cross clock domains
  );
  port
  (
    -- {{clocks}}
    Clock_tx : in std_logic; --# Transmitting domain clock
    Reset_tx : in std_logic; --# Reset for Clock_tx

    Clock_rx : in std_logic; --# Receiving domain clock
    Reset_rx : in std_logic; --# Reset for Clock_rx
    -- {{data|Send port}}
    Tx_data   : in std_logic_vector(ADDR_SIZE - 1 downto 0); --# Data to send
    Send_data : in std_logic;                                --# Control signal to send new data
    Sending   : out std_logic;                               --# Active while TX is in process
    Data_sent : out std_logic;                               --# Flag to indicate TX completion

    -- {{Receive port}}
    Rx_data  : out std_logic_vector(ADDR_SIZE - 1 downto 0); --# Data received in clock_rx domain
    New_data : out std_logic                                 --# Flag to indicate new data
  );

end HandshakeSync;
architecture rtl of HandshakeSync is
  signal ack_rx, ack_tx : std_logic;                             --# Rx acknowledge signal in rx and tx
  signal prev_ack       : std_logic;                             --# Helps in detecting the falling edge of ack signal in tx

  signal tx_reg_en   : std_logic;                                --# These two signals help register the input for rx domain to capture
  signal tx_data_reg : std_logic_vector(ADDR_SIZE - 1 downto 0);  

  signal req_tx, req_rx : std_logic;                             --# Tx request signal in rx and tx
  signal prev_req       : std_logic;                             --# Helps in detecting the rising edge of req signal in rx

  type states is (IDLE, SEND, FINISH);                           --# State machine that helps in keeping track of write side OPs
  signal cur_state : states;

begin
  -----------
  -- Tx logic
  -----------
  ts : entity work.BitSync
    generic
    map (
    STAGES => STAGES
    )
    port map
    (
      clk   => Clock_tx,
      reset => Reset_tx,

      bit_in  => ack_rx,
      bit_out => ack_tx
    );

  process (Clock_tx)
  begin
    if rising_edge(Clock_tx) then
      if Reset_tx = '1' then
        prev_ack <= '0';
      else
        prev_ack <= ack_tx;
      end if;
    end if;
  end process;

  Data_sent <= '1' when ack_tx = '0' and prev_ack = '1' else
    '0';

  process (Clock_tx)
  begin
    if rising_edge(Clock_tx) then
      if Reset_tx = '1' then
        cur_state <= IDLE;
        tx_reg_en <= '0';
        req_tx    <= '0';
        Sending   <= '0';
      else
        tx_reg_en <= '0';
        Sending   <= '0';
        req_tx    <= '0';
        case cur_state is
          when IDLE =>
            if Send_data = '1' then
              cur_state <= SEND;
              tx_reg_en <= '1';
              req_tx    <= '1';
              Sending   <= '1';
            end if;

          when SEND => -- Wait for Rx side to assert ack
            req_tx  <= '1';
            Sending <= '1';
            if ack_tx = '1' then
              cur_state <= FINISH;
              req_tx    <= '0';
            end if;

          when FINISH => -- Wait for Rx side to deassert ack
            Sending <= '1';
            if ack_tx = '0' then
              cur_state <= IDLE;
              sending   <= '0';
            end if;

          when others =>
            cur_state <= IDLE;
        end case;
      end if;
    end if;
  end process;

  process (Clock_tx)
  begin
    if rising_edge(Clock_tx) then
      if Reset_tx = '1' then
        tx_data_reg <= (others => '0');
      else
        if tx_reg_en = '1' then
          tx_data_reg <= Tx_data;
        end if;
      end if;
    end if;
  end process;

  -----------
  -- Rx logic
  -----------
  rs   : entity work.BitSync
    generic
    map (
    STAGES => STAGES
    )
    port
    map (
    clk   => Clock_rx,
    reset => Reset_rx,

    bit_in  => req_tx,
    bit_out => req_rx
    );
    
  rs_2 : entity work.BitSync
    generic
    map (
    STAGES => STAGES
    )
    port
    map (
    clk   => Clock_rx,
    reset => Reset_rx,

    bit_in  => req_tx,
    bit_out => ack_rx
    );
  

  process (Clock_rx)
  begin
    if rising_edge(Clock_rx) then
      if reset_rx = '1' then
        prev_req <= '0';
        Rx_data  <= (others => '0');
        New_data <= '0';
      else
        prev_req <= req_rx;
        New_data <= '0';
        if req_rx = '1' and prev_req = '0' then -- Capture data
          Rx_data  <= tx_data_reg;
          New_data <= '1';
        end if;
      end if;
    end if;
  end process;
end rtl;
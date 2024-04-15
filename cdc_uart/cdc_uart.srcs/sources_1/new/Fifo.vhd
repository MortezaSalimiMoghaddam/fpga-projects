library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Fifo is
  generic
  (
    MEM_SIZE  : natural := 1024;--# Size of FIFO
    ADDR_SIZE : natural := 10 --# Number of bits it takes to register pointers to FIFO   
  );
  port
  (
    Wr_clock : in std_logic; --# Write-side clock and reset
    Wr_reset : in std_logic;
    We       : in std_logic;                    --# Write enable 
    Wr_data  : in std_logic_vector(7 downto 0); --# Data to be written in FIFO

    Rd_clock : in std_logic; --# Read-side clock and reset
    Rd_reset : in std_logic;
    Re       : in std_logic;                     --# Read enable
    Rd_data  : out std_logic_vector(7 downto 0); --# Data read from FIFO
    Rd_valid : out std_logic;                    --# Valid flag of read data

    Empty : out std_logic; --# Flags indicating whether the FIFO is empty or full
    Full  : out std_logic
  );
end entity;

architecture rtl of Fifo is
  signal head, tail, head_rd, tail_wr, head_reg       : natural range 0 to MEM_SIZE - 1; --# Head and tail pointers in both clock domains
  signal dpr_we                                       : std_logic;                       --# Dual port RAM write enable
  signal wraparound_wr, wraparound_rd                 : boolean;                         --# Indicators of wrap-around in both clock domains
  signal wrap_set, wrap_clr, wrap_set_rd, wrap_clr_wr : std_logic;                       --# Wrap-around initiators in both clock domains

  signal empty_loc, full_loc : std_logic; --# Signals meant for registering the value of empty and full flags

  signal head_sulv, head_rd_sulv : std_logic_vector(ADDR_SIZE - 1 downto 0); --# Signals meant for required type changing of inputs and outputs of DPR
  signal tail_sulv, tail_wr_sulv : std_logic_vector(ADDR_SIZE - 1 downto 0);
begin

  ------------------------------
  -- Dual Port Ram instantiation
  ------------------------------
  dpr : entity work.DualPortRam
    generic
    map (
    MEM_SIZE => MEM_SIZE
    )
    port map
    (
      Wr_clock => Wr_clock,
      We       => dpr_we,
      Wr_addr  => head,
      Wr_data  => Wr_data,

      Rd_clock => Rd_clock,
      Re       => Re,
      Rd_addr  => tail,
      Rd_data  => Rd_data,
      Rd_valid => Rd_valid
    );

  ------------------------
  -- Write-side operations
  ------------------------
  process (Wr_clock)
  begin
    if rising_edge(Wr_clock) then
      if Wr_reset = '1' then
        head          <= 0;
        head_reg      <= 0;
        full_loc      <= '0';
        wraparound_wr <= false;
        wrap_set      <= '0';
      else
        head <= head_reg;
        wrap_set <= '0';

        if We = '1' and (wraparound_wr = false or head_reg /= tail_wr) then
          dpr_we <= '1';
          if head_reg = MEM_SIZE - 1 then
            head_reg      <= 0;
            wraparound_wr <= true;
            wrap_set      <= '1';
          else 
            head_reg <= head_reg + 1;
          end if;
        else
          dpr_we <= '0';
        end if;

        -- Update full flag
        if head_reg /= tail_wr then
          full_loc <= '0';
        else
          if wraparound_wr then
            full_loc <= '1';
          else
            full_loc <= '0';
          end if;
        end if;

        -- Wrap-around handling
        if wrap_clr_wr /= '0' then
          wraparound_wr <= false;
        end if;
      end if;
    end if;
  end process;

  -----------------------
  -- read-side operations
  -----------------------
  process (Rd_clock, Rd_reset)
  begin
    if rising_edge(Rd_clock) then
      if Rd_reset = '1' then
        tail      <= 0;
        empty_loc <= '1';

        wraparound_rd <= false;
        wrap_clr      <= '0';
      else
        wrap_clr <= '0';

        if Re = '1' and (wraparound_rd = true or head_rd /= tail) then
          if tail = MEM_SIZE - 1 then
            tail          <= 0;
            wraparound_rd <= false;
            wrap_clr      <= '1';
          else
            tail <= tail + 1;
          end if;
        end if;

        -- Update empty flag
        if head_rd /= tail then
          empty_loc <= '0';
        else
          if not wraparound_rd then
            empty_loc <= '1';
          else
            empty_loc <= '0';
          end if;
        end if;

        -- Wrap-around handling
        if wrap_set_rd /= '0' then
          wraparound_rd <= true;
        end if;

      end if;
    end if;
  end process;

  Empty <= empty_loc;
  Full  <= full_loc;

  ----------------------------------------------------
  -- Synchronize head and tail pointers across domains
  ----------------------------------------------------
  hs_head : entity work.HandshakeSync
    generic
    map (
    STAGES    => 2,
    ADDR_SIZE => ADDR_SIZE
    )
    port
    map (
    Clock_tx => Wr_clock,
    Reset_tx => Wr_reset,

    Clock_rx  => Rd_clock,
    Reset_rx  => Rd_reset,
    Tx_data   => head_sulv,
    Send_data => '1',
    Sending   => open,
    Data_sent => open,

    Rx_data  => head_rd_sulv,
    New_data => open
    );

  head_sulv <= std_logic_vector(to_unsigned(head, head_sulv'length));
  head_rd   <= to_integer(unsigned((head_rd_sulv)));

  hs_tail : entity work.HandshakeSync
    generic
    map (
    STAGES    => 2,
    ADDR_SIZE => ADDR_SIZE
    )
    port
    map (
    Clock_tx => Rd_clock,
    Reset_tx => Rd_reset,

    Clock_rx  => Wr_clock,
    Reset_rx  => Wr_reset,
    Tx_data   => tail_sulv,
    Send_data => '1',
    Sending   => open,
    Data_sent => open,

    Rx_data  => tail_wr_sulv,
    New_data => open
    );

  tail_sulv <= std_logic_vector(to_unsigned(tail, tail_sulv'length));
  tail_wr   <= to_integer(unsigned(tail_wr_sulv));

  ---------------------------------------
  -- Synchronize wraparound control flags
  ---------------------------------------
  wc_wr : entity work.BitSync
    generic
    map (
    STAGES => 2
    )
    port
    map (
    clk   => Wr_clock,
    reset => Wr_reset,

    bit_in  => wrap_clr,
    bit_out => wrap_clr_wr
    );

  ws_rd : entity work.BitSync
    generic
    map (
    STAGES => 2
    )
    port
    map (
    clk   => Rd_clock,
    reset => Rd_reset,

    bit_in  => wrap_set,
    bit_out => wrap_set_rd
    );
end architecture;
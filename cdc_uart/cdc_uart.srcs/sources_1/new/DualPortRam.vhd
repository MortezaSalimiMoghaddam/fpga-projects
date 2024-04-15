library IEEE;
use IEEE.STD_LOGIC_1164.all;

use IEEE.NUMERIC_STD.all;

entity DualPortRam is
  generic
  (
    MEM_SIZE : natural := 1024 --# Number of words in memory
  );
  port
  (
    --# {{data|Write port}}
    Wr_clock : in std_logic;                       --# Write port clock
    We       : in std_logic;                       --# Write enable
    Wr_addr  : in natural range 0 to MEM_SIZE - 1; --# Write port address
    Wr_data  : in std_logic_vector(7 downto 0);    --# Write port data

    --# {{Read port}}
    Rd_clock : in std_logic;                       --# Read port clock
    Re       : in std_logic;                       --# Read enable
    Rd_addr  : in natural range 0 to MEM_SIZE - 1; --# Read port address
    Rd_data  : out std_logic_vector(7 downto 0);   --# Read port data
    Rd_valid : out std_logic                       --# Read pord DV 
  );
end DualPortRam;

architecture rtl of DualPortRam is

  type ram_type is array (0 to MEM_SIZE - 1) of std_logic_vector(7 downto 0); --# Defining a type for RAM 
  signal ram        : ram_type;                                               --# RAM instance
  signal sync_rdata : std_logic_vector(7 downto 0);                           --# Output registered from RAM 

begin

  process (Wr_clock)
  begin
    if rising_edge(Wr_clock) then
      if We = '1' then
        ram(Wr_addr) <= Wr_data;
      end if;
    end if;
  end process;

  process (Rd_clock)
  begin
    if rising_edge(Rd_clock) then
      Rd_valid <= '0';
      if Re = '1' then
        sync_rdata <= ram(Rd_addr);
        Rd_valid   <= '1';
      end if;
    end if;
  end process;

  Rd_data <= sync_rdata; --# Registered signal is directly connected to the output

end rtl;
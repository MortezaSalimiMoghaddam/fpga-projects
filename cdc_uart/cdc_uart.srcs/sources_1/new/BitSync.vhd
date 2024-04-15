library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity BitSync is
  generic
  (
    stages : natural := 2 --# Number of FF stages for synchronization
  );
  port
  (
    bit_in  : in std_logic; --# Bit to be synchronized
    clk     : in std_logic; --# Clock to which the bit is supposed to be synchronized
    reset   : in std_logic; --# Resets the registers
    bit_out : out std_logic --# Synchronized output
  );

end BitSync;

architecture rtl of BitSync is

  signal sr : std_logic_vector(1 to stages); --# This vector helps with the storing of bit value for synchronization period

begin

  process (clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        sr <= (others => '0');
      else
        sr <= bit_in & sr(1 to stages - 1);
      end if;
    end if;
  end process;
  
  bit_out <= sr(sr'right); --# Output directly connected to the registered value of sync'ed bit

end rtl;
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/30/2023 05:17:19 PM
-- Design Name: 
-- Module Name: tb_synced - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_synced is
end tb_synced;

architecture Behavioral of tb_synced is

signal bcd_1: std_logic_vector(3 downto 0);
signal start, ready, reset : std_logic;
signal clock, pb, active: std_logic := '0';
signal binary : std_logic_vector(6 downto 0);

begin

    uut: entity work.synced_bcdToBinary(Behavioral_2)
    port map(
        bcd_1 => bcd_1,
        start => start,
        clk => clock,
        reset => reset,
--        done => done,
        ready => ready,
        binary => binary,
        active => active,
        pb => pb
    );
    
    process
    begin
        clock <= not(clock);
        wait for 50 ns;
    end process;
    
    process
    begin
    
        bcd_1 <= "0111";
        pb <= '0';
        active <= '0';
        start <= '0';
        reset <='1';
        wait for 100 ns;
        
        bcd_1 <= "0111";
        pb <= '0';
        active <= '0';
        start <= '1';
        reset <='0';
        wait for 100 ns;

       
        pb <= '1';
        active <= '0';
        start <= '1';
        reset <='0';
        wait for 100 ns;
        bcd_1 <= "1001";
        wait for 75 ns;
    
        bcd_1 <= "1001";
        pb <= '0';
        active <= '0';
        start <= '0';
        reset <='0';
        wait for 300 ns;
        active <= '1';
        wait for 500 ns;
        pb <= '0';
        active <= '0';
--        bcd_0 <= "0010";
--        bcd_1 <= "0101";
--        start <= '1';
--        reset <='0';
        
--        wait for 100 ns;
--        bcd_0 <= "0010";
--      bcd_1 <= "1101";
        start <= '0';
        reset <='0';
        
       
        wait; 
                                   
    end process;
    

end Behavioral;
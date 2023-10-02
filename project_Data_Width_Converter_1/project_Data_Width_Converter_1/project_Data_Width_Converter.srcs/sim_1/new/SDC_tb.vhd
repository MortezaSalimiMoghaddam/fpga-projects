----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/08/2023 11:28:22 AM
-- Design Name: 
-- Module Name: SDC_tb - Behavioral
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
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY SDC_tb IS
END SDC_tb;

ARCHITECTURE Behavioral OF SDC_tb IS

    SIGNAL in_data : STD_LOGIC_VECTOR(19 DOWNTO 0);
    SIGNAL in_dv, out_dv, reset : STD_LOGIC;
    SIGNAL out_data : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL clk : STD_LOGIC := '0';

BEGIN
    uut : ENTITY work.width_conv_AI(Behavioral)
        PORT MAP(
            in_data => in_data,
            in_dv => in_dv,
            clk => clk,
            resetn => reset,
            out_dv => out_dv,
            out_data => out_data
        );
    PROCESS
    BEGIN
        clk <= NOT(clk);
        WAIT FOR 50 ns;
    END PROCESS;

    PROCESS
    BEGIN

        in_data <= "10000001110110000000";
        in_dv <= '1';
        reset <= '0';
        WAIT FOR 25 ns;

        in_data <= "00100001110110000000";
        in_dv <= '1';
        reset <= '1';
        WAIT FOR 100 ns;

        in_data <= "10000001110110000011";
        in_dv <= '1';
        reset <= '1';
        WAIT FOR 100 ns;

        in_data <= "01000011110110001100";
        in_dv <= '1';
        reset <= '1';
        WAIT FOR 100 ns;

        in_data <= "00101001100010110110";
        in_dv <= '1';
        reset <= '1';
        WAIT FOR 100 ns;

        in_data <= "01111011010110011101";
        in_dv <= '1';
        reset <= '1';
        WAIT FOR 100 ns;

        in_data <= "01111011010110011101";
        in_dv <= '0';
        reset <= '1';
        WAIT FOR 100 ns;

        in_data <= "01100001101010001100";
        in_dv <= '1';
        reset <= '1';
        WAIT FOR 100 ns;

        in_data <= "10000101110011110011";
        in_dv <= '1';
        reset <= '1';
        WAIT FOR 100 ns;

        in_data <= "01100111100110000000";
        in_dv <= '1';
        reset <= '1';
        WAIT FOR 100 ns;

        in_data <= "00100001110110000000";
        in_dv <= '1';
        reset <= '1';
        WAIT FOR 100 ns;

        in_data <= "10000001110110100011";
        in_dv <= '1';
        reset <= '1';
        WAIT FOR 100 ns;

        in_data <= "01000011110110001100";
        in_dv <= '1';
        reset <= '1';
        WAIT FOR 100 ns;

        in_data <= "00101001100010110110";
        in_dv <= '1';
        reset <= '1';
        WAIT FOR 100 ns;

        in_data <= "01001011010110011101";
        in_dv <= '1';
        reset <= '1';
        WAIT FOR 100 ns;

        in_data <= "01011011010110011001";
        in_dv <= '1';
        reset <= '1';
        WAIT FOR 100 ns;

        in_data <= "01100001101010000100";
        in_dv <= '1';
        reset <= '0';
        WAIT FOR 100 ns;

        in_data <= "10000101110011110011";
        in_dv <= '1';
        reset <= '1';
        WAIT FOR 100 ns;

        in_data <= "01100111100110001010";
        in_dv <= '1';
        reset <= '1';
        WAIT FOR 100 ns;

        --            in_data <= "01000011110110001100";

        in_data <= "10000001110110000000";
        in_dv <= '1';
        reset <= '1';
        WAIT FOR 100 ns;

        in_data <= "00100001110110000000";
        in_dv <= '1';
        reset <= '1';
        WAIT FOR 100 ns;

        in_data <= "10000001110110000011";
        in_dv <= '1';
        reset <= '1';
        WAIT FOR 100 ns;

        in_data <= "01000011110110001100";
        in_dv <= '1';
        reset <= '1';
        WAIT FOR 100 ns;

        in_data <= "00101001100010110110";
        in_dv <= '1';
        reset <= '1';
        WAIT FOR 100 ns;

        in_data <= "01111011010110011101";
        in_dv <= '1';
        reset <= '1';
        WAIT FOR 100 ns;

        in_data <= "01111011010110011101";
        in_dv <= '1';
        reset <= '1';
        WAIT FOR 100 ns;

        in_data <= "01100001101010001100";
        in_dv <= '1';
        reset <= '1';
        WAIT FOR 100 ns;

        in_data <= "10000101110011110011";
        in_dv <= '1';
        reset <= '1';
        WAIT FOR 100 ns;

        in_data <= "01100111100110000000";
        in_dv <= '1';
        reset <= '1';
        WAIT FOR 100 ns;

        in_data <= "00100001110110000000";
        in_dv <= '1';
        reset <= '1';
        WAIT FOR 100 ns;

        in_data <= "10000001110110100011";
        in_dv <= '1';
        reset <= '1';
        WAIT FOR 100 ns;

        in_data <= "01000011110110001100";
        in_dv <= '1';
        reset <= '1';
        WAIT FOR 100 ns;

        in_data <= "00101001100010110110";
        in_dv <= '1';
        reset <= '1';
        WAIT FOR 100 ns;

        in_data <= "01001011010110011101";
        in_dv <= '1';
        reset <= '1';
        WAIT FOR 100 ns;

        in_data <= "01011011010110011001";
        in_dv <= '0';
        reset <= '1';
        WAIT FOR 100 ns;

        in_data <= "01100001101010000100";
        in_dv <= '1';
        reset <= '1';
        WAIT FOR 100 ns;

        in_data <= "10000101110011110011";
        in_dv <= '0';
        reset <= '1';
        WAIT FOR 100 ns;

        in_data <= "01100111100110001010";
        in_dv <= '1';
        reset <= '1';
        WAIT FOR 100 ns;

        in_data <= "10000101110011110011";
        in_dv <= '1';
        reset <= '1';
        WAIT FOR 100 ns;

        in_data <= "01111011010110011101";
        in_dv <= '0';
        reset <= '1';
        WAIT FOR 100 ns;

        in_data <= "01111011010110011101";
        in_dv <= '0';
        reset <= '1';
        WAIT FOR 100 ns;
        --            in_data <= "01000011110110001100";
        in_dv <= '0';
        --            reset <= '1';
        --            wait for 100 ns;  

        WAIT;
    END PROCESS;
END Behavioral;
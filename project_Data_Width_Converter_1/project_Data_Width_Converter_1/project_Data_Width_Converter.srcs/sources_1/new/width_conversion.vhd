----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/06/2023 06:53:21 PM
-- Design Name: 
-- Module Name: width_conversion - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity width_conversion is
    Port ( 
    in_data : in std_logic_vector(19 downto 0);
    in_dv : in std_logic;
    clk : in std_logic;
    resetn : in std_logic; 
    out_dv : out std_logic;
    out_data : out std_logic_vector(63 downto 0)
    );
end width_conversion;

architecture Behavioral of width_conversion is

constant in_width: natural:=20;
constant out_tmp_2_width: natural:= 31; 
signal in_tmp, in_tmp_2 : std_logic_vector(19 downto 0);
signal out_tmp : std_logic_vector(63 downto 0);
signal out_tmp_2 : std_logic_vector(out_tmp_2_width downto 0);
signal is_first : std_logic := '1';
type stage is (zero, first, second, third);
signal stage_next : stage;
signal stage_reg : stage := zero; 
signal remainder : integer;

begin
    process(clk)
    begin
        if (clk'event and clk = '1') then
            if resetn = '0' then
                in_tmp <= (others => '0');
                out_tmp <= (others => '0');
                out_data <=(others => '0');
                out_dv <= '0';
                remainder <= 19;
                stage_reg <= zero;
                stage_next <= first;
                is_first <= '1';
            end if;
            
--            FSM
            out_data <= out_tmp;
            if (in_tmp /= in_data and in_dv = '1') then
                stage_reg <= stage_next;
                in_tmp <= in_data;
            end if;
            in_tmp_2 <= in_tmp;
            
            case stage_reg is
            
                when  zero =>
                    out_dv <= '0';
                    stage_next <= first;
                    if remainder = in_width - 1 then
                        out_tmp(in_width - 1 downto 0) <= in_tmp;
                    elsif remainder = in_width - 5 then
                        out_tmp(in_width - 1 downto 0) <= in_tmp(3 downto 0)& out_tmp_2(in_width - 5 downto 0);
                    elsif remainder = in_width - 9 then
                        out_tmp(in_width - 1 downto 0) <= in_tmp(7 downto 0)& out_tmp_2(in_width - 9 downto 0);
                    elsif remainder = in_width - 13 then
                        out_tmp(in_width - 1 downto 0) <= in_tmp(11 downto 0)& out_tmp_2(in_width - 13 downto 0);
                    else
                        out_tmp(in_width - 1 downto 0) <= in_tmp(15 downto 0)& out_tmp_2(in_width - 17 downto 0);                                                                   
                    end if;
                    
                when first =>
                    out_dv <= '0';
                    stage_next <= second;
                    if remainder = in_width - 1 then
                        out_tmp(in_width +19 downto in_width) <= in_tmp;
                    elsif remainder = in_width - 5 then
                        out_tmp(in_width +19 downto in_width) <= in_tmp(3 downto 0)& in_tmp_2(in_width - 1 downto 4);
                    elsif remainder = in_width - 9 then
                        out_tmp(in_width +19 downto in_width) <= in_tmp(7 downto 0)& in_tmp_2(in_width - 1 downto 8);
                    elsif remainder = in_width - 13 then
                        out_tmp(in_width +19 downto in_width) <= in_tmp(11 downto 0)& in_tmp_2(in_width - 1 downto 12);
                    else
                        out_tmp(in_width +19 downto in_width) <= in_tmp(15 downto 0)& in_tmp_2(in_width - 1 downto 16);                                                                   
                    end if;
                                   
                when second =>
                    out_dv <= '0';
                    stage_next <= third;
                    if remainder = in_width - 1 then
                        out_tmp(in_width +39 downto in_width +20) <= in_tmp;
                    elsif remainder = in_width - 5 then
                        out_tmp(in_width +39 downto in_width +20) <= in_tmp(3 downto 0)& in_tmp_2(in_width - 1 downto 4);
                    elsif remainder = in_width - 9 then
                        out_tmp(in_width +39 downto in_width +20) <= in_tmp(7 downto 0)& in_tmp_2(in_width - 1 downto 8);
                    elsif remainder = in_width - 13 then
                        out_tmp(in_width +39 downto in_width +20) <= in_tmp(11 downto 0)& in_tmp_2(in_width - 1 downto 12);
                    else
                        out_tmp(in_width +39 downto in_width +20) <= in_tmp(15 downto 0)& in_tmp_2(in_width - 1 downto 16);                                                                   
                    end if;
                                        
                when third =>
                    out_dv <= '1';
                    stage_next <= zero;
                    if remainder = in_width - 1 then
                        out_tmp(in_width +43 downto in_width +40) <= in_tmp(3 downto 0);
                        out_tmp_2 <= "0000-0000-0000-0000" & in_tmp(19 downto 4);
                        remainder <= 15;
                    elsif remainder = in_width - 5 then
                        out_tmp(in_width +43 downto in_width +40) <= in_tmp_2(7 downto 4);
                        out_tmp_2 <= in_tmp & in_tmp_2(19 downto 8);
                        remainder <= 11;
                    elsif remainder = in_width - 9 then
                        out_tmp(in_width +43 downto in_width +40) <= in_tmp_2(11 downto 8);
                        out_tmp_2 <= "0000"& in_tmp & in_tmp_2(19 downto 12);
                        remainder <= 7;
                    elsif remainder = in_width - 13 then
                        out_tmp(in_width +43 downto in_width +40) <= in_tmp_2(15 downto 12);
                        out_tmp_2 <= "0000-0000"& in_tmp & in_tmp_2(19 downto 16);
                        remainder <= 3;
                    else
                        out_tmp(in_width +43 downto in_width +40) <= in_tmp_2(19 downto 16);
                        out_tmp_2 <= "0000-0000-0000" & in_tmp;
                        remainder <= 19;                                                                   
                    end if;                
                    is_first<= '0';
            end case;
        end if;
    end process;
end Behavioral;

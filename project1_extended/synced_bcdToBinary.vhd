----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/30/2023 04:58:04 PM
-- Design Name: 
-- Module Name: synced_bcdToBinary - Behavioral
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

entity synced_bcdToBinary is

    Port (
        bcd_1 : in std_logic_vector(3 downto 0);
--        bcd_0 : in std_logic_vector(3 downto 0); 
        start : in std_logic;
--        done : out std_logic;
        ready : out std_logic;
        binary: out std_logic_vector(6 downto 0);
        clk : in std_logic;
        reset : in std_logic;
        pb : in std_logic;
        active : in std_logic
     );
     
end synced_bcdToBinary;

architecture Behavioral_2 of synced_bcdToBinary is

    --signal bcd0_reg, bcd1_reg: unsigned(3 downto 0);
    signal lsb_temp, msb_temp, bcd0_tmp, bcd1_tmp: unsigned(3 downto 0) := "0000";
    type state is (idle, op_shift, op_sub, done_tick);
    signal  state_reg: state;
    signal n_next, n_reg  : unsigned(2 downto 0);
    signal bout, bout_tmp: unsigned(6 downto 0);
    signal readiness :std_logic;
    signal pb_r1, start_r1:std_logic;

begin
    -- clock and reset handler
    
    process(clk) -- synchronising reset 
    begin 
        if(clk'event and clk = '1') then

            if(reset = '1') then
                state_reg <= idle;
--                bcd0_reg <= (others => '0');
--                bcd1_reg <= (others => '0');
                n_reg <= (others => '0');
                n_next <= (others => '0');
                bout <= (others => '0');
                bout_tmp <=(others => '0');
                start_r1 <= '0';
                pb_r1 <='0';
                binary <= (others => '0');
                ready <= '0';
                readiness<= '0';
            end if;  

    --        state_next <= state_reg;
    --        done <= '0';
                  
            n_reg <= n_next;
            bout <= bout_tmp;            
            
            case state_reg is
                when idle =>
                
                    if(start = '1') then
                        start_r1 <= start;
                    end if;
                    if(pb= '1') then
                        pb_r1 <= pb;
                    end if;    
                    ready <= '1';         
                    if(start_r1 = '1') then
                        if(pb_r1 = '1') then
                            bcd0_tmp <= unsigned(bcd_1);
                        else
                            bcd1_tmp <= unsigned(bcd_1);
                        end if;
                        
                        if(active = '1') then
                            state_reg <= op_shift;
                        else
                            state_reg <= idle;      
                        end if;         
    --                    bcd0_tmp <= unsigned(bcd_0);
                        n_next <= "111";     
                    end if;
                        
                when op_shift =>
                
                     pb_r1 <= '0';
                     start_r1 <= '0';
                     ready <= '0';
                     readiness <= '0';
                     if(pb_r1 = '1') then
                        bout_tmp <= bcd0_tmp(0) & bout(6 downto 1);
                        bcd0_tmp <= bcd1_tmp(0) & bcd0_tmp(3 downto 1);
                        bcd1_tmp <= '0' & bcd1_tmp(3 downto 1);
                     else
                        bout_tmp <= lsb_temp(0) & bout(6 downto 1);
                        bcd0_tmp <= msb_temp(0) & lsb_temp(3 downto 1);
                        bcd1_tmp <= '0' & msb_temp(3 downto 1);
                     end if;
                     
                     n_next <= n_reg - 1;
                     state_reg <= op_sub;
--                     if readiness = '1' then
--                        bcd0_reg <= lsb_temp;
--                        bcd1_reg <= msb_temp;
--                     end if;
                     
                 when op_sub =>
                    
                     if bcd0_tmp(3) = '1' then
                        lsb_temp <= bcd0_tmp - 3 ;
                     else
                        lsb_temp <= bcd0_tmp;
                     end if;
                     if bcd1_tmp(3) = '1' then
                        msb_temp <= bcd1_tmp - 3 ;
                     else
                        msb_temp <= bcd1_tmp;
                     end if;
                     if n_next = 0 then
                        state_reg <= done_tick;
                     else
                        state_reg <= op_shift; 
                     end if;
                     readiness <= '1';
                 when done_tick =>
                    binary <= std_logic_vector(bout); 
                    state_reg <= idle;
    --                done <= '1';
            end case;
        end if; 
    end process;
end Behavioral_2;

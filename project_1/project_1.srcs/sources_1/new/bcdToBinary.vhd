----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/22/2023 09:53:58 AM
-- Design Name: 
-- Module Name: bcdToBinary - Behavioral
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

entity bcdToBinary is

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
     
end bcdToBinary;

architecture Behavioral of bcdToBinary is

    signal bcd0_reg, bcd1_reg: unsigned(3 downto 0);
    signal lsb_temp, msb_temp, bcd0_tmp, bcd1_tmp: unsigned(3 downto 0) := "0000";
    type state is (idle, op, done_tick);
    signal  state_reg, state_next : state;
    signal n_next, n_reg  : unsigned(2 downto 0);
    signal bout, bout_tmp: unsigned(6 downto 0);
    signal readiness :std_logic;
    signal msb_lsb, msb_lsb_nxt, act, act_nxt :std_logic;
begin
    -- clock and reset handler
    
    process(clk, reset)
    begin
        if(reset = '1') then
            state_reg <= idle;
            bcd0_reg <= (others => '0');
            bcd1_reg <= (others => '0');
            n_reg <= (others => '0');
            bout <= (others => '0');
            act <= '0';
            msb_lsb <='0';          

        elsif(clk'event and clk = '1') then
            state_reg <= state_next; 
            n_reg <= n_next;
            bcd0_reg <= lsb_temp;
            bcd1_reg <= msb_temp;        
            bout <= bout_tmp;  
            act <= act_nxt;
            msb_lsb <= msb_lsb_nxt;          
        end if; 
    end process;
    
    
--    process(start, act)
--    begin
--        if(rising_edge(start)) then
--            act <= start;
--        end if;
--    end process;
        
    
    process(bcd0_tmp, bcd1_tmp, readiness)
    begin
    
        -- data path functions
        
        case bcd0_tmp(3) is
            when '1' =>
                if(readiness ='1' ) then
                    lsb_temp <= bcd0_tmp;
                else
                    lsb_temp <= bcd0_tmp - 3;
                end if;
            when others =>
                lsb_temp <= bcd0_tmp;
        end case;
        
        case bcd1_tmp(3) is 
            when '1' =>
                if(readiness ='1') then
                    msb_temp <= bcd1_tmp;
                else
                    msb_temp <= bcd1_tmp - 3;
                end if;
            when others =>
                msb_temp <= bcd1_tmp;
        end case;
    
    end process;
    
    -- data path op and next-state logic 
    
    process(  bcd_1, state_reg, bcd0_reg
            , bcd1_reg, lsb_temp, msb_temp
            , act, n_reg, n_next, bout_tmp
            , msb_lsb, bout, active, pb, start) 
    begin
        -- defaults
        state_next <= state_reg; 
        ready <= '0';
        readiness <= '0';
--        done <= '0';
        n_next <= n_reg;
        bcd0_tmp <= bcd0_reg;
        bcd1_tmp <= bcd1_reg;
        bout_tmp <= bout;
        act_nxt <= act;
        msb_lsb_nxt <= msb_lsb;
        
        case state_reg is
            when idle =>
                if(start = '1') then
                    act_nxt <= start;
                end if;
                if(pb= '1') then
                    msb_lsb_nxt <= pb;
                end if;    
                ready <= '1';
                readiness <= '1';         
                if(act = '1') then
                    if(msb_lsb = '1') then
                        bcd0_tmp <= unsigned(bcd_1);
                    else
                        bcd1_tmp <= unsigned(bcd_1);
                    end if;
                    
                    if(active = '1') then
                        state_next <= op;      
                    end if;         
--                    bcd0_tmp <= unsigned(bcd_0);
                    
                    bout_tmp <= (others => '0');
                    n_next <= "111";     
                end if;    
            when op =>
                 act_nxt <= '0';
                 msb_lsb_nxt <= '0';
                 ready <= '0';
                 readiness <= '0';
                 bout_tmp <= bcd0_reg(0) & bout(6 downto 1);
                 bcd0_tmp <= bcd1_reg(0) & bcd0_reg(3 downto 1);
                 bcd1_tmp <= '0' & bcd1_reg(3 downto 1);
                 n_next <= n_reg - 1;
                 if(n_next = 0) then
                    state_next <= done_tick;
                 end if;
             when done_tick => 
                state_next <= idle;
--                done <= '1';
                  
        end case;
             
    end process;
    
    -- data path functions
     
--    lsb_temp <= bcd0_tmp - 3 when bcd0_tmp(3) = '1' else bcd0_tmp;
--    msb_temp <= bcd1_tmp - 3 when bcd1_tmp(3) = '1' else bcd1_tmp;   
    process(state_reg, bout)
    begin
        if(state_reg = done_tick) then
             binary <= std_logic_vector(bout);
        end if;        
    end process ; --when n_next = 0 else (others => '0');
   
    
end Behavioral;

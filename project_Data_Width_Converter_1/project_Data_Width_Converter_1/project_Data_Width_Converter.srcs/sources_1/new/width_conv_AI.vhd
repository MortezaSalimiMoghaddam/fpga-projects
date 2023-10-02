----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/07/2023 04:16:01 PM
-- Design Name: 
-- Module Name: width_conv_AI - Behavioral
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
USE IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

-- BF: Use more meaningful names for signals, inputs, etc.

ENTITY width_conv_AI IS
  PORT
  (
    in_data   : IN std_logic_vector(19 DOWNTO 0);
    in_dv     : IN std_logic;
    clk_in    : IN std_logic;
    --clock_out : IN std_logic;
    resetn    : IN std_logic;
    out_dv    : OUT std_logic;
    out_data  : OUT std_logic_vector(63 DOWNTO 0)
  );
END width_conv_AI;

ARCHITECTURE Behavioral OF width_conv_AI IS
  SIGNAL in_tmp_1, in_tmp_2, in_tmp_3, in_tmp_4 : std_logic_vector(19 DOWNTO 0);
  --signal out_tmp : std_logic_vector(63 downto 0);
  --signal out_tmp_2 : std_logic_vector( downto 0);
  --signal dv_in, dv_out : std_logic;
  TYPE stage IS(init_reg_0, out_1_reg_1,
  out_1_reg_2, out_1_reg_3, out_1_ready,
  out_2_reg_1, out_2_reg_2, out_2_ready,
  out_3_reg_1, out_3_reg_2, out_3_ready,
  out_4_reg_1, out_4_reg_2, out_4_ready,
  out_5_reg_1, out_5_reg_2, out_5_ready);

  --signal stage_next, state_next_i : stage;
  SIGNAL stage_reg : stage := init_reg_0;

  SIGNAL last_stage : stage;

BEGIN

  PROCESS (clk_in)
  BEGIN
    IF (rising_edge(clk_in)) THEN -- BF: if (rising_edge (clk))
      IF resetn = '0' THEN
        in_tmp_1 <= (OTHERS => '0');
        in_tmp_2 <= (OTHERS => '0');
        in_tmp_3 <= (OTHERS => '0');
        in_tmp_4 <= (OTHERS => '0');
        --               out_tmp <= (others => '0');
        out_data   <= (OTHERS => '0');
        out_dv     <= '0';
        stage_reg  <= init_reg_0;
        last_stage <= init_reg_0;
        --                stage_next <= b;
        --               remainder <= 19;
      ELSE

        --            FSM
        --            stage_reg <= stage_next;

        --out_data <= out_tmp;
        IF (in_dv = '1') THEN
          --                dv_out <= '0'; 
          in_tmp_1 <= in_data;
          in_tmp_2 <= in_tmp_1;
          in_tmp_3 <= in_tmp_2;
          in_tmp_4 <= in_tmp_3;
        END IF;

        out_dv <= '0';
        CASE stage_reg IS

          WHEN init_reg_0 => -- BF: init_st
            IF in_dv = '1' THEN
              stage_reg <= out_1_reg_1;
            END IF;

          WHEN out_1_reg_1 => -- out_1_reg_0 
            IF in_dv = '1' THEN
              stage_reg <= out_1_reg_2;
            END IF;

          WHEN out_1_reg_2 => -- out_2_reg_1
            IF in_dv = '1' THEN
              stage_reg <= out_1_reg_3;
            END IF;

          WHEN out_1_reg_3 =>
            IF in_dv = '1' THEN
              stage_reg <= out_1_ready;
            END IF;

          WHEN out_1_ready => -- out_1_ready
            IF in_dv = '1' THEN
              stage_reg <= out_2_reg_1;
            END IF;
            out_data <= in_tmp_1(3 DOWNTO 0) & in_tmp_2 & in_tmp_3 & in_tmp_4;
            IF last_stage = out_1_reg_3 THEN
              out_dv <= '1';
              --                        elsif last_stage /= stage_reg then
              --                            out_dv <= '1';
              --ELSE
              --  out_dv <= '0';
            END IF;
            --                        dv_out <= '1';

          WHEN out_2_reg_1 =>
            IF in_dv = '1' THEN
              stage_reg <= out_2_reg_2;
            END IF;

          WHEN out_2_reg_2 =>
            IF in_dv = '1' THEN
              stage_reg <= out_2_ready;
            END IF;

          WHEN out_2_ready =>
            IF in_dv = '1' THEN
              stage_reg <= out_3_reg_1;
            END IF;
            out_data <= in_tmp_1(7 DOWNTO 0) & in_tmp_2 & in_tmp_3 & in_tmp_4(19 DOWNTO 4);
            IF last_stage = out_2_reg_2 THEN
              out_dv <= '1';
              --elsif last_stage /= stage_reg then
              --  out_dv <= '1';
              --ELSE
              --  out_dv <= '0';
            END IF;
            --                        dv_out <= '1';

          WHEN out_3_reg_1 =>
            IF in_dv = '1' THEN
              stage_reg <= out_3_reg_2;
            END IF;

          WHEN out_3_reg_2 =>
            IF in_dv = '1' THEN
              stage_reg <= out_3_ready;
            END IF;

          WHEN out_3_ready =>
            IF in_dv = '1' THEN
              stage_reg <= out_4_reg_1;
            END IF;
            out_data <= in_tmp_1(11 DOWNTO 0) & in_tmp_2 & in_tmp_3 & in_tmp_4(19 DOWNTO 8);
            IF last_stage = out_3_reg_2 THEN
              out_dv <= '1';
              --                       elsif last_stage /= stage_reg then
              --                            out_dv <= '1'; 
              --ELSE
              --  out_dv <= '0';
            END IF;

            --                        dv_out <= '1';

          WHEN out_4_reg_1 =>
            IF in_dv = '1' THEN
              stage_reg <= out_4_reg_2;
            END IF;

          WHEN out_4_reg_2 =>
            IF in_dv = '1' THEN
              stage_reg <= out_4_ready;
            END IF;

          WHEN out_4_ready =>
            IF in_dv = '1' THEN
              stage_reg <= out_5_reg_1;
            END IF;
            out_data <= in_tmp_1(15 DOWNTO 0) & in_tmp_2 & in_tmp_3 & in_tmp_4(19 DOWNTO 12);
            IF last_stage = out_4_reg_2 THEN
              out_dv <= '1';
              --                        elsif last_stage  then
              --                             out_dv <= '1';
              --ELSE
              --  out_dv <= '0';
            END IF;
            --                         dv_out <= '1';

          WHEN out_5_reg_1 =>
            IF in_dv = '1' THEN
              stage_reg <= out_5_reg_2;
            END IF;

          WHEN out_5_reg_2 =>
            IF in_dv = '1' THEN
              stage_reg <= out_5_ready;
            END IF;

          WHEN out_5_ready =>
            IF in_dv = '1' THEN
              stage_reg <= out_1_reg_1;
            END IF;
            out_data <= in_tmp_1 & in_tmp_2 & in_tmp_3 & in_tmp_4(19 DOWNTO 16);
            IF last_stage = out_5_reg_2 THEN
              out_dv <= '1';
              --elsif last_stage /= stage_reg then
              --    out_dv <= '1'; 
              --ELSE
              --  out_dv <= '0';
            END IF;
            --                        dv_out <= '1';
        END CASE;
        last_stage <= stage_reg; -- BF: This is a wise logic! :)   
      END IF;
    END IF;
  END PROCESS;
END Behavioral;
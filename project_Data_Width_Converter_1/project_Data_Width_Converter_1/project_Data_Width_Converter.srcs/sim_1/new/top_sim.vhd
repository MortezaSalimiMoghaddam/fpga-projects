library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity design_1_conversion_wrapper_tb is
end;

architecture bench of design_1_conversion_wrapper_tb is
  -- Clock period
  constant clk_period : time := 5 ns;
  -- Generics
  -- Ports
  signal clk_in : std_logic:='0';
  signal clk_out : std_logic:='0';
  signal in_data : std_logic_vector (19 DOWNTO 0);
  signal in_dv : std_logic;
  signal out_data : std_logic_vector (63 DOWNTO 0);
  signal out_dv : std_logic;
  signal reset : std_logic;
begin

  design_1_conversion_wrapper_inst : entity work.design_1_conversion_wrapper(STRUCTURE)
  port map (
    clk_in => clk_in,
    clk_out => clk_out,
    in_data => in_data,
    in_dv => in_dv,
    out_data => out_data,
    out_dv => out_dv,
    resetn => reset
  );
    process
    begin
        clk_in <= not(clk_in);
        wait for clk_period/2;
    end process;
    
    process
    begin
        clk_out <= not (clk_out); 
        wait for clk_period;
    end process;
    PROCESS
    BEGIN

        in_data <= "10000001110110000000";
        in_dv <= '1';
        reset <= '0';
        WAIT FOR 5 ns;
        in_data <= "00100001110110000000";
        in_dv <= '1';
        reset <= '1';
        WAIT FOR 5 ns;

        in_data <= "10000001110110000011";
        in_dv <= '1';
        reset <= '1';
        WAIT FOR 5 ns;

        in_data <= "01000011110110001100";
        in_dv <= '1';
        reset <= '1';
        WAIT FOR 5 ns;

        in_data <= "00101001100010110110";
        in_dv <= '1';
        reset <= '1';
        WAIT FOR 5 ns;

        in_data <= "01111011010110011101";
        in_dv <= '0';
        reset <= '1';
        WAIT FOR 5 ns;

        in_data <= "01111011010110011101";
        in_dv <= '1';
        reset <= '1';
        WAIT FOR 5 ns;

        in_data <= "01100001101010001100";
        in_dv <= '1';
        reset <= '1';
        WAIT FOR 5 ns;

        in_data <= "10000101110011110011";
        in_dv <= '1';
        reset <= '1';
        WAIT FOR 5 ns;

        in_data <= "01100111100110000000";
        in_dv <= '1';
        reset <= '1';
        WAIT FOR 5 ns;

        in_data <= "00100001110110000000";
        in_dv <= '1';
        reset <= '1';
        WAIT FOR 5 ns;

        in_data <= "10000001110110100011";
        in_dv <= '1';
        reset <= '1';
        WAIT FOR 5 ns;

        in_data <= "01000011110110001100";
        in_dv <= '1';
        reset <= '1';
        WAIT FOR 5 ns;

        in_data <= "00101001100010110110";
        in_dv <= '1';
        reset <= '1';
        WAIT FOR 5 ns;

        in_data <= "01001011010110011101";
        in_dv <= '1';
        reset <= '1';
        WAIT FOR 5 ns;

        in_data <= "01011011010110011001";
        in_dv <= '1';
        reset <= '1';
        WAIT FOR 5 ns;

        in_data <= "01100001101010000100";
        in_dv <= '1';
        reset <= '0';
        WAIT FOR 5 ns;

        in_data <= "10000101110011110011";
        in_dv <= '1';
        reset <= '1';
        WAIT FOR 5 ns;

        in_data <= "01100111100110001010";
        in_dv <= '1';
        reset <= '1';
        WAIT FOR 5 ns;

        --            in_data <= "01000011110110001100";

        in_data <= "10000001110110000000";
        in_dv <= '1';
        reset <= '1';
        WAIT FOR 5 ns;

        in_data <= "00100001110110000000";
        in_dv <= '1';
        reset <= '1';
        WAIT FOR 5 ns;

        in_data <= "10000001110110000011";
        in_dv <= '1';
        reset <= '1';
        WAIT FOR 5 ns;

        in_data <= "01000011110110001100";
        in_dv <= '1';
        reset <= '1';
        WAIT FOR 5 ns;

        in_data <= "00101001100010110110";
        in_dv <= '1';
        reset <= '1';
        WAIT FOR 5 ns;

        in_data <= "01111011010110011101";
        in_dv <= '1';
        reset <= '1';
        WAIT FOR 5 ns;

        in_data <= "01111011010110011101";
        in_dv <= '1';
        reset <= '1';
        WAIT FOR 5 ns;

        in_data <= "01100001101010001100";
        in_dv <= '1';
        reset <= '1';
        WAIT FOR 5 ns;

        in_data <= "10000101110011110011";
        in_dv <= '1';
        reset <= '1';
        WAIT FOR 5 ns;

        in_data <= "01100111100110000000";
        in_dv <= '1';
        reset <= '1';
        WAIT FOR 5 ns;

        in_data <= "00100001110110000000";
        in_dv <= '1';
        reset <= '1';
        WAIT FOR 5 ns;

        in_data <= "10000001110110100011";
        in_dv <= '1';
        reset <= '1';
        WAIT FOR 5 ns;

        in_data <= "01000011110110001100";
        in_dv <= '1';
        reset <= '1';
        WAIT FOR 5 ns;

        in_data <= "00101001100010110110";
        in_dv <= '1';
        reset <= '1';
        WAIT FOR 5 ns;

        in_data <= "01001011010110011101";
        in_dv <= '1';
        reset <= '1';
        WAIT FOR 5 ns;

        in_data <= "01011011010110011001";
        in_dv <= '0';
        reset <= '1';
        WAIT FOR 5 ns;

        in_data <= "01100001101010000100";
        in_dv <= '1';
        reset <= '1';
        WAIT FOR 5 ns;

        in_data <= "10000101110011110011";
        in_dv <= '0';
        reset <= '1';
        WAIT FOR 5 ns;

        in_data <= "01100111100110001010";
        in_dv <= '1';
        reset <= '1';
        WAIT FOR 5 ns;

        in_data <= "10000101110011110011";
        in_dv <= '1';
        reset <= '1';
        WAIT FOR 5 ns;

        in_data <= "01111011010110011101";
        in_dv <= '0';
        reset <= '1';
        WAIT FOR 5 ns;

        in_data <= "01111011010110011101";
        in_dv <= '0';
        reset <= '1';
        WAIT FOR 5 ns;
        --            in_data <= "01000011110110001100";
        in_dv <= '0';
        --            reset <= '1';
        --            WAIT FOR 5 ns;  

        WAIT;
    END PROCESS;
    

end;

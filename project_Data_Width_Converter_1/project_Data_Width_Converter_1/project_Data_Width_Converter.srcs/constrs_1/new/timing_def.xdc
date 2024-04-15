#set_property -dict { PACKAGE_PIN E3    IOSTANDARD LVCMOS33 } [get_ports { clk }]; 
create_clock -period 5.000 -name clk -waveform {0.000 2.500} [get_ports clk_in]
create_clock -period 10.000 -name clk_2 -waveform {0.000 5.000} [get_ports clk_out]

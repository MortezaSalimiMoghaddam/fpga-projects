# fpga-projects
Here are the projects I've done on Vivado using VHDL

### project_1
Is a BCD to binary converter that can handle transformation of numbers up to 99 which are fiven in BCD.

### project1_extended
Provides you with the code of project one which has been edited so that the whole circuit system is implemented sequentially.

### project_Data_Width_Converter_1
Takes in 20-bit inputs and gives 64-bit outputs. This project exercises some of the concepts of CDC and timing 
constraints that are of high importance when using vivado professionally.

### uart_cdc
Has two clock domains, one for the user side and another for uart handler. The user side shows the bytes received 
from RX pin, having crossed it through clock domains. The user side also stores bytes in a FIFO in order to be sent 
on TX pin in uart clock domain.

#### the pdf files are the result of my researchs and I hope that they come in handy for you! 

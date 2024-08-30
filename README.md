# Lattice ICE 40 FPGA
Firmware developed for Lattice ICE40 FPGA with designs in Verilog and testbenches in SystemVerilog. Starting from the basics and designing simple projects and modules to learn the fundamentals of RTL Design.

## Projects:

#### LED Adder
- This was a simple project using only combinational logic to implement a 2-bit full adder
- I wired four switches as operands to be added and displayed the sum on 4 LEDs in binary 

#### Ring Counter
- This is another simple project that used D Flip-Flops to implement a Ring Counter
- It displayed the output on 4 LEDs rotating LEDs every second
- I had to implement a clock divider using a counter (D Flip-Flops) to rotate LEDs at a rate I could see with my eyes

#### Components
- These are some useful components I plan on using for future projects like a shift register (regular and with linear feedback), RAM, FIFO, and more

#### 7 Segment Display
- This is a multi-module project in order to increment a 7 Segment Display with the press of a switch
- It utilizes a module to debounce the switch, convert binary to 7 Segment hex encoding, and a top-level module to handle the counter and switch logic

This repository is very much still a work in progress and hope to contribute more as I go.
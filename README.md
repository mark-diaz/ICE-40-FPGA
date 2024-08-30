# Lattice ICE 40 FPGA
RTL Code developed for Lattice ICE40 FPGA with designs in Verilog and testbenches in SystemVerilog. I'm starting from the basics and designing simple projects and modules to learn the fundamentals of RTL Design. I utilize a completely open-source FPGA toolchain to design and program the FPGA but I use ModelSim to verify and create testbenches for my designs.

## Projects:

#### 7 Segment Display
- This is a multi-module project in order to increment a 7 Segment Display with the press of a switch
- It utilizes a module to debounce the switch, convert binary to 7 Segment hex encoding, and a top-level module to handle the counter and switch logic

#### Components
- These are some useful components I plan on using for future projects like a shift register (regular and with linear feedback), RAM, FIFO, and more
- They are verified to work utilizing testbenches written in SystemVerilog

#### Ring Counter
- This is a simple project that uses D Flip-Flops to implement a Ring Counter
- It displays the output on 4 LEDs rotating LEDs every second
- It utilizes a clock divider to rotate LEDs at a rate visible to the human eye

#### LED Adder
- This was a simple project using only combinational logic to implement a 2-bit full adder
- I wired four switches as operands to be added and displayed the sum on 4 LEDs in binary 


This repository is very much still a work in progress and hope to contribute more as I go.
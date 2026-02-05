# A collection of FPGA mini-projects

This repository contains some of my first projects as a beginner in FPGA programming.

Hardware:
- MuseLabs icesugar-nano FPGA dev board
- This hosts an iCE40LP1K-CM36 FPGA

Software tooling:
- apio: an open-source toolkit for programming FPGA boards

### Build steps

Example for the "blinky" project:
1. Connect the FPGA board to your computer
2. Open a terminal and run:
```bash
cd blinky
apio build
apio upload
```
This will create a `blinky/_build` directory with build artifacts, then upload the bitstream onto the FPGA, and the FPGA will begin to "run the code" automatically.

## 1. Blinky

My first ever Verilog program! This one blinks the yellow LED on and off about every 0.7 seconds using a binary counter as a clock divider, dividing the 12 MHz clock on the board by $2^{23}$.

If you saw the number 22 in the code and you're wondering where the extra factor of 2 comes from, the counter is actually 23 bits: they are numbered from 22 to 0.


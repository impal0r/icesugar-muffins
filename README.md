# A collection of FPGA mini-projects

This repository contains some of my first projects as a beginner in FPGA programming.

Hardware:
- MuseLabs icesugar-nano FPGA dev board (this hosts an iCE40LP1K-CM36 FPGA)
- USB-C cable
- Laptop

Software tooling:
- apio: an open-source toolkit for programming FPGA boards

Apio supports Verilog and SystemVerilog as its HDL launguages. I made my first couple of mini-projects using only Verilog, but might later write some SystemVerilog too.

### Build steps

Example for the "blinky" project:
1. Connect the FPGA board to your computer
2. Open a terminal and run:
```bash
cd blinky
apio build
apio upload
```
This will create a `blinky/_build` directory with build artifacts, then upload the bitstream onto the FPGA. The FPGA will initialise automatically and the LED should start blinking like it's supposed to.

## 1. Blinky

My first ever Verilog program! This one blinks the yellow LED on and off about every 0.7 seconds using a binary counter as a clock divider, dividing the 12 MHz clock on the board by $2^{23}$.

If you saw the number 22 in the code and you're wondering where the extra factor of 2 comes from, the counter is actually 23 bits: they are numbered from 22 to 0.

## 2. Blinky with one second period

For my second ever Verilog program, I decided to change the blink period to one second. This meant I had to divide the clock frequency by 12 million, which is not a power of 2. But its only prime factors are 2, 3 and 5, making the implementation feasible. I used a trick for making whole-number clock dividers using a handful of binary registers and a NOR gate.

This time, I also wrote a test bench so I could simulate the circuit and view the output in GTKwave.

## 3. Morse code generator

Next, something slightly more practical: we can make the LED output Morse code. The sequence is hardcoded in the design via an array of timings (the number of clock pulses to wait before next turning the LED on, or off).

To make the implementation easier, there is a Python script which converts Morse code sequences to a Verilog stub: this can be copy-pasted into `morse.v`. Try the command `python translate.py --help` to see possible command-line arguments. I used the the script in the following way:

```python translate.py hello_world_morse.txt -o hello_world_timings.txt -i 8```

The FPGA currently outputs the phrase "HELLO WORLD", which takes exactly 64 toggles of the LED. To make it say a different phrase, you may have to change the parameters which control the size of the timings array, and find a way to deal with unused array entries.

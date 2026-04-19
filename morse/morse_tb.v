`timescale 1ns / 100ps

module tb_morse;

    reg clk_in;
    reg yellow_led_out;

    Morse DUT (
        .CLK(clk_in),
        .YELLOW_LED(yellow_led_out)
    );

    // 12 MHz clock (1000/(12*2) == 41.66666...)
    initial begin
        clk_in = 0;
        forever #41.7 clk_in = ~clk_in;
    end

    // Test stimulus: run the simulation for 20 milliseconds
    initial begin
        #25000000;  // 25 milliseconds
        $finish;
    end

    // Save values of vars for GTKwave
    initial begin
        $dumpvars;
    end

endmodule
`timescale 1ns / 100ps

module tb_blinky_1s;

    reg clk_in;
    reg yellow_led_out;

    BlinkyOneSecond DUT (
        .CLK(clk_in),
        .YELLOW_LED(yellow_led_out)
    );

    // 12 MHz clock (1000/(12*2) == 41.66666...)
    initial begin
        clk_in = 0;
        forever #41.7 clk_in = !clk_in;
    end

    // Test stimulus: run the simulation for 20 milliseconds
    initial begin
        #20000000;
        $finish;
    end

    // Monitor signals & dump vars for GTKwave
    initial begin
        // $monitor("Time=%0t | clk_in=%b | clk_256hz=%b | yellow_led=%b",
        //          $time, clk_in, DUT.clk_out, yellow_led_out);
        $dumpvars;
    end

endmodule

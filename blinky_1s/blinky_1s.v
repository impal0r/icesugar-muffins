module BlinkyOneSecond (
    input CLK,  // default is 12 MHz
    output YELLOW_LED
);

    // Assuming the clock frequency is exactly 12.000 MHz,
    // We need to divide by 12_000_000 to get 1s period
    // (TODO how close to 12 MHz is the clock frequency actually?)

    // 12_000_000 = 2^8 * 5^6 * 3

    reg [7:0] binary_counter = 0;
    wire clk1, clk2, clk3, clk4, clk5, clk6, clk_out;

    // NON-BINARY CLOCK DIVIDERS
    // Stage 1: divide by 3
    DivideClockBy_3 div3 (.CLK_IN(CLK), .CLK_OUT(clk1));
    // Stage 2: divide by 5 (1/6)
    DivideClockBy_5 div5_1 (.CLK_IN(clk1), .CLK_OUT(clk2));
    // Stage 3: divide by 5 (2/6)
    DivideClockBy_5 div5_2 (.CLK_IN(clk2), .CLK_OUT(clk3));
    // Stage 4: divide by 5 (3/6)
    DivideClockBy_5 div5_3 (.CLK_IN(clk3), .CLK_OUT(clk4));
    // Stage 5: divide by 5 (4/6)
    DivideClockBy_5 div5_4 (.CLK_IN(clk4), .CLK_OUT(clk5));
    // Stage 6: divide by 5 (5/6)
    DivideClockBy_5 div5_5 (.CLK_IN(clk5), .CLK_OUT(clk6));
    // Stage 7: divide by 5 (6/6)
    DivideClockBy_5 div5_6 (.CLK_IN(clk6), .CLK_OUT(clk_out));

    // BINARY CLOCK DIVIDER
    always @(posedge clk_out) begin
        binary_counter = binary_counter + 1;
    end

    assign YELLOW_LED = binary_counter[7];

endmodule

module DivideClockBy_3 (
    input  CLK_IN,
    output CLK_OUT
);

    reg A = 0, B = 0;
    wire C;

    assign C = ~(A | B);

    always @(posedge CLK_IN) begin
        // Non-blocking (parallel) assignment using <=
        B <= A;
        A <= C;
    end

    assign CLK_OUT = C;

endmodule

module DivideClockBy_5 (
    input  CLK_IN,
    output CLK_OUT
);

    reg A = 0, B = 0, C = 0, D = 0;
    wire E;

    assign E = ~(A | B | C | D);

    always @(posedge CLK_IN) begin
        B <= A;
        C <= B;
        D <= C;
        A <= E;
    end

  assign CLK_OUT = E;

endmodule

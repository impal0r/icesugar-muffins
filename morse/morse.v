module Morse(
    input CLK,  // default is 12 MHz
    output YELLOW_LED
);

    // This is the plan:
    // Store the morse code sequence in an array
    // Generate a slow clock from the 12MHz clock (maybe down to ~10Hz?)
    // The values in the array represent the number of slow clock cycles to wait
    // before toggling the LED
    // Repeat in a loop

    parameter CLOCK_DIV_POW_2 = 20;

    reg [5:0] loop_counter = 0;
    wire [3:0] wait_timing;
    reg [3:0] wait_time_counter = 0;
    reg [CLOCK_DIV_POW_2-1:0] clock_divider = 0;
    wire slow_clk;
    reg output_ = 0;

    TimingsROM #(.N_ADDR_BITS(6), .N_DATA_BITS(4)) timingsROM (
        .address(loop_counter),
        .data(wait_timing)
    );

    assign slow_clk = clock_divider[CLOCK_DIV_POW_2-1];

    always @(posedge CLK)
    begin
        clock_divider = clock_divider + 1;
    end

    always @(posedge slow_clk)
    begin
        if (wait_time_counter == 0) begin
            wait_time_counter = wait_timing;
            loop_counter = loop_counter + 1;
            output_ = ~output_;
        end else begin
            wait_time_counter = wait_time_counter - 1;
        end
    end

    assign YELLOW_LED = output_;

endmodule

module TimingsROM #(parameter N_ADDR_BITS = 6, N_DATA_BITS = 4)(
    input [N_ADDR_BITS-1:0] address,
    output [N_DATA_BITS-1:0] data
);

    reg [N_DATA_BITS-1:0] timings[(2**N_ADDR_BITS)-1:0];

    assign data[N_DATA_BITS-1:0] = timings[address];

    initial begin
        timings[0] = 4'd0;
        timings[1] = 4'd2;
        timings[2] = 4'd0;
        timings[3] = 4'd2;
        timings[4] = 4'd0;
        timings[5] = 4'd2;
        timings[6] = 4'd0;
        timings[7] = 4'd6;
        timings[8] = 4'd0;
        timings[9] = 4'd6;
        timings[10] = 4'd0;
        timings[11] = 4'd2;
        timings[12] = 4'd2;
        timings[13] = 4'd0;
        timings[14] = 4'd0;
        timings[15] = 4'd2;
        timings[16] = 4'd0;
        timings[17] = 4'd6;
        timings[18] = 4'd0;
        timings[19] = 4'd2;
        timings[20] = 4'd2;
        timings[21] = 4'd0;
        timings[22] = 4'd0;
        timings[23] = 4'd2;
        timings[24] = 4'd0;
        timings[25] = 4'd6;
        timings[26] = 4'd2;
        timings[27] = 4'd0;
        timings[28] = 4'd2;
        timings[29] = 4'd0;
        timings[30] = 4'd2;
        timings[31] = 4'd8;
        timings[32] = 4'd0;
        timings[33] = 4'd2;
        timings[34] = 4'd2;
        timings[35] = 4'd0;
        timings[36] = 4'd2;
        timings[37] = 4'd4;
        timings[38] = 4'd2;
        timings[39] = 4'd0;
        timings[40] = 4'd2;
        timings[41] = 4'd0;
        timings[42] = 4'd2;
        timings[43] = 4'd4;
        timings[44] = 4'd0;
        timings[45] = 4'd2;
        timings[46] = 4'd2;
        timings[47] = 4'd0;
        timings[48] = 4'd0;
        timings[49] = 4'd6;
        timings[50] = 4'd0;
        timings[51] = 4'd2;
        timings[52] = 4'd2;
        timings[53] = 4'd0;
        timings[54] = 4'd0;
        timings[55] = 4'd2;
        timings[56] = 4'd0;
        timings[57] = 4'd6;
        timings[58] = 4'd2;
        timings[59] = 4'd0;
        timings[60] = 4'd0;
        timings[61] = 4'd2;
        timings[62] = 4'd0;
        timings[63] = 4'd14;
    end

endmodule
module Blinky(
    input CLK,  // default is 12 MHz
    output YELLOW_LED
);

    reg [22:0] counter = 0;

    always @(posedge CLK)
    begin
        counter = counter + 1;
    end

    assign YELLOW_LED = counter[22];

endmodule
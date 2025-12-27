// need to use this if you are using push buttons
`timescale 1ns / 1ps

module debounce #(
    parameter threshold = 1000000
)(
    input  clk,
    input  btn,
    output reg transmit
);

reg button_ff1 = 0;
reg button_ff2 = 0;
reg [30:0] count = 0;

// ===============================
// Synchronizer
// ===============================
always @(posedge clk) begin
    button_ff1 <= btn;
    button_ff2 <= button_ff1;
end

// ===============================
// Debounce counter
// ===============================
always @(posedge clk) begin
    if (button_ff2) begin
        if (~&count)
            count <= count + 1;
    end else begin
        if (count != 0)
            count <= count - 1;
    end

    if (count > threshold)
        transmit <= 1;
    else
        transmit <= 0;
end

endmodule

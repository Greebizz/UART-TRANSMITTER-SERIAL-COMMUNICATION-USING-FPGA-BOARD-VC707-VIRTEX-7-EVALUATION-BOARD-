//Written By Greeshma Potlapalli
//anyissue email: greeshmapotlapalli@gmail.com

`timescale 1ns / 1ps

module Transmitter(
    input        clk,
    input  [7:0] data,
    input        reset,
    input        transmit,   // FIX: declared
    output reg   TxD          // FIX: must be reg
);

reg [3:0]  bit_counter;
reg [13:0] baudrate_counter; // 200 MHz / 9600 = 20833
reg [9:0]  shiftright_register;

reg state, next_state;
reg shift;
reg load;
reg clear;

// ================================
// UART transmitter (sequential)
// ================================
always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        bit_counter <= 0;
        baudrate_counter <= 0;
    end else begin
        baudrate_counter <= baudrate_counter + 1;

        if (baudrate_counter == 20832) begin   // FIX
            state <= next_state;
            baudrate_counter <= 0;

            if (load)
                shiftright_register <= {1'b1, data, 1'b0};

            if (clear)
                bit_counter <= 0;

            if (shift)
                shiftright_register <= shiftright_register >> 1;

            bit_counter <= bit_counter + 1;
        end
    end
end

// ================================
// FSM control
// ================================
always @(posedge clk) begin
    load  <= 0;
    shift <= 0;
    clear <= 0;
    TxD   <= 1;

    case (state)
        0: begin
            if (transmit) begin
                next_state <= 1;
                load <= 1;
            end else begin
                next_state <= 0;
                TxD <= 1;
            end
        end

        1: begin
            if (bit_counter == 10) begin
                next_state <= 0;
                clear <= 1;
            end else begin
                next_state <= 1;
                TxD <= shiftright_register[0];
                shift <= 1;
            end
        end

        default: next_state <= 0;
    endcase
end

endmodule

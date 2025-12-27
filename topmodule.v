module topmodule(
    input  wire [7:0] data,
    input  wire SYSCLK_P,
    input  wire SYSCLK_N,
    input  wire transmit,
    input  wire btn,
    output wire TxD,
    output wire TxD_debug,
    output wire transmit_debug,
    output wire btn_debug,
    output wire clk_debug
);

    wire transmit_out;
    wire reset;
    wire clk_raw;
    wire clk;

    // =========================================================
    // CLOCK
    // =========================================================
    IBUFDS #(
        .DIFF_TERM("TRUE"),
        .IOSTANDARD("LVDS_25")
    ) ibufds (
        .I  (SYSCLK_P),
        .IB (SYSCLK_N),
        .O  (clk_raw)
    );

    BUFG bufg_clk (
        .I(clk_raw),
        .O(clk)
    );

    // =========================================================
    // RESET (button used as reset)
    // =========================================================
    assign reset = btn;

    // =========================================================
    // DEBOUNCE
    // =========================================================
    debounce DB (
        .clk   (clk),
        .btn   (btn),
        .transmit (transmit_out)
    );

    // =========================================================
    // TRANSMITTER
    // =========================================================
    Transmitter T1 (
        .clk      (clk),
        .reset    (reset),
        .transmit (transmit_out),
        .data     (data),
        .TxD      (TxD)
    );

    // =========================================================
    // DEBUG SIGNALS
    // =========================================================
    assign TxD_debug       = TxD;
    assign transmit_debug  = transmit_out;
    assign btn_debug       = btn;
    assign clk_debug       = clk;

endmodule

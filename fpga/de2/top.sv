// -------------------------------------------------------------------
// Copyright 2025 by Heqing Huang (feipenghhq@gamil.com)
// -------------------------------------------------------------------
//
// Project: PS/2 Controller
// Author: Heqing Huang
// Date Created: 07/09/2025
//
// -------------------------------------------------------------------
// Top level for the DE2 FPGA board
// Receive scan code from keyboard and send it to host computer
// through UART
// -------------------------------------------------------------------

module top
(
    input         CLOCK_50,    // 50 MHz
    input         KEY,          // Pushbutton[3:0]

    // PS2
    input         PS2_CLK,
    input         PS2_DAT,

    // Uart
    input         UART_RXD,
    output        UART_TXD,

    // LED
    output [1:0]  LEDG
);

localparam CLK_FREQ = 50;
localparam BAUD_RATE = 115200;
localparam CFG_DIV = (CLK_FREQ * 1000000) / BAUD_RATE - 1;

logic [7:0] scan_code;
logic       valid;

ps2_host
u_ps2_host(
    .clk        (CLOCK_50),
    .rst_n      (KEY),
    .ps2_clk    (PS2_CLK),
    .ps2_data   (PS2_DAT),
    .valid      (valid),
    .scan_code  (scan_code),
    .parity_err (LEDG[0]),
    .frame_err  (LEDG[1])
);

uart_tx
u_uart_tx (
    .clk        (CLOCK_50),
    .rst_n      (KEY),
    .cfg_div    (CFG_DIV),
    .cfg_txen   (1),
    .cfg_nstop  (0),
    .tx_valid   (valid),
    .tx_data    (scan_code),
    .tx_ready   (),
    .uart_txd   (UART_TXD)
);

endmodule


//`define hack
module top
(
    input logic         clk,
    input logic         rst_n,

    // PS2 interface
    input logic         ps2_clk,
    input logic         ps2_data,

    output logic        parity_err,
    output logic        frame_err
);

logic [7:0] scan_code;
logic       valid;
logic [7:0] hack;
logic       hack_valid;
logic       pressed;

ps2_host
u_ps2_host(
    .clk        (clk),
    .rst_n      (rst_n),
    .ps2_clk    (ps2_clk),
    .ps2_data   (ps2_data),
    .valid      (valid),
    .scan_code  (scan_code),
    .parity_err (parity_err),
    .frame_err  (frame_err)
);

ps2_scancode2hack
u_ps2_scancode2hack (
    .clk        (clk),
    .rst_n      (rst_n),
    .scan_code  (scan_code),
    .valid      (valid),
    .pressed    (pressed),
    .hack       (hack),
    .hack_valid (hack_valid)
);


endmodule

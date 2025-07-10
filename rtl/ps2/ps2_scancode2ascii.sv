// -------------------------------------------------------------------
// Copyright 2025 by Heqing Huang (feipenghhq@gamil.com)
// -------------------------------------------------------------------
//
// Project: PS2 Controller
// Author: Heqing Huang
// Date Created: 07/09/2025
//
// -------------------------------------------------------------------
// Map the PS/2 keyboard Scan Code Set 2 to ASCII characters with
// limited support
// Limitation:
// - Do not handle the shift
// - Do not handle multiple keys.
// - Do not handle keys that start with E0
// -------------------------------------------------------------------

module ps2_scancode2ascii (
    input  logic        clk,
    input  logic        rst_n,
    input  logic [7:0]  scan_code,
    input  logic        valid,      // Asserted when scan_code is valid
    output logic        pressed,    // Asserted if the key is pressed. De-assert if the key is released
    output logic [7:0]  ascii,
    output logic        ascii_valid
);

    localparam BREAK = 8'hF0;

    logic [7:0] ascii_lut;

    always_comb begin
        case (scan_code)
            // Alphanumeric - unshifted
            8'h1C: ascii_lut = "a";
            8'h32: ascii_lut = "b";
            8'h21: ascii_lut = "c";
            8'h23: ascii_lut = "d";
            8'h24: ascii_lut = "e";
            8'h2B: ascii_lut = "f";
            8'h34: ascii_lut = "g";
            8'h33: ascii_lut = "h";
            8'h43: ascii_lut = "i";
            8'h3B: ascii_lut = "j";
            8'h42: ascii_lut = "k";
            8'h4B: ascii_lut = "l";
            8'h3A: ascii_lut = "m";
            8'h31: ascii_lut = "n";
            8'h44: ascii_lut = "o";
            8'h4D: ascii_lut = "p";
            8'h15: ascii_lut = "q";
            8'h2D: ascii_lut = "r";
            8'h1B: ascii_lut = "s";
            8'h2C: ascii_lut = "t";
            8'h3C: ascii_lut = "u";
            8'h2A: ascii_lut = "v";
            8'h1D: ascii_lut = "w";
            8'h22: ascii_lut = "x";
            8'h35: ascii_lut = "y";
            8'h1A: ascii_lut = "z";

            // Numbers top row
            8'h16: ascii_lut = "1";
            8'h1E: ascii_lut = "2";
            8'h26: ascii_lut = "3";
            8'h25: ascii_lut = "4";
            8'h2E: ascii_lut = "5";
            8'h36: ascii_lut = "6";
            8'h3D: ascii_lut = "7";
            8'h3E: ascii_lut = "8";
            8'h46: ascii_lut = "9";
            8'h45: ascii_lut = "0";

            // Space, Enter, etc.
            8'h29: ascii_lut = " ";
            8'h5A: ascii_lut = 8'h0D;  // Enter
            8'h66: ascii_lut = 8'h08;  // Backspace
            8'h0D: ascii_lut = 8'h09;  // Tab

            // Punctuation (non-shifted)
            8'h4E: ascii_lut = "-";
            8'h55: ascii_lut = "=";
            8'h5D: ascii_lut = 8'h5C;   // \
            8'h54: ascii_lut = "[";
            8'h5B: ascii_lut = "]";
            8'h4C: ascii_lut = ";";
            8'h52: ascii_lut = "'";
            8'h41: ascii_lut = ",";
            8'h49: ascii_lut = ".";
            8'h4A: ascii_lut = "/";

            default: ascii_lut = 8'h00;
        endcase
    end

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            ascii       <= 8'h00;
            ascii_valid <= 1'b0;
            pressed     <= 1'b1;    // first key must be pressed
        end
        else begin
            ascii_valid <= 1'b0;
            if (valid) begin
                // break code
                if (scan_code == BREAK) begin
                    pressed <= 1'b0;                // first scan code after BREAK code is released
                end
                else begin
                    ascii       <= ascii_lut;
                    ascii_valid <= 1'b1;
                    if (!pressed) pressed <= 1'b1;  // if the current key is released, next key must be pressed
                end
            end
        end
    end

endmodule

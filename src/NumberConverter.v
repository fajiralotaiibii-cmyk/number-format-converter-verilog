`timescale 1ns / 1ps

module NumberConverter (
    input  [7:0] binary_in,               // 8-bit input
    input  [1:0] mode,                    // Mode: 00=binary, 01=hex, 10=BCD input
    output reg [7:0] binary_out,          // Output as binary value
    output [7:0] hex_out_combined,        // Combined 8-bit Hex output
    output reg [11:0] bcd_out_decimal     // BCD output: {hundreds, tens, units}
);

    // Combine hex nibbles into one 8-bit hex output
    assign hex_out_combined = binary_in;

    // Internal variables for BCD conversion
    integer i;
    reg [19:0] shift_reg;
    reg [3:0] hundreds, tens, units;

    always @(*) begin
        binary_out = 8'd0;
        bcd_out_decimal = 12'd0;

        // Clear BCD registers
        hundreds = 4'd0;
        tens     = 4'd0;
        units    = 4'd0;

        case (mode)
            2'b00: begin
                // Binary Input ? Directly assign binary value to binary_out
                binary_out = binary_in;

                // Binary to BCD conversion (Double Dabble)
                shift_reg = 20'd0;
                shift_reg[7:0] = binary_in;

                // Perform Double Dabble BCD conversion
                for (i = 0; i < 8; i = i + 1) begin
                    if (hundreds >= 5) hundreds = hundreds + 3;
                    if (tens >= 5)     tens     = tens + 3;
                    if (units >= 5)    units    = units + 3;

                    hundreds = {hundreds[2:0], tens[3]};
                    tens     = {tens[2:0], units[3]};
                    units    = {units[2:0], shift_reg[7]};
                    shift_reg = shift_reg << 1;
                end

                // Set BCD output
                bcd_out_decimal = {hundreds, tens, units};
            end

            2'b01: begin
                // Hex Input ? Treat it as decimal
                binary_out = binary_in;

                // Binary to BCD conversion (Double Dabble)
                shift_reg = 20'd0;
                shift_reg[7:0] = binary_in;

                // Perform Double Dabble BCD conversion
                for (i = 0; i < 8; i = i + 1) begin
                    if (hundreds >= 5) hundreds = hundreds + 3;
                    if (tens >= 5)     tens     = tens + 3;
                    if (units >= 5)    units    = units + 3;

                    hundreds = {hundreds[2:0], tens[3]};
                    tens     = {tens[2:0], units[3]};
                    units    = {units[2:0], shift_reg[7]};
                    shift_reg = shift_reg << 1;
                end

                // Set BCD output
                bcd_out_decimal = {hundreds, tens, units};
            end

            2'b10: begin
                // BCD Input ? Convert to binary
                binary_out = (binary_in[7:4] * 10) + binary_in[3:0];
                bcd_out_decimal = {4'd0, binary_in[7:4], binary_in[3:0]};
            end

            default: begin
                binary_out = 8'd0;
                bcd_out_decimal = 12'd0;
            end
        endcase
    end

endmodule

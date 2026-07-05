`timescale 1ns / 1ps

module tb_NumberConverter;

    // Inputs
    reg  [7:0] binary_in;
    reg  [1:0] mode;

    // Outputs
    wire [7:0] binary_out;
    wire [7:0] hex_out_combined;
    wire [11:0] bcd_out_decimal;

    // Instantiate the Unit Under Test (UUT)
    NumberConverter uut (
        .binary_in(binary_in),
        .mode(mode),
        .binary_out(binary_out),
        .hex_out_combined(hex_out_combined),
        .bcd_out_decimal(bcd_out_decimal)
    );

    initial begin
        $display(">> Running NumberConverter Tests...");
        $display(">> Format: Time | Mode | Input | Binary Out (Binary) | Hex Out | BCD (H T U)");

        // Monitor the results with binary output displayed as a binary value
        $monitor("Time: %0t | Mode: %b | In: %b (%d) | BinOut: %b | Hex: %h | BCD: %0d%0d%0d",
                  $time, mode, binary_in, binary_in,
                  binary_out, hex_out_combined,
                  bcd_out_decimal[11:8], bcd_out_decimal[7:4], bcd_out_decimal[3:0]);

        // Test 1 - Binary Input (Mode 00)
        mode = 2'b00;
        binary_in = 8'd99;     // Binary = 99 ? Hex: 0x63 ? BCD: 099
        #10;

        // Test 2 - Hex Input (Mode 01)
        mode = 2'b01;
        binary_in = 8'h2A;     // Hex 2A = 42 ? BCD: 042
        #10;

        // Test 3 - Hex Input (Mode 01)
        mode = 2'b01;
        binary_in = 8'hFF;     // Hex FF = 255 ? BCD: 255
        #10;

        // Test 4 - BCD Input (Mode 10)
        mode = 2'b10;
        binary_in = 8'b01000001; // BCD for 41 (4 tens, 1 units)
        #10;

        // Test 5 - BCD Input (Mode 10)
        mode = 2'b10;
        binary_in = 8'b10011000; // BCD for 98 (9 tens, 8 units)
        #10;

        // Test 6 - BCD Input (Mode 10)
        mode = 2'b10;
        binary_in = 8'b00011001; // BCD for 19 (1 tens, 9 units)
        #10;

        // Test 7 - Invalid Mode (Mode 11)
        mode = 2'b11;
        binary_in = 8'd255;     // Should output zeros
        #10;

        $stop;
    end

endmodule

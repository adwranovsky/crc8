`default_nettype none

/*
 * A 256 byte long ROM to hold the CRC table
 */
module crc_table #(
    POLYNOMIAL=8'h07
) (
    input wire clk_i,
    input wire [7:0] addr_i,
    output wire [7:0] value_o
);
    // Instantiate a ROM
    reg [7:0] rom [0:255];
    reg [7:0] rom_data_out;
    wire rom_en;
    assign rom_en = 1;
    always @(posedge clk_i) begin
        if (rom_en) begin
            rom_data_out <= rom[addr_i];
        end
    end
    assign value_o = rom_data_out;

    // Fill the ROM with the CRC table for this polynomial
    integer i, bit_num;
    reg [8:0] actual_polynomial, table_entry;
    initial begin
        // Add the implied 1 to the beginning of the polynomial
        actual_polynomial = {1'b1, POLYNOMIAL[7:0]};
        for (i = 0; i < 256; i = i+1) begin
            // For each possible value in the table entry, divide it by the polynomial and then store it in the table
            table_entry = i[8:0];
            for (bit_num = 0; bit_num < 8; bit_num = bit_num+1) begin
                table_entry = {table_entry[7:0], 1'b0};
                if (table_entry[8]) begin
                    table_entry = table_entry ^ actual_polynomial;
                end
            end
            rom[i] = table_entry[7:0];
        end
    end
endmodule

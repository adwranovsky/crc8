`default_nettype none

/*
 * A 256 byte long ROM to hold the CRC table
 */
module crc_table #(
    POLYNOMIAL=8'h07
) (
    input wire clk_i,
    input wire [7:0] addr_i,
    output wire value
);
    // Instantiate a ROM
    reg [7:0] rom [0:255];
    reg [7:0] rom_addr;
    reg [7:0] rom_data_out;
    reg rom_en;
    assign rom_en = 1;
    always @(posedge clk_i) begin
        if (rom_en) begin
            rom_data_out <= rom[addr_i];
        end
    end
    assign value = rom_data_out;

    // Fill the ROM with the CRC table for this polynomial
    integer i, bit_num, actual_polynomial, table_entry;
    initial begin
        // Add the implied 1 to the beginning of the polynomial
        actual_polynomial = {2'b01, POLYNOMIAL[7:0]};
        for (i = 0; i < 256; i = i+1) begin
            // For each possible value in the table entry, divide it by the polynomial and then store it in the table
            table_entry = i;
            for (bit_num = 0; bit_num < 8; bit_num = bit_num+1) begin
                table_entry = {table_entry, 0};
                if (table_entry[7]) begin
                    table_entry = table_entry ^ actual_polynomial;
                end
            end
            rom[i] = table_entry;
        end
    end
endmodule

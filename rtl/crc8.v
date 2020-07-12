`default_nettype none

/*
 * crc8 -- Calculates the crc8 value for a stream of bytes using a static polynomial.
 *
 * clk_i -- Input clock
 * rst_i -- Resets the internal crc value. Set high to start calculating the crc8 value for a new stream of data. This
 *          signal is synchronus to the clock.
 * data_i -- The input data stream
 * data_valid_i -- Indicates that the data_i signal is valid, and that the CRC value should be recalculated
 * crc_o -- The current computed CRC-8 value for the data stream. It is updated one clock cycle after data_valid_i goes
 *          high.
 */
module crc8 #(
    POLYNOMIAL=8'h07
) (
    input wire clk_i,
    input wire rst_i,
    input wire [7:0] data_i,
    input wire data_valid_i,
    output wire [7:0] crc_o
);

reg [7:0] crc_save, crc_xor_data, table_out;
reg data_valid_last_cycle;
initial {data_valid_last_cycle, crc_save} = 0;

always @(posedge clk_i)
    if (rst_i)
        data_valid_last_cycle <= 0;
    else
        data_valid_last_cycle <= data_valid_i;

crc_table #(
    .POLYNOMIAL(POLYNOMIAL)
) crc_table (
    .clk_i(clk_i),
    .addr_i(crc_xor_data),
    .value(table_out)
);

assign crc_xor_data = crc_o ^ data_i;
always @(posedge clk_i)
    if (rst_i)
        crc_save <= 0;
    else
        if (data_valid_last_cycle)
            crc_save <= table_out;
        else
            crc_save <= crc_save;

assign crc_o = data_valid_last_cycle? table_out : crc_save;

endmodule

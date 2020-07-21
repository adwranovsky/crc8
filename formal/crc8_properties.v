`default_nettype none

module crc8_properties #(
    POLYNOMIAL = 8'h07
)(
    wire clk_i,
    wire rst_i,
    wire [7:0] data_o,
    wire data_valid_o,
    wire [7:0] crc_i
);

// Check if the $past() function is valid
reg f_past_valid;
initial f_past_valid = 1'b0;
always @(posedge clk)
    f_past_valid <= 1'b1;

// Ensure that a reset sets the CRC value to 0
always @(posedge clk)
    if (rst_i)
        assert(crc_i == 8'b0);
endmodule

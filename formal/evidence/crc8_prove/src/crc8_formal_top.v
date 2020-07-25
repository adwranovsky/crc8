`default_nettype none

module crc8_formal_top;

localparam POLYNOMIAL = 8'h07;

wire clk;
wire rst;
wire [7:0] data;
wire data_valid;
wire [7:0] crc;

crc8 #(
    .POLYNOMIAL(POLYNOMIAL)
) dut (
    .clk_i(clk),
    .rst_i(rst),
    .data_i(data),
    .data_valid_i(data_valid),
    .crc_o(crc)
);

crc8_properties #(
    .POLYNOMIAL(POLYNOMIAL)
) formal_properties (
    .clk_i(clk),
    .rst_i(rst),
    .data_o(data),
    .data_valid_o(data_valid),
    .crc_i(crc)
);

endmodule

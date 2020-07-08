`default_nettype none

module crc8 #(
    POLYNOMIAL=8'h07
) (
    input wire clk_i,
    input wire rst_i,
    input wire data_i,
    input wire data_valid_i,
    output wire crc_o
);

always @(posedge clk_i)
    if (rst_i) begin
    end else begin
    end

endmodule

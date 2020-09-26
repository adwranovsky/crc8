`default_nettype none

module crc8_properties #(
    POLYNOMIAL = 8'h07
)(
    input wire clk_i,
    input wire rst_i,
    output wire [7:0] data_o,
    output wire data_valid_o,
    input wire [7:0] crc_i
);

// Calculates what the next crc8 value should be from the current value and the next data byte input to the system.
function [7:0] next_crc8(
    input [7:0] old_crc,
    input [7:0] data_byte
);
    integer crc, i;
    crc = old_crc ^ data_byte;
    for (i = 0; i < 8; i = i+1) begin
        crc = crc << 1;
        if (crc[8] == 1'b1) begin
            crc = crc[7:0] ^ POLYNOMIAL;
        end
    end
    next_crc8 = crc[7:0];
endfunction

// Keep track of what we think the crc value should be
reg [7:0] f_crc8;
initial f_crc8 = 0;
always @(posedge clk_i)
    if (rst_i)
        f_crc8 <= 0;
    else if (data_valid_o)
        f_crc8 <= next_crc8(f_crc8, data_o);

// Ensure that the crc8 value matches what we think it should be
always @(*)
    assert(f_crc8 == crc_i);

endmodule

`default_nettype wire

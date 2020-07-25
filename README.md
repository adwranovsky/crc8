# crc8
A formally-proven [FuseSoC](https://fusesoc.readthedocs.io/en/master/index.html) Verilog core for calculating the CRC-8
value on a stream of bytes.

## Core Interface
```Verilog
module crc8 #(
    POLYNOMIAL=8'h07
) (
    input wire clk_i,
    input wire rst_i,
    input wire [7:0] data_i,
    input wire data_valid_i,
    output wire [7:0] crc_o
);
```

## Usage
### Parameters
#### POLYNOMIAL
The CRC-8 polynomial to use. Bit 9 is assumed to be 1, so only the first 8 bits need to be provided.

### Signals
#### clk_i
The input clock signal.
#### rst_i
A synchronous, active-high reset signal. Use to reset `crc_o` back to 0.
#### data_i
The byte stream to compute the CRC-8 value of.
#### data_valid_i
Strobe this signal high to indicate that the current value on `data_i` is valid.
#### crc_o
The current CRC-8 signal computed for the byte stream. It is updated the clock cycle following `data_valid_i` going
high, and is reset the clock cycle after `rst_i` going high.

## Running The Formal Proof
The formal proof requires that [SymbiYosys](https://symbiyosys.readthedocs.io/en/latest/) is installed, using
[yices2](https://yices.csl.sri.com/) as the backend. To prove all polynomials:
```bash
cd formal
./prove_all_polynomials.sh
```

Alternatively, the proof may be run on just one polynomial. As an example, here is how to prove only polynomial `0x07`:
```bash
cd formal
sby crc8.sby polynomial_0x07
```

For more background on formal verification, I recommend checking out the [ZipCPU](https://zipcpu.com) blog. It is where
I first learned about formal verification, and there is an excellent formal training lesson available for free.

## Simulations
Currently, only a simulation that dumps the CRC lookup table is provided.
[Verilator](https://www.veripool.org/wiki/verilator) and [FuseSoC](https://fusesoc.readthedocs.io/en/master/index.html)
are required to run the simulation.
```bash
fusesoc --cores-root . run --target=rom_dump_tb adwranovsky::crc8
```

## Implementation Notes
This module uses a lookup table to compute the polynomial division. Therefore, at least 256 bytes of block RAM or ROM
are needed. See the `crc_table.v` module for more details on how this is inferred.

I also have yet to synthesize this module, though I plan to in a project in the near future. This note will be removed
when that gets done.

## License
This project is licensed under the Open Hardware Description License (OHDL). For details, please see the LICENSE file.

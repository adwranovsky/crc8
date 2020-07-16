#!/usr/bin/env python3
"""
An example CRC calculator, used for verifying the RTL representation, and also to aid in my own understanding of how CRC
works. I intended for this to use any CRC width, but right now the table generation only works with crc-8.
"""
import math
import sys
from functools import lru_cache
from typing import List

@lru_cache()
def crc_table(crc_bits: int, generator_polynomial: int) -> dict:
    """
    Returns the lookup table as a dict for the given generator polynomial.

    Parameters:
        crc_bits - The number of bits in the generator polynomial. Should be a
            power of 2.
        generator_polynomial - The polynomial to use, where each bit is a
            factor, ommitting the top bit since it is assumed to be 1. For
            example, if using a polynomial of
                1*x^8 + 0*x^7 + 0*x^6 + 0*x^5 + 1*x^4 + 1*x^3 + 1*x^2 + 0*x + 1
            the parameter passed in would be
                b00011101 = 0x1D

    """
    # Argument checking...
    assert isinstance(crc_bits, int) and crc_bits > 0 and math.log2(crc_bits).is_integer()
    assert isinstance(generator_polynomial, int) and generator_polynomial.bit_length() <= crc_bits

    # Add the implied top bit to the generator polynomial
    generator_polynomial |= 1 << crc_bits

    # For every possible divident, divide the divident by the generator polynomial, and store the result in the table
    table = {}
    for divident in range(2**crc_bits):
        current_byte = divident
        for _bit_num in range(8):
            if current_byte & 0x80 != 0:
                current_byte <<= 1
                current_byte ^= generator_polynomial
            else:
                current_byte <<= 1
        table[divident] = current_byte
    return table

def print_crc_table(crc_bits: int, generator_polynomial: int):
    """
    Print the CRC table for a given generator polynomial
    """
    print("\n".join(f"0x{k:x}: 0x{v:x}" for k, v in crc_table(crc_bits, generator_polynomial).items()))

def compute_crc(crc_bits: int, generator_polynomial: int, data: List[int]) -> int:
    """
    Returns the CRC value for the data array passed in.
    """
    crc = 0
    for data_byte in data:
        crc ^= data_byte
        crc = crc_table(crc_bits, generator_polynomial)[crc]
    return crc

def main():
    """
    Read in a file and calculate the CRC-8 value for a generator polynomial of 0x1D.
    """
    with open(sys.argv[1], "rb") as file_to_check:
        data = [int(b) for b in file_to_check.read()]
    print("0x{:x}".format(compute_crc(8, 0x07, data)))

if __name__ == "__main__":
    main()

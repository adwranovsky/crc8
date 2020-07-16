#include <stdint.h>
#include <signal.h>
#include <stdio.h>

#include "verilated_vcd_c.h"
#include "Vcrc_table.h"

void tick(Vcrc_table *tb) {
    tb->eval();
    tb->clk_i = 1;
    tb->eval();
    tb->clk_i = 0;
    tb->eval();
}

int main(int argc, const char *argv[]) {
    // Call commandArgs first!
    Verilated::commandArgs(argc, argv);

    // Tell Verilator that we may dump to a VCD file
    Verilated::traceEverOn(true);

    // Instantiate the top module and initialize the inputs
    Vcrc_table *top = new Vcrc_table;
    top->clk_i = 0;
    top->addr_i = 0;

    // Flush out the first few clock cycles
    for (int i = 0; i < 3; i++)
        tick(top);

    // Note to self: do rom dump testbench next to get a hang for verilator with fusesoc. After that do formal
    // verification of the crc8 core.
    printf("Address Value\n");
    for (int addr = 0; addr < 0x100; addr++) {
        top->addr_i = addr;
        tick(top);
        printf("0x%x 0x%x\n", addr, top->value_o);
    }
    return 0;
}

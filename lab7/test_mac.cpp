// DESCRIPTION:  simulation of mac 
//======================================================================
#include <iostream>
#include <stdint.h> 

// Include common routines
#include <verilated.h>
// Include model header, generated from Verilating "mac.v"
#include "Vmac.h"
#include "Vmac__Syms.h"

#ifdef VCD_OUTPUT
#include <verilated_vcd_c.h>
#endif

#define RUN_CYCLES 100000

#define CLOCK_PERIOD 2

#define RESET_TIME  10

// Current simulation time (64-bit unsigned)
uint64_t timestamp = 0;

double sc_time_stamp() { 
  return timestamp;
}

int main(int argc, char** argv, char** env) {
    // turn off unused variable warnings
    if (0 && argc && argv && env) {}

    // Construct the Verilated model
    Vmac* dut = new Vmac();

#ifdef VCD_OUTPUT
    Verilated::traceEverOn(true);
    auto trace = new VerilatedVcdC();
    dut->trace(trace, 2999);
    trace->open("trace.vcd");
#endif

#ifdef DPRINTF
    uint64_t timestamp_WB = 0;
#endif

    dut->clk = 0;
    dut->rst = 0;

    while (timestamp < RUN_CYCLES) {      
        bool clk_transition = (timestamp % CLOCK_PERIOD) == 0;
        if (clk_transition) 
            dut->clk = !dut->clk; 

        if (timestamp > 1 && timestamp < RESET_TIME) {
            dut->rst = 1;  // Assert reset
        } else {
            dut->rst = 0;  // Deassert reset
        }
        
        // Evaluate model
        dut->eval();

        // Verilator allows to access verilator public data structure
        if (clk_transition && dut->clk) {
            
            dut -> col_data_in = uint8_t(timestamp % 12);
            dut -> row_data_in = uint8_t((timestamp + 3) % 12);
            dut -> bypass_data_in = uint8_t((timestamp + 5) % 12);
            
            if (timestamp % 12 == 0 && timestamp > RESET_TIME){
                dut -> rst_accumulator = 1;
            }
            else if (timestamp % 12 == 1 && timestamp > RESET_TIME){
                dut -> bypass_en = 1;
            }
            else{
                dut -> rst_accumulator = 0;
                dut -> bypass_en = 0;
            }

            timestamp_WB = timestamp - RESET_TIME;            
        }


    #ifdef VCD_OUTPUT
        trace->dump(timestamp);
    #endif
        ++timestamp;
    }

#ifdef DPRINTF
    std::cout << "Cycles=" << (timestamp_WB / 2) << std::endl; 
#endif

    // Final model cleanup
    dut->final();

#ifdef VCD_OUTPUT
    trace->close();
    delete trace;
#endif

    // Destroy DUT
    delete dut;
    // Fin
    exit(0);
}
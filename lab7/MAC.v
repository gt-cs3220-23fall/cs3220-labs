module mac #(
    parameter IN_WIDTH = 8,
    parameter OUT_WIDTH = 8,
    parameter PSUM_DELAY = 3
)(
    input clk,
    input rst,
    input rst_accumulator,
    input bypass_en,

    input [IN_WIDTH-1:0] row_data_in,
    input [IN_WIDTH-1:0] col_data_in,
    input [IN_WIDTH-1:0] bypass_data_in, 
    output reg [IN_WIDTH-1:0] row_data_out,
    output reg [IN_WIDTH-1:0] col_data_out, 
    output reg [OUT_WIDTH-1:0] psum_out
    );

    reg [OUT_WIDTH-1:0] psum [0:PSUM_DELAY];
    reg [OUT_WIDTH-1:0] mult_out;


    //TODO: pass the row data 1 clock cycle later


    //TODO: pass the col data 1 clock cycle later

    //TODO: mult 1 clock cycle later

    //TODO: accumulate 1 clock cycle later


    //TODO: propagate the psum: sync the timing as indicated in the !tutorial report


    //TODO: output the psum; if bypass_en is high, output the bypass_data_in, otherwise output the latest psum

endmodule
module ctrl #(
    parameter IN_WIDTH = 8,
    parameter OUT_WIDTH = 16,
    parameter ARRAY_SIZE = 4,
    parameter MULT_LAT = 1,
    parameter ACC_LAT = 1
)(
    input clk,
    input rst,
    output [ARRAY_SIZE-1:0]bypass_en,
    output [ARRAY_SIZE-1:0]rst_accumulator
);

    wire comparator_out;

    reg [IN_WIDTH-1:0] counter;
    // 1st mac accumulator rst delay 
    reg [MULT_LAT-1:0]rst_accumulator_reg_0; //why -1? the pass from comparator to rst_accumulator_reg_0 is 1 clock cycle
    reg [ARRAY_SIZE-2:0]rst_accumulator_reg_1_to_rest;


    //conifgure conuter
    always @(posedge clk) begin
        if (rst) begin
            counter <= 0;
        end
        else if (counter == ARRAY_SIZE-1) begin
            counter <= 0;
        end
        else begin
            counter <= counter + 1;
        end
    end

    // making sure full array cycles is went through for the 1st run after reset
    assign comparator_out = (counter == 1);

    //TODO: rst accumulator logic

    
    //TODO: consider multiplier latency


    //TODO: rst for different columns


    //TODO: by pass logic 1 cycle before ~rst_accumulator

endmodule
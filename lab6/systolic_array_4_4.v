module systolic_array #(
    parameter IN_WIDTH = 8,
    parameter OUT_WIDTH = 8,
    parameter MULT_LAT = 1,
    parameter ACC_LAT = 1,
    parameter ARRAY_SIZE = 4
)(
    input clk,
    input rst,
    input [IN_WIDTH*ARRAY_SIZE-1:0] row_data_in,
    input [IN_WIDTH*ARRAY_SIZE-1:0] col_data_in,
    output [OUT_WIDTH*ARRAY_SIZE-1:0] row_data_out
);
    // rst_accumulator for different rows 
    // 1st row
    wire[ARRAY_SIZE-1:0] rst_accumulator_0;
    // the rest of the rows
    reg [ARRAY_SIZE-1:0] rst_accumulator_reg [0:ARRAY_SIZE-1];

    // bypass_en for different rows
    wire [ARRAY_SIZE-1:0] bypass_en;


    // data for macs
    wire [IN_WIDTH-1:0] mac_row_data_in_0 [0:ARRAY_SIZE-1];
    wire [IN_WIDTH-1:0] mac_row_data_in_1 [0:ARRAY_SIZE-1];
    wire [IN_WIDTH-1:0] mac_row_data_in_2 [0:ARRAY_SIZE-1];
    wire [IN_WIDTH-1:0] mac_row_data_in_3 [0:ARRAY_SIZE-1];

    wire [IN_WIDTH-1:0] mac_col_data_in_0 [0:ARRAY_SIZE-1];
    wire [IN_WIDTH-1:0] mac_col_data_in_1 [0:ARRAY_SIZE-1];
    wire [IN_WIDTH-1:0] mac_col_data_in_2 [0:ARRAY_SIZE-1];
    wire [IN_WIDTH-1:0] mac_col_data_in_3 [0:ARRAY_SIZE-1];

    //assign 1st row data
    assign mac_row_data_in_0[0] = row_data_in[IN_WIDTH*0 +: IN_WIDTH];
    assign mac_row_data_in_0[1] = row_data_in[IN_WIDTH*1 +: IN_WIDTH];
    assign mac_row_data_in_0[2] = row_data_in[IN_WIDTH*2 +: IN_WIDTH];
    assign mac_row_data_in_0[3] = row_data_in[IN_WIDTH*3 +: IN_WIDTH];

    //assign 1st column data
    assign mac_col_data_in_0[0] = col_data_in[IN_WIDTH*0 +: IN_WIDTH];
    assign mac_col_data_in_0[1] = col_data_in[IN_WIDTH*1 +: IN_WIDTH];
    assign mac_col_data_in_0[2] = col_data_in[IN_WIDTH*2 +: IN_WIDTH];
    assign mac_col_data_in_0[3] = col_data_in[IN_WIDTH*3 +: IN_WIDTH];

     
    // manual code 4x4 array ... easier to understand and debug

    /*
    1st row
    */

    // 1st row 1st column
    wire [IN_WIDTH-1:0] bypass_data_in_0_0;
    mac #(
        .IN_WIDTH(IN_WIDTH),
        .OUT_WIDTH(OUT_WIDTH),
        .PSUM_DELAY(ARRAY_SIZE - 0 - 1)
    ) mac_0_0 (
        .clk(clk),
        .rst(rst),
        .rst_accumulator(rst_accumulator_0[0]),
        .bypass_en(bypass_en[0]),
        .row_data_in(mac_row_data_in_0[0]),
        .col_data_in(mac_col_data_in_0[0]),
        .bypass_data_in(bypass_data_in_0_0),
        .row_data_out(mac_row_data_in_1[0]),
        .col_data_out(mac_col_data_in_1[0]),
        .psum_out(row_data_out[OUT_WIDTH*0 +: OUT_WIDTH])
    );


    // 1st row 2nd column
    wire [IN_WIDTH-1:0] bypass_data_in_0_1;
    mac #(
        .IN_WIDTH(IN_WIDTH),
        .OUT_WIDTH(OUT_WIDTH),
        .PSUM_DELAY(ARRAY_SIZE - 1 - 1)
    ) mac_0_1 (
        .clk(clk),
        .rst(rst),
        .rst_accumulator(rst_accumulator_0[1]),
        .bypass_en(bypass_en[0]),
        .row_data_in(mac_row_data_in_1[0]),
        .col_data_in(mac_col_data_in_0[1]),
        .bypass_data_in(bypass_data_in_0_1),
        .row_data_out(mac_row_data_in_2[0]),
        .col_data_out(mac_col_data_in_1[1]),
        .psum_out(bypass_data_in_0_0)
    );

    // 1st row 3rd column
    wire [IN_WIDTH-1:0] bypass_data_in_0_2;
    mac #(
        .IN_WIDTH(IN_WIDTH),
        .OUT_WIDTH(OUT_WIDTH),
        .PSUM_DELAY(ARRAY_SIZE - 2 - 1)
    ) mac_0_2 (
        .clk(clk),
        .rst(rst),
        .rst_accumulator(rst_accumulator_0[2]),
        .bypass_en(bypass_en[0]),
        .row_data_in(mac_row_data_in_2[0]),
        .col_data_in(mac_col_data_in_0[2]),
        .bypass_data_in(bypass_data_in_0_2),
        .row_data_out(mac_row_data_in_3[0]),
        .col_data_out(mac_col_data_in_1[2]),
        .psum_out(bypass_data_in_0_1)
    );

    // 1st row 4th column
    mac #(
        .IN_WIDTH(IN_WIDTH),
        .OUT_WIDTH(OUT_WIDTH),
        .PSUM_DELAY(ARRAY_SIZE - 3 - 1)
    ) mac_0_3 (
        .clk(clk),
        .rst(rst),
        .rst_accumulator(rst_accumulator_0[3]),
        .bypass_en(1'b0),
        .row_data_in(mac_row_data_in_3[0]),
        .col_data_in(mac_col_data_in_0[3]),
        .bypass_data_in(),
        .row_data_out(),
        .col_data_out(mac_col_data_in_1[3]),
        .psum_out(bypass_data_in_0_2)
    );

    /*
    2nd row
    */

    // 2nd row 1st column
    wire [IN_WIDTH-1:0] bypass_data_in_1_0;
    mac #(
        .IN_WIDTH(IN_WIDTH),
        .OUT_WIDTH(OUT_WIDTH),
        .PSUM_DELAY(ARRAY_SIZE - 0 - 1)
    ) mac_1_0 (
        .clk(clk),
        .rst(rst),
        .rst_accumulator(rst_accumulator_reg[1][0]),
        .bypass_en(bypass_en[1]),
        .row_data_in(mac_row_data_in_0[1]),
        .col_data_in(mac_col_data_in_1[0]),
        .bypass_data_in(bypass_data_in_1_0),
        .row_data_out(mac_row_data_in_1[1]),
        .col_data_out(mac_col_data_in_2[0]),
        .psum_out(row_data_out[OUT_WIDTH*1 +: OUT_WIDTH])
    );

    // 2nd row 2nd column
    wire [IN_WIDTH-1:0] bypass_data_in_1_1;
    mac #(
        .IN_WIDTH(IN_WIDTH),
        .OUT_WIDTH(OUT_WIDTH),
        .PSUM_DELAY(ARRAY_SIZE - 1 - 1)
    ) mac_1_1 (
        .clk(clk),
        .rst(rst),
        .rst_accumulator(rst_accumulator_reg[1][1]),
        .bypass_en(bypass_en[1]),
        .row_data_in(mac_row_data_in_1[1]),
        .col_data_in(mac_col_data_in_1[1]),
        .bypass_data_in(bypass_data_in_1_1),
        .row_data_out(mac_row_data_in_2[1]),
        .col_data_out(mac_col_data_in_2[1]),
        .psum_out(bypass_data_in_1_0)
    );

    // 2nd row 3rd column
    wire [IN_WIDTH-1:0] bypass_data_in_1_2;
    mac #(
        .IN_WIDTH(IN_WIDTH),
        .OUT_WIDTH(OUT_WIDTH),
        .PSUM_DELAY(ARRAY_SIZE - 2 - 1)
    ) mac_1_2 (
        .clk(clk),
        .rst(rst),
        .rst_accumulator(rst_accumulator_reg[1][2]),
        .bypass_en(bypass_en[1]),
        .row_data_in(mac_row_data_in_2[1]),
        .col_data_in(mac_col_data_in_1[2]),
        .bypass_data_in(bypass_data_in_1_2),
        .row_data_out(mac_row_data_in_3[1]),
        .col_data_out(mac_col_data_in_2[2]),
        .psum_out(bypass_data_in_1_1)
    );

    // 2nd row 4th column
    mac #(
        .IN_WIDTH(IN_WIDTH),
        .OUT_WIDTH(OUT_WIDTH),
        .PSUM_DELAY(ARRAY_SIZE - 3 - 1)
    ) mac_1_3 (
        .clk(clk),
        .rst(rst),
        .rst_accumulator(rst_accumulator_reg[1][3]),
        .bypass_en(1'b0),
        .row_data_in(mac_row_data_in_3[1]),
        .col_data_in(mac_col_data_in_1[3]),
        .bypass_data_in(),
        .row_data_out(),
        .col_data_out(mac_col_data_in_2[3]),
        .psum_out(bypass_data_in_1_2)
    );


    /*
    3rd row
    */

    // 3rd row 1st column
    wire [IN_WIDTH-1:0] bypass_data_in_2_0;
    mac #(
        .IN_WIDTH(IN_WIDTH),
        .OUT_WIDTH(OUT_WIDTH),
        .PSUM_DELAY(ARRAY_SIZE - 0 - 1)
    ) mac_2_0 (
        .clk(clk),
        .rst(rst),
        .rst_accumulator(rst_accumulator_reg[2][0]),
        .bypass_en(bypass_en[2]),
        .row_data_in(mac_row_data_in_0[2]),
        .col_data_in(mac_col_data_in_2[0]),
        .bypass_data_in(bypass_data_in_2_0),
        .row_data_out(mac_row_data_in_1[2]),
        .col_data_out(mac_col_data_in_3[0]),
        .psum_out(row_data_out[OUT_WIDTH*2 +: OUT_WIDTH])
    );

    // 3rd row 2nd column
    wire [IN_WIDTH-1:0] bypass_data_in_2_1;
    mac #(
        .IN_WIDTH(IN_WIDTH),
        .OUT_WIDTH(OUT_WIDTH),
        .PSUM_DELAY(ARRAY_SIZE - 1 - 1)
    ) mac_2_1 (
        .clk(clk),
        .rst(rst),
        .rst_accumulator(rst_accumulator_reg[2][1]),
        .bypass_en(bypass_en[2]),
        .row_data_in(mac_row_data_in_1[2]),
        .col_data_in(mac_col_data_in_2[1]),
        .bypass_data_in(bypass_data_in_2_1),
        .row_data_out(mac_row_data_in_2[2]),
        .col_data_out(mac_col_data_in_3[1]),
        .psum_out(bypass_data_in_2_0)
    );

    // 3rd row 3rd column
    wire [IN_WIDTH-1:0] bypass_data_in_2_2;
    mac #(
        .IN_WIDTH(IN_WIDTH),
        .OUT_WIDTH(OUT_WIDTH),
        .PSUM_DELAY(ARRAY_SIZE - 2 - 1)
    ) mac_2_2 (
        .clk(clk),
        .rst(rst),
        .rst_accumulator(rst_accumulator_reg[2][2]),
        .bypass_en(bypass_en[2]),
        .row_data_in(mac_row_data_in_2[2]),
        .col_data_in(mac_col_data_in_2[2]),
        .bypass_data_in(bypass_data_in_2_2),
        .row_data_out(mac_row_data_in_3[2]),
        .col_data_out(mac_col_data_in_3[2]),
        .psum_out(bypass_data_in_2_1)
    );

    // 3rd row 4th column
    mac #(
        .IN_WIDTH(IN_WIDTH),
        .OUT_WIDTH(OUT_WIDTH),
        .PSUM_DELAY(ARRAY_SIZE - 3 - 1)
    ) mac_2_3 (
        .clk(clk),
        .rst(rst),
        .rst_accumulator(rst_accumulator_reg[2][3]),
        .bypass_en(1'b0),
        .row_data_in(mac_row_data_in_3[2]),
        .col_data_in(mac_col_data_in_2[3]),
        .bypass_data_in(),
        .row_data_out(),
        .col_data_out(mac_col_data_in_3[3]),
        .psum_out(bypass_data_in_2_2)
    );

    /*
    4th row
    */

    // 4th row 1st column
    wire [IN_WIDTH-1:0] bypass_data_in_3_0;
    mac #(
        .IN_WIDTH(IN_WIDTH),
        .OUT_WIDTH(OUT_WIDTH),
        .PSUM_DELAY(ARRAY_SIZE - 0 - 1)
    ) mac_3_0 (
        .clk(clk),
        .rst(rst),
        .rst_accumulator(rst_accumulator_reg[3][0]),
        .bypass_en(bypass_en[3]),
        .row_data_in(mac_row_data_in_0[3]),
        .col_data_in(mac_col_data_in_3[0]),
        .bypass_data_in(bypass_data_in_3_0),
        .row_data_out(mac_row_data_in_1[3]),
        .col_data_out(),
        .psum_out(row_data_out[OUT_WIDTH*3 +: OUT_WIDTH])
    );

    // 4th row 2nd column
    wire [IN_WIDTH-1:0] bypass_data_in_3_1;
    mac #(
        .IN_WIDTH(IN_WIDTH),
        .OUT_WIDTH(OUT_WIDTH),
        .PSUM_DELAY(ARRAY_SIZE - 1 - 1)
    ) mac_3_1 (
        .clk(clk),
        .rst(rst),
        .rst_accumulator(rst_accumulator_reg[3][1]),
        .bypass_en(bypass_en[3]),
        .row_data_in(mac_row_data_in_1[3]),
        .col_data_in(mac_col_data_in_3[1]),
        .bypass_data_in(bypass_data_in_3_1),
        .row_data_out(mac_row_data_in_2[3]),
        .col_data_out(),
        .psum_out(bypass_data_in_3_0)
    );

    // 4th row 3rd column
    wire [IN_WIDTH-1:0] bypass_data_in_3_2;
    mac #(
        .IN_WIDTH(IN_WIDTH),
        .OUT_WIDTH(OUT_WIDTH),
        .PSUM_DELAY(ARRAY_SIZE - 2 - 1)
    ) mac_3_2 (
        .clk(clk),
        .rst(rst),
        .rst_accumulator(rst_accumulator_reg[3][2]),
        .bypass_en(bypass_en[3]),
        .row_data_in(mac_row_data_in_2[3]),
        .col_data_in(mac_col_data_in_3[2]),
        .bypass_data_in(bypass_data_in_3_2),
        .row_data_out(mac_row_data_in_3[3]),
        .col_data_out(),
        .psum_out(bypass_data_in_3_1)
    );

    // 4th row 4th column
    mac #(
        .IN_WIDTH(IN_WIDTH),
        .OUT_WIDTH(OUT_WIDTH),
        .PSUM_DELAY(ARRAY_SIZE - 3 - 1)
    ) mac_3_3 (
        .clk(clk),
        .rst(rst),
        .rst_accumulator(rst_accumulator_reg[3][3]),
        .bypass_en(1'b0),
        .row_data_in(mac_row_data_in_3[3]),
        .col_data_in(mac_col_data_in_3[3]),
        .bypass_data_in(),
        .row_data_out(),
        .col_data_out(),
        .psum_out(bypass_data_in_3_2)
    );



    ctrl #(
        .IN_WIDTH(IN_WIDTH),
        .OUT_WIDTH(OUT_WIDTH),
        .ARRAY_SIZE(ARRAY_SIZE),
        .MULT_LAT(MULT_LAT),
        .ACC_LAT(ACC_LAT)
    ) ctrl_0(
        .clk(clk),
        .rst(rst),
        .bypass_en(bypass_en),
        .rst_accumulator(rst_accumulator_0)
    );

    //rst for different rows
    generate
        genvar m;
        for (m = 1; m < ARRAY_SIZE; m = m + 1) begin: rst_accumulator_out_reg_gen_row
            if(m == 1) begin
                always @(posedge clk) begin
                    if (rst) begin
                        rst_accumulator_reg[m] <= 0;
                    end
                    else begin
                        rst_accumulator_reg[m] <= rst_accumulator_0;
                    end
                end
            end
            else begin
                always @(posedge clk) begin
                    if (rst) begin
                        rst_accumulator_reg[m] <= 0;
                    end
                    else begin
                        rst_accumulator_reg[m] <= rst_accumulator_reg[m-1];
                    end
                end
            end
        end
    endgenerate

endmodule
 `include "define.vh" 

// OP1 and OP2 are 32-bit inputs that specify the values to be used as operands for the ALU operation.
// OP3 is a 32-bit output that holds the result of the ALU operation.
// ALUOP is a 4-bit input that specifies the ALU operation to be performed. The ALUOP values are as follows:
    // 0001: DIV
    // 0010: MULT
    // ALUOP[3] is a 1-bit input that specifies whether the ALU operation is signed or unsigned. If ALUOP[3] is 0, the operation is unsigned; if ALUOP[3] is 1, the operation is signed.
// CSR_ALU_OUT (Control/Status Register) is a 3-bit bidirectional port that represents the status of the ALU operation. The CSR_ALU_OUT values are as follows:
    // CSR_ALU_OUT[0] is a 1-bit output that signals if the ALU OP1 port is READY/BUSY
        // i.e., whether the ALU will be able to latch in your inputs (operands and ALUOP)
    // CSR_ALU_OUT[1] is a 1-bit output that signals if the ALU OP2 port is READY/BUSY
        // i.e., whether the ALU will be able to latch in your inputs (operands and ALUOP)
    // CSR_ALU_OUT[2] is a 1-bit output that signals if the result of the ALU operation is VALID/INVALID
        // 1: VALID; 0: INVALID
// CSR_ALU_IN is a 2-bit output that control the status of the ALU operation. The CSR_ALU_IN values are as follows:
    // CSR_ALU_IN[0] is a 1-bit input that signals the the results can be overwritten by the ALU.
        // After reading the output, the CPU should set CSR_ALU_IN[0] to 0, indicating it's safe for ALU to overwrite the results; otherwise, the ALU will stall the current operation write the result to OP3.
    // CSR_ALU_IN[1] is a 1-bit input that signals the OP1 fed to the ALU is stable
        // If it's set to 1, the ALU will latch in the OP1 value; otherwise, the ALU will stall the current operation and wait for OP1 to be stable.
        // It's ignored if the ALU is not ready to accept OP1.
    // CSR_ALU_IN[2] is a 1-bit input that signals the OP2 fed to the ALU is stable


 module external_alu(
    input clk,
    input rst,
    input [`ALUDATABITS-1:0] OP1,
    input [`ALUDATABITS-1:0] OP2,
    output [`ALUDATABITS-1:0] OP3,
    input [`ALUOPBITS-1:0] ALUOP,
    output [`ALUCSROUTBITS-1:0] CSR_ALU_OUT,
    input [`ALUCSRINBITS-1:0] CSR_ALU_IN
);


wire div_input_a_ack, div_input_b_ack;
wire mult_input_a_ack, mult_input_b_ack;

wire div_output_z_ack;
wire mult_output_z_ack;

wire div_input_a_stb, div_input_b_stb;
wire mult_input_a_stb, mult_input_b_stb;

wire div_output_z_stb;
wire mult_output_z_stb;

wire ALU_ready_1;
wire ALU_ready_2;
wire ALU_resutls_valid;

wire [`ALUDATABITS-1:0] div_output_z;
wire [`ALUDATABITS-1:0] mult_output_z;

// alu state transition from get_a to get_b
assign ALU_ready_1 = (ALUOP == 1) ? (div_input_a_ack ) : (mult_input_a_ack);
assign ALU_ready_2 = (ALUOP == 1) ? (div_input_b_ack ) : (mult_input_b_ack);
assign ALU_resutls_valid = (ALUOP == 1) ? div_output_z_stb : mult_output_z_stb;
assign CSR_ALU_OUT = {ALU_resutls_valid, ALU_ready_2, ALU_ready_1};

assign div_input_a_stb = (ALUOP == 1) ? CSR_ALU_IN[1] : 1'b0;
assign div_input_b_stb = (ALUOP == 1) ? CSR_ALU_IN[2] : 1'b0;
assign mult_input_a_stb = (ALUOP == 2) ? CSR_ALU_IN[1] : 1'b0;
assign mult_input_b_stb = (ALUOP == 2) ? CSR_ALU_IN[2] : 1'b0;


assign div_output_z_ack = (ALUOP == 1) ? CSR_ALU_IN[0] : 1'b0;
assign mult_output_z_ack = (ALUOP == 2) ? CSR_ALU_IN[0] : 1'b0;

assign OP3 = (ALUOP == 1) ? div_output_z : mult_output_z;


divider div0(
        .input_a(OP1),
        .input_b(OP2),
        .input_a_stb(div_input_a_stb),
        .input_b_stb(div_input_b_stb),
        .output_z_ack(div_output_z_ack),
        .clk(clk),
        .rst(rst),
        .output_z(div_output_z),
        .output_z_stb(div_output_z_stb),
        .input_a_ack(div_input_a_ack),
        .input_b_ack(div_input_b_ack)
        );


multiplier mult0(
        .input_a(OP1),
        .input_b(OP2),
        .input_a_stb(mult_input_a_stb),
        .input_b_stb(mult_input_b_stb),
        .output_z_ack(mult_output_z_ack),
        .clk(clk),
        .rst(rst),
        .output_z(mult_output_z),
        .output_z_stb(mult_output_z_stb),
        .input_a_ack(mult_input_a_ack),
        .input_b_ack(mult_input_b_ack)
    );




endmodule
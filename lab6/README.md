# CS3220 Lab #6 : A Case Study of A RISC-V with An External ALU

100 pts in total, will be rescaled into 11.25% of your final score of the course.  

**Part 1: Connect An External ALU with A RISC-V**: 60 pts

**Part 2: Performance Optimization**: 40 pts + 10 bonus pts

***Submission ddl***: Nov 13th

This lab builds upon the knowledge you've gained from previous lectures and labs on RISC-V CPU design, as well as your research into AI accelerator implementations. Specifically, you'll be integrating the RISC-V CPU you designed in earlier labs with an external ALU to enhance its efficiency for certain complex workloads. This is the first in a series of three labs on this topic.

## Part 1: Connect An External ALU with A RISC-V (60 points): 

In this section, you'll integrate the RISC-V CPU you designed in Lab #2 with a supplied external ALU. Your responsibility is to adjust the RISC-V implementation to accommodate the external ALU's operations and verify that the RISC-V CPU can accurately run the given test cases.

The [external ALU](links/to/alu) has following specifications:
<!-- * `OPREG1`, `OPREG2`, and `OPREG3` are 5-bit inputs that specify the registers to be used as operands for the ALU operation.
    * 4 registers for each of them; in total 12 registers -->
* `OP1` and `OP2` are 32-bit inputs that specify the values to be used as operands for the ALU operation.
* `OP3` is a 32-bit output that holds the result of the ALU operation.
* `ALUOP` is a 4-bit input that specifies the ALU operation to be performed. The ALUOP values are as follows:
    * 0000: EXP
    * 0001: DIV
    * `ALUOP[3]` is a 1-bit input that specifies whether the ALU operation is signed or unsigned. If `ALUOP[3]` is 0, the operation is unsigned; if `ALUOP[3]` is 1, the operation is signed.
* `CSR_ALU` (Control/Status Register) is a 3-bit bidirectional port that specifies/control the status of the ALU operation. The `CSR_ALU` values are as follows:
    * `CSR_ALU[0]` is a 1-bit output that signals if the ALU is READY/BUSY
        * i.e., whether the ALU will be able to latch in your inputs (operands and ALUOP)
    * `CSR_ALU[1]` is a 1-bit input/output that signals if the result of the ALU operation is VALID/INVALID
        * 1: VALID; 0: INVALID
        * After reading the output, the CPU should set `CSR_ALU[1]` to 0, indicating it's safe for ALU to overwrite the results; otherwise, the ALU will stall the current operation write the result to `OP3`.
    * `CSR_ALU[2]` is a 1-bit input that signals the ALU ready to start the operation. When `CSR_ALU[2]` is 1, the ALU starts the operation. When `CSR_ALU[2]` is 0, the ALU stays idle.
        * i.e., whether the data in `OP1`, `OP2`, `OP3`, and `ALUOP` are valid
        * If `CSR_ALU[2]` is set to 1 while the ALU is busy, the ALU will ignore the request and continue the current operation.


The specifications from RISC-V CPU is as follows:

1. For loading the operands, we will use LW instructions, to load the operands from the memory, with dst reg ID:
    * xxx: OP1
    * yyy: OP2
    * zzz: OP3
2. For loading the `ALUOP` to configure the ALU, we will use LUI instructions, with dst reg ID
    * 111: ALUOP
3. For reading the result/status from the ALU, we will use SW instructions, with src reg ID
    * xxx: OP3
    * xxx: CSR
4. Intended instruction sequence:
    * load OP1, OP2, OP3
    * load ALUOP (start the computation as ALUOP loaded)
    * store OP3, (CSR: optional)



Your tasks are as follows:
1. Integrate the ALU with the RISC-V CPU. You will need to modify the RISC-V CPU to accommodate the ALU's operations.
2. Adding stall logic in CPU as to cover different instruction combinations passed to ALU.
    * e.g., the operands is loaded but ALU is not ready.

To pass this part and earn full credit, implement the integration described above and run your implementation on [alutest0.mem](/test/part5/alutest0.mem) and ensure it passes this testcase.




## Part 2: Performance Optimization (40 points + 10 bonus pts)
As the current ALU uses separate hardware logic (units) to implement different operations, it is possible to overlap the execution of different operations, as long as the requested unit is not busy. For example, if the ALU is currently executing an EXP operation, it is possible to start a DIV operation, as long as the DIV unit is not busy. 

To support such instruction level parallelism, we will need to:
* Add additional sets of registers to store the operands from the different instructions:
    * `OPREG1`, `OPREG2`, and `OPREG3` are 5-bit inputs that specify the registers to be used as operands for the ALU operation.
        * 4 registers for each of them; in total 12 registers
    * `OP1`, `OP2`, and `OP3` will be latched from/into registers indexed by `OPREG1`, `OPREG2` and `OPREG3` respectively.
* Modify the busy status such that the ALU is busy only when all the units are busy or no register is left to store the operands.
* Add additional control logic decide which registers to use for the operands and subsequently, which registers the unit should read/write to.
* We currently assume in-order executiong; then we need to sensure `OP3` is being written to in the same order as the input instructions.

Intended instruction sequence (your implementation should also work with the instruction sequence in Part 1):
* load OP1, OP2, OP3
* load ALUOP (start the computation as ALUOP loaded)
* load OP1, OP2, OP3
* load ALUOP (start the computation as ALUOP loaded)
* load OP1, OP2, OP3
* load ALUOP (start the computation as ALUOP loaded)
* store OP3, (CSR: optional)
* store OP3, (CSR: optional)
* store OP3, (CSR: optional)

Modify [external ALU](links/to/alu) to support the above modifications, and pass [alutest1.mem](/test/part5/alutest1.mem). 

Bonus points: 

Support the following instruction sequence to pass [alutest2.mem](/test/part5/alutest2.mem) (your implementation should also work with the instruction sequence in Part 1 & 2)
* load OP1, OP2, OP3
* load OP1, OP2, OP3
* load OP1, OP2, OP3
* load ALUOP (start the computation as ALUOP loaded)
* load ALUOP (start the computation as ALUOP loaded)
* load ALUOP (start the computation as ALUOP loaded)
* store OP3, (CSR: optional)
* store OP3, (CSR: optional)
* store OP3, (CSR: optional)
    

## Submission

+ Provide a zip file containing your source code. Generate the submission.zip file using the command make submit. Avoid manual zip file creation to prevent any issues with the autograding script, which could lead to a 30% score deduction.
* Late submission policy: 3 hours grace period for potential canvas submission issues; 10% per day late, up to 3 days. No credit will be given for submissions later than 3 days.




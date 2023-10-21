# CS3220 Lab #5 : A Case Study of A RISC-V with An External ALU

100 pts in total, will be rescaled into 11.25% of your final score of the course.  

**Part 1: Connect An External ALU with A RISC-V**: 60 pts

**Part 2: Performance Optimization**: 40 pts + 10 bonus pts

***Submission ddl***: Nov 6th

This lab builds upon the knowledge you've gained from previous lectures and labs on RISC-V CPU design, as well as your research into AI accelerator implementations. Specifically, you'll be integrating the RISC-V CPU you designed in earlier labs with an external ALU to enhance its efficiency for certain complex workloads. This is the first in a series of three labs on this topic.

## Part 1: Connect An External ALU with A RISC-V (60 points): 

In this section, you'll integrate the RISC-V CPU you designed in Lab #2 with a supplied external ALU. Your responsibility is to adjust the RISC-V implementation to accommodate the external ALU's operations and verify that the RISC-V CPU can accurately run the given test cases.

The [external ALU](external_alu_wrapper.v) has following specifications:
<!-- * `OPREG1`, `OPREG2`, and `OPREG3` are 5-bit inputs that specify the registers to be used as operands for the ALU operation.
    * 4 registers for each of them; in total 12 registers -->
* `OP1` and `OP2` are 32-bit inputs that specify the values to be used as operands for the ALU operation. (Floating point numbers in IEEE 754 format)
* `OP3` is a 32-bit output that holds the result of the ALU operation. (Floating point numbers in IEEE 754 format)
* `ALUOP` is a 4-bit input that specifies the ALU operation to be performed. The ALUOP values are as follows:
    * 0001: MULT
    * 0010: DIV
    <!-- * `ALUOP[3]` is a 1-bit input that specifies whether the ALU operation is signed or unsigned. If `ALUOP[3]` is 0, the operation is unsigned; if `ALUOP[3]` is 1, the operation is signed. -->
* `CSR_ALU_OUT` (Control/Status Register) is a 3-bit bidirectional port that represents the status of the ALU operation. The `CSR_ALU_OUT` values are as follows:
    * `CSR_ALU_OUT`[0] is a 1-bit output that signals if the ALU OP1 port is READY/BUSY
        * i.e., whether the ALU will be able to latch in your inputs (operands and ALUOP)
    * `CSR_ALU_OUT`[1] is a 1-bit output that signals if the ALU OP2 port is READY/BUSY
        * i.e., whether the ALU will be able to latch in your inputs (operands and ALUOP)
    * `CSR_ALU_OUT`[2] is a 1-bit output that signals if the result of the ALU operation is VALID/INVALID
        * 1: VALID; 0: INVALID
* `CSR_ALU_IN` is a 2-bit output that control the status of the ALU operation. The `CSR_ALU_IN` values are as follows:
    * `CSR_ALU_IN`[0] is a 1-bit input that signals the the results can be overwritten by the ALU.
        * After reading the output, the CPU should set `CSR_ALU_IN`[0] to 0, indicating it's safe for ALU to overwrite the results; otherwise, the ALU will stall the current operation write the result to OP3.
    * `CSR_ALU_IN`[1] is a 1-bit input that signals the `OP1` fed to the ALU is stable
        * If it's set to 1, the ALU will latch in the `OP1` value; otherwise, the ALU will stall the current operation and wait for `OP1` to be stable.
        * It's ignored if the ALU is not ready to accept `OP1`.
    * `CSR_ALU_IN`[2] is a 1-bit input that signals the `OP2` fed to the ALU is stable
* The ALUOP need to be loaded first and the operands OP1 and OP2 need to be loaded in order. 
* The ALU is data driven, i.e., it will start the computation as soon as the operands are loaded, based on the loaded ALUOP.
* Potential delay between the two operands' loading, i.e., ALU can potentillay not be ready to load OP2 when OP1 is loaded.
* The ALU is adapted from this implementation:
    * https://github.com/dawsonjon/fpu
    * https://dawsonjon.github.io/Chips-2.0/language_reference/interface.html 

The specifications from RISC-V CPU is as follows:

1. For loading the operands, we will use LW instructions, to load the operands from the memory, with dst reg ID:
    * 11110: OP1
    * 11111: OP2
2. For loading the `ALUOP` to configure the ALU, we will use LUI instructions, with dst reg ID
    * 11101: ALUOP
4. For reading the result/status from the ALU, we will use SW instructions, with src reg ID
    * 11011: OP3
    * 11010: CSR_ALU_OUT
5. Intended instruction sequence:
    * load ALUOP 
    * load OP1, OP2 (**OP1 and OP2 need to be loaded in order**)
    * store OP3



Your tasks are as follows:
1. Integrate the ALU with the RISC-V CPU. You will need to modify the RISC-V CPU to accommodate the ALU's operations.
    * Go over all the TODOs and finish the implementation. ([FU_stage.v](FU_stage.v), [de_stage.v](de_stage.v))
2. You can assume enough NOPs inserted to separate the operands loading and storing the results. 
    * In other words you don't need to worry about the stalls needed to handle the ALU's readiness.

To pass this part and earn full credit, implement the integration described above and run your implementation on [alutest0.mem](test/part5/alutest0.mem) and ensure it passes this testcase.
* You can use the `./run_tests.sh part5` to test your implementation.




## Part 2: Performance Optimization (40 points + 10 bonus pts)
What if there is no NOPs inserted between OP1 loading and OP2 loading, and the ALU might not be ready to load either OP1 or OP2?

Modify the part 1 implementation to handle the stalls needed to handle the ALU's readiness. Your implementation should still work on the testcases in part 1.
* You may modify more files (except the [external ALU](external_alu_wrapper.v) and its dependent modules) as needed.

To pass this part and earn full credit, implement the integration described above and run your implementation on [alutest1.mem](test/part6/alutest1.mem) and ensure it passes this testcase.
* You can use the `./run_tests.sh part6` to test your implementation.

Bonus points: 
When the implementation is instructed to store ALU's results to the memory, it's possible that the ALU is still processing. It's even possible that the instruction to store OP3 is issued before ALU even finishes loading either OP1 or OP2. 

Modify the part 2 implementation to handle the stalls needed to handle stalls needed to handle the ALU's results storing to the memory. Your implementation should still work on the testcases in part 1 and part 2.

To pass this part and earn full credit, implement the integration described above and run your implementation on [alutest2.mem](test/part7/alutest2.mem) and ensure it passes this testcase.
* You can use the `./run_tests.sh part7` to test your implementation.


## Submission

+ Provide a zip file containing your source code. Generate the submission.zip file using the command make submit. Avoid manual zip file creation to prevent any issues with the autograding script, which could lead to a 30% score deduction.
* Late submission policy: 3 hours grace period for potential canvas submission issues; 10% per day late, up to 3 days. No credit will be given for submissions later than 3 days.




# CS3220 Assignment #1 : Pipeline Design 

100 pts in total, will be rescaled into 11.25% of your final score of the course.  

**Part 1**: 50 pts, submission ddl: Sep 11th

**Part 2**: 50 pts, submission ddl: Sep 18th

**Part 3 (Optional)**: 20 bonus pts, submission ddl: Sep 18th

**Description**:
In this assignment, you will design a 5-stage RISC-V pipelined processor using verilog. The ISA is a subset of RISC-V ISA.  We will use <a href="tinyrv-isa.txt"> Tiny RISC-V version from Cornell </a>. In part-0, you will try the essential softwares to run the experiments on your own computer or on the PACE cluster. In part-1, you only need to implement *addi, add, beq* instructions to pass all 5 test cases in tests/part1/test[1-5].mem file. (a subset of TinyRV1). In part-2, you will add more instructions to pass the test cases under tests/part2/. 

## Part 0: Software Installation

Please follow the [instructions](part0/part0_pace.md) on how to run the experiments on the PACE cluster.

**What to submit**:

You do not need to submit for part 0, but make sure you know how to run verilator and how to use GTKWave to view waveforms.

## Part 1: Minimal functionality

In this part, you will implement a subset of RISC-V instructions. You only need to pass 5 tests under tests/part1 folder. 
Please see the test cases for the part 1 requirements. You can refer to the README file under tests/ for more information about each test case. 

1. [20pts] Please complete [agex_stage.v](agex_stage.v), you do not need to modify other files. Your program should pass tests/part1/test[1-5].mem. Based on the coverage of test cases, you will get partial scores.

2. [10pts] Explain what has been done in each pipeline stage when executing tests/part1/test1.mem.

3. [10pts] Explain how the your RISC-V processor solves Read-After-Write hazard in tests/part1/test2.mem, include a screenshot of waveforms that illustrates the relevant signals discussed in your explanation.

4. [10pts] Explain how the your RISC-V processor solves brach misprediction in tests/part1/test4.mem, include a screenshot of waveforms that illustrates the relevant signals discussed in your explanation.
**Note: in lab1 we always predict branch not-taken, in lab2 your will implement your own branch predictor.**

**What to submit**:

+ A zip file of your source code. Run command ```make submit``` will generate a submission.zip. Please submit the submission.zip file. Please do not manually generate a zip file since that will likely break the autograding script. Instead use ```make submit``` command to generate the submission.zip file. Breaking autograding script due to wrong directory structures/missing files might deduct 5% of your score.

+ A pdf file that contains your explanations and the corresponding screenshots.

***Please carefully read [FAQ for part 1](#faq-for-part-1) before reaching out to TAs for help.***

***Please start part 2 as early as possible and do not wait untill the last week, because its worload is heavier than part 1.*** 

## Part 2: Pass a subset of RISC-V test suite

1. [50pts] In this part, you may need to modify all the *.v and *.vh files to pass all the test cases under tests/part2/ directory. Based on the coverage of test cases, you will get partial scores.

**Test cases**:

In part-2, all instructions in the test cases under tests/part2/ such as add, addi, auipc, beq, bge, (all branch instructions) jal, jalr instructions will be tested. you need to pass all test cases in test/part2 directory.  To test all test cases together, you can use ```run_tests.sh part2``` and it will produce part[1-3]_results.log and part[1-3]_tests.log. test[7-9] are hand written assembly code which is easier to debug, please use those test cases first. 

In part-2, we start to use modified RISC-V test cases. ```*.S``` is assembly code that takes RISC-V macro. Macro files are defined at include/test_macros.h or include/riscv_test.h. It also uses ABI names and Pseudo Instructions. You can find a summary of information <a href="https://web.eecs.utk.edu/~smarz1/courses/ece356/notes/assembly/"> [here].  </a> ```*.dump``` is an dump file output from gcc riscv compiler. ```*.mem```  file has the format for verilog code. ```*.dec``` file is useful when using <a href="http://tice.sea.eseo.fr/riscv/">[RISC-V emulator] </a>

**What to submit**:

+ A zip file of your source code. Run command ```make submit``` will generate a submission.zip. Please submit the submission.zip file. Please do not manually generate a zip file since that will likely break the autograding script. Instead use ```make submit``` command to generate the submission.zip file. Breaking autograding script due to wrong directory structures/missing files might deduct 5% of your score.

***Please carefully read [FAQ for part 2](#faq-for-part-2) before reaching out to TAs for help.***

***Please do not procrastinate.*** 

## Part-3 (Optional) Complete the pipeline 

1. [20pts] In this part, you will complete the pipeline to test RISC-V ISA (except CSR instructions). Your program should pass all the test cases under test/part3/.

**Grading:** 

If you pass test/part3/testall.mem (you need to see "Pass" ) you will get full credits. If you don't pass test/part3/testall.mem, you will get partial scores based on the coverage of part 3 test suites.

**What to submit**: 

+ A zip file of your source code. Run command ```make submit``` will generate a submission.zip. Please submit the submission.zip file. Please do not manually generate a zip file since that will likely break the autograding script. Instead use ```make submit``` command to generate the submission.zip file. Breaking autograding script due to wrong directory structures/missing files might deduct 5% of your score.

***Please carefully read [FAQ for part 3](#faq-for-part-3) before reaching out to TAs for help.***

## Useful Information

**References**

<a href="https://web.eecs.utk.edu/~smarz1/courses/ece356/notes/assembly/"> summary of RISC-V Assembly coding </a>  
 
<a href="https://www.cs.cornell.edu/courses/cs3410/2019sp/riscv/interpreter/"> RISC-V emulator  (tiny RV2) </a> 

<a href="https://verilator.org/guide/latest/"> Verilator manual  </a> 

<a href="http://gtkwave.sourceforge.net/gtkwave.pdf"> GTKWave manual</a> 

<a href="https://inst.eecs.berkeley.edu/~cs250/fa10/handouts/tut3-riscv.pdf"> Tutorial about RISC-V TEST SUITE </a> 

## FAQ for part-1

**(Q)** How do I run a specific test file? \
**(A)** Please see ["define.vh"](define.vh): you need to change line 21 to change which test file to read: **`define IDMEMINITFILE  "test1.mem"**. You need to change "test1.mem" into "test2.mem" etc, and then run command "make" in your terminal under lab1 folder. Please note that both imem and dmem use the SAME "IDMEMINITFILE".

**(Q)** How do I know whether my implementation is correct or not? \
**(A)** If you are using verilator, you would see "Pass" message. 

**(Q)** Can I add new files? \
**(A)** Yes, but please make sure they are added in the zip file. 

**(Q)** Do we need to implement a branch predictor? \
**(A)** It's not required for lab 1. 

**(Q)** Do we need to create a stack for nested JAL instructions? \
**(A)** The hardware does not know any nested calls, so you do not need to implement it. 

**(Q)** BEQ t1, t1, imm : if a branch is taken, is the new PC = PC + imm or new PC = PC + 4+ imm? \
**(A)** The answer is PC = PC + offset. Please be careful with converting imm to offset. 

**(Q)** Do we need to worry whether we should prevent all writes to the zero register and treat it as always zero, or if that is solely up to us dependent on our design? \
**(A)** This is purely S/W job. The H/W doesn't have to check whether x0 is writable or not. The Hardware also doesn't have explicitly insert 0 in hardware. 

**(Q)** Debugging takes so much time. Any tips to reduce the debugging time? \
**(A)** Some suggestions.
1. Review code carefully and understand the ISA behavior correctly 
2. If `make` command fails to compile, read the error messages carefully. 
3. Verilator generates vcd file. Please use GTKWave to see each pipeline signal and check the signals works as expected. When debugging, it is always helpful to visualize `clk` signal and pc value along with other signals.

**(Q)** Is the immediate field inside assembly code decimal? \
**(A)** If the number starts with 0x, it's hexadecimal.

**(Q)** When we access the memory, why we drop out LSB 2 bits? \
**(A)** ISA is byte addressability but the verilog imem/dmem is declared as if it is word addressability since we don't do any unaligned accesses. Hence, we simply drop out lower two bits. Please note that, you don't need to do anything to support that. The framework already includes the code to ignore the lower 2 bits. 
  ```assign inst_FE = imem[PC_FE_latch[`IMEMADDRBITS-1:`IMEMWORDBITS]]; ```
```dmem[memaddr_MEM[`DMEMADDRBITS-1:`DMEMWORDBITS]]; ``` 

**(Q)** What does ``` assign inst_FE = imem[PC_FE_latch[`IMEMADDRBITS-1:`IMEMWORDBITS]];``` mean? \
**(A)** PC_FE_latch contains PC value. Again imem and dmem are word addressable, so we don't need LSB 2 bits. Since imem and dmem has only 2^14 size, we just use addr [15:2] bits to index imem/dmem.  

**(Q)**  I'm not sure how to understand part 2 test code. \
**(A)** The test in test/part2 is modified code from RISC-V test suite. It uses macro function to generate test code. 

**(Q)** How do I know what is the correct instruction/code behavior? \
**(A)** You can probably use RISC-V interpreter or other RISC-V machine to execute the code. One example is <a href ="https://www.cs.cornell.edu/courses/cs3410/2019sp/riscv/interpreter/" >  here </a>.

**(Q)** How do I know whether I pass the code or not? \
**(A)** For part 1, we provide test code. Your code should print out "Pass" message if you are using verilator.

**(Q)** My code does not load any instructions. Do I need to change anything? \
**(A)** Carefully check if you encountered any error messages and make sure you have set **IDMEMINITFILE** to the right path.

## FAQ  for part 2

**(Q)** what is li instructions in add.dump? \
**(A)** li instruction is one of the pseudo instructions. It is the same as addi x0, imm

**(Q)** I passed test[1-5].mem. why do I fail addi.mem? \
**(A)** It contains bne, auipc, jal instructions. So in order to pass part 2 test cases, you need to complete those instructions.

**(Q)** I'd like to use RISC-V emulator for testing the test code, but it won't take dump file. what should I do? \
**(A)** Unfortunately RISC-V emulator only takes assembly instructions. Hence, we recommend to use another <a href="http://tice.sea.eseo.fr/riscv/"> emulator </a> . You can use *.dec file in this simulator. 
  
**(Q)** I get the error "%Warning-LATCH: de_stage.v:120:1: Latch inferred for signal 'my_DE_stage.type_I_DE' (not all control paths of combinational always assign a value)" when running `make` with Verilator. \
**(A)** You can disable the Verilator linter by adding the comment `/* verilator lint_off LATCH */` on the line before the warning.

**(Q)** Behavior of ```lui```.  The documentation says that ``` - Semantics : R[rd] = imm << 12```. But U-immediate already shifted the immediate by 12 bits. Do I need to shift the sxt_imm_DE. Do I need to shift immediate value again? \
**(A)** No. if you have already shift immediage bits in instruction into sxt_imm_DE, you don't have to shift sxt_imm_DE again. 

**(Q)** ```bge``` is signed comparison and ```bgeu``` is unsigned comparison. What does it mean and what should I do? \
**(A)**  by default, in verilog all operations are unsigned. However, you can use signed comparisons in verilog by defining wires as signed variables. 
Here is an example for signed comparisons and unsigned comparisons 

```
wire signed [`DBITS-1:0] s_regval1_AGEX;  // note *signed* 
wire signed [`DBITS-1:0] s_regval2_AGEX;  //note *signed* 

assign s_regval1_AGEX = regval1_AGEX;
assign s_regval2_AGEX = regval2_AGEX;

// signed comparison
wire s_less;
assign s_less = (s_regval1_AGEX < s_regval2_AGEX); 

// unsigned comparison
wire less;
assign less = (regval1_AGEX < regval2_AGEX); 

``` 

**(Q)** ```bgeu``` and ```bltu``` use unsigned comparisons. Does it mean I shouldn't sign extend immediage values at the decode stage and keep both unsiged and signed extension versions? \
**(A)** No, in RISC-V, all immediate values are sign-extended. ```begu``` and ```bltu``` are unsigned comparisons with sing-extended values (e.g. ```sxt_imm_DE```)

**(Q)** I'm still confused with ```signed``` keyword in verilog. Does it perform any sign conversion when I put ```signed``` keyword in the above example? \
**(A)** In Verilog, values are just binaries.  s_regval1_AGEX and regval1_AGEX have the same value. Signed unsigned are just a matter of interpretation. When arithmetic operations are used such as comparator, signed/unsigned decide how to interpret the value. 
e.g.)  In the above example, let's assume that reval1_AGEX  is  0x0000 and regval2_AGEX is  0xFFFF. In that case, s_regval1_AGEX is  0x0000 and s_regval2_AGEX is still 0xFFFF. However, s_regval2_AGEX is interpreted as -1 whereas regval2_AGEX is interpreted as 65535. Hence, `if (regval1_AGEX < regval2_AGEX)` returns false but `if (s_regval1_AGEX < s_regval2_AGEX)` returns true. 

**(Q)** Do I need to put the ```signed``` keyword for immediate values? \
**(A)** Yes, even though immediate values are sign-extended, if we want to treat the immediate value as 2's complement value such as in ``` SLTI_I```  instruction case, you need to put ```signed``` keyword. 

## FAQ - part 3 

**(Q)** Can you explain the behavior of ```slti``` and ```sltiu```. Does it store the outcome of shift value?  \
**(A)** The outcome of both instructions should be either 0 or 1. It checks whether (R[rs1] < sext(imm)) (signed comparisons for SLTI and unsigned comparisons for SLTIU) and if the condition is true, it sets 1 for the destination. 

**(Q)**  In tiny-isa description, ```srai``` , ```srli``` and  ```slli```  do not have immediate type. What should I do ? \
**(A)** Those instructions follow I-immediate type. However, only LSB 5-bits are used for immediate value (i.e. INST[24:20]). Please note that SRAI, SRL, SLL also use LSB 5-bits as source operand values.
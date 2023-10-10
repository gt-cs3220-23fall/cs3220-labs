# Lab 0 RTL Getting Started

**Objective:** The main purpose of this lab, along with the succeeding one, is to acquaint you with RTL programming, specifically Verilog. These initial steps aim to equip you with a strong foundation in Verilog, setting the stage for more advanced labs ahead.

**Description:** This lab involves the implementation of a variety of basic hardware modules using Verilog. In addition, you will be tasked with developing the requisite testbench code to verify the correctness of your modules. This dual approach not only provides hands-on experience with Verilog but also emphasizes the importance of testing and validation in hardware design.

1. **Included modules:**  a. Combinational Circuits; b. Vector Signals; c. Module Hierarchy; d. Always Block & Sequential Circuits
2. **Specification about each modules:**
    1. [Combinational Circuits](./combuinational_circuits.md)
    2. [Vector Signals](./vector_signals.md)
    3. [Module Hierarchy](./module_hierarchy.md) 
    4. [Always Block & Sequential Circuits](./always_block.md)

**Provided Resources:**

1. **Procedures to setup your environment on the server:**
    1. [Environment setup](https://docs.google.com/document/d/1AEyVnDq-EX87BF8rP6L7kGDFoxXFHFT3Fsqeemnlcyk/edit?usp=sharing)
2. **File structure:**
    1. Do keep the following file structure for the purpose of grading and relative path dependency in the compilation script
    2. <you_gt_user_name>
        1. srcs 
            1. Sample files in: (/storage/ice-shared/cs3220/lab_srcs/lab0_srcs/srcs in the shared drive of the remote server) or ([dropbox link](https://www.dropbox.com/sh/lsabgku9g6or6gw/AADNR3_zCAAbY7vTwsKycNcVa?dl=0))
        2. tb 
            1. Sample files in:  (/storage/ice-shared/cs3220/lab_srcs/lab0_srcs/tb in the shared drive of the remote server) or ([dropbox link](https://www.dropbox.com/sh/g9jevyv2wqhcu71/AAAcUgYPgnqvokTt_sRNqNWRa?dl=0))
        3. compilation_script 
            1. Sample files in:  (/storage/ice-shared/cs3220/lab_srcs/lab0_srcs/compilation_script in the shared drive of the remote server) or ([dropbox link](https://www.dropbox.com/sh/ckqqx7szw2ens62/AACRAQTWIlEHda-J4R4MOsHba?dl=0))
3. **Source code:**
    1. We have provided the skeleton code for the modules in  (/storage/ice-shared/cs3220/lab_srcs/lab0_srcs/srcs in the shared drive of the remote server) or ([dropbox link](https://www.dropbox.com/sh/lsabgku9g6or6gw/AADNR3_zCAAbY7vTwsKycNcVa?dl=0)): 
        1. a. combination_circuits.v; b. vector_signals.v; c. module_hierarchy.v; d. always_block.v
    2. NOTE: DO NOT CHANGE THE PORT OR MODULE DEFINITIONS.
    3. Implement functionality of each module as described above in “Specification about each modules:”
4. **Testbench code:**
    1. The testbench code is provided in (/storage/ice-shared/cs3220/lab_srcs/lab0_srcs/tb in the shared drive of the remote server) or ([dropbox link](https://www.dropbox.com/sh/g9jevyv2wqhcu71/AAAcUgYPgnqvokTt_sRNqNWRa?dl=0))
    2. We have provided the testbench code for the first two modules: 
        1. a. combination_circuits_tb.v; b. vector_signals_tb.v
    3. We provided a skeleton of the testbench code for the last two modules: 
        1. c. module_hierarchy_tb.v; b. always_block_tb.v
    4. Follow the first two modules’ testbench code, complete the testbench of the last two modules’
        1. REMEMBER TO CHANGE THE OUTPUT FILE NAME (where your test results will be saved per clock cycle)
5. **Compile and run the simulation:**
    1. Source vivado environment: source <vivado_path>/settings.sh
    2. Compilation script is provided here:  (/storage/ice-shared/cs3220/lab_srcs/lab0_srcs/compilation_script in the shared drive of the remote server) or ([dropbox link](https://www.dropbox.com/sh/ckqqx7szw2ens62/AACRAQTWIlEHda-J4R4MOsHba?dl=0))
    3. ./compile.sh to compile the verilog code. 
        1. By default its running in the command line mode and store the per cycle data (*.txt) in the <vivado_prj>/<vivado_prj_sim>/<xsim>/**.txt
        2. Please also try running in gui mode (use the server’s interactive session) and follow instruction [here](https://youtu.be/onMmG_U4SVo?t=564)
            1. in compile.sh : copy and change the mode of vivado project creation command to gui mode and run it on an interactive terminal, e.g., vivado -mode gui -source compile_vector_signals.tcl
6. **Per cycle expected output:**
    1. Your output should match the per cycle output here: (/storage/ice-shared/cs3220/lab_srcs/lab0_srcs/expected_output in the shared drive of the remote server) or ([dropbox link](https://www.dropbox.com/sh/m64737yezrezixa/AABXvMlKxfC6g0BNCpK09yyEa?dl=0))
        1. your output locations: 
            1. <folder you run your compilation script>/<specific module name>/<specific module name>_sim/xsim/
    2. if there is any difference, justify the difference

**How to test the correctness**: Testbench runs on the verilog module without errors

**Submission Format:** 

1. * A zip file of your source and testbench code and screenshot wave form pdf. 
2. zip file structure:
    1. <you_gt_user_name>
        1. srcs
        2. tb
        3. compilation_script
        4. pdfs

**Due:** Aug. 30th 11:59PM EST

**Grading Policy**: 

1. If you pass the provided test code.
2. **Partial grading Policy**: Partial grade points are very limited.

**FAQ:** 

[Q] When I compile the files, it generates errors. What should I do? 

[A] You need to complete the code. The provided code is incomplete, so it will generate errors

[Q] Can I modify the src and testbench file? 

[A] Yes, you can modify them, but you have to ensure the IO formats unchanged and the parts in testbench capturing the output are also as intended

[Q] How can I debug the internal wires? 

[A] Please look at the trace to see all wire values in the module in the modelsim: starting page 24: [link](https://docs.xilinx.com/v/u/2018.1-English/ug937-vivado-design-suite-simulation-tutorial)

[Q] Do I need to test other test cases? 

[A] We will use the same test case as the provided code.

[Q] Any online tutorials to watch?

[A] [link1](https://www.youtube.com/watch?v=lLg1AgA2Xoo&list=PLEBQazB0HUyT1WmMONxRZn9NmQ_9CIKhb&index=1): Focus on the concept and programing as we will use different devices

[link2](https://www.youtube.com/watch?v=9mpRF6bAY1g): modelsim (similar to vivado xsim)

[link3](https://www.youtube.com/watch?v=YodFKbKxElo&list=PLfGJEQLQIDBN0VsXQ68_FEYyqcym8CTDN), [link4](https://www.youtube.com/watch?v=S26TPZm4zzM&list=PL3Soy1ohxlP1TLpcbYXYcVWItRy_XrUk8): more comprehensive digital design and RTL programing tutorial videos
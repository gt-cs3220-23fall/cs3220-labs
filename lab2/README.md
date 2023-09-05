# CS3220 Lab #2 : Branch Prediction

100 pts in total, will be rescaled into 11.25% of your final score of the course.  

**Part 1**: 100 pts, submission ddl: Sep 11th

**Part 2 (Optional)**: 20 bonus pts, submission ddl: Sep 18th


This project is a continuation of project #1. In this project, you will implement a branch predictor (BP) and a branch target buffer (BTB) on top of your RISC-V CPU from lab1. 

## Part 1: Baseline Branch Predictor/BTB (100 points): 
In this design, you will add a baseline branch predictor and the BTB to your pipeline. 

The baseline branch predictor uses a G-share branch predictor (refer to the slides for details). Its Branch History Register (BHR) length is 8 bits and its BTB size is 16. And you will use the XOR of PC[9:2] and BHR to index the Pattern History Table (PHT), each of the 2bit counter in the PHT is initialized with 1 (weekly taken).

Summary of the G-share branch prediction algorithm: 

* Fetch Stage ([fe_stage.v](fe_stage.v)): 

    While instruction is fetched from instruction memory (IMEM), both BTB and Branch Predictor are concurrently accessed. 
    
    1. If there is a hit in the BTB, use the outcome of the branch predictor to choose the target (i.e. if a BP outcome is taken, the target address in the BTB is used to fetch in the next cycle. If a BP outcome is not taken, PC+4 is used for the next fetch address.) 

    2. If BTB miss, then simply fetch the PC+4 in the next cycle. 

    The BHR index (e.g. BHR xor PC) information that was used to access the BP is passed through the pipeline latches, which will be used to update BTB and BP in the execution stage. 

* Execution stage ([agex_stage.v](agex_stage.v)): 

    1. If a branch is mispredicted, flush the pipeline.

    2. If an instruction is a branch, insert the target address into the BTB. Index the BP with the index value that was propagated with the instruction to update the BP (2-bit saturating counter is updated). 

    3. Update the BHR. 



**Grading**:  
**NOTE: part4 test has been added to the project1 direction. Pull/Fetch the latest code to get the latest test code"  
We will check whether </test/part4/testall.mem> is correctly executed or not. 
There won’t be any performance improvement in testall.mem because the final execution time is already fixed by the test code.  With the branch predictor/BTB, your code should finish testall.mem correctly. 

**What to submit:**
**A zip file of your source code. The zip file must contain the following:**
type ```make submit``` will generate a submission.zip. 
Please submit the submission.zip file. Each submission for each group.


## Part 2 Performance Improvements (Optional, 20 bonus points)
In this design, you can change your BTB and BR designs to improve performance of </test/towers/towers.mem>. You probably want to add counters to measure branch predictor accuracy (correctly predicted branches vs. mispredicted branches.).
You can explore other BHR hashing functions (e.g. using different bits of PC for the XOR operation), or change the branch predictor size or BTB. You could also implement another branch predictor. 
Your scores will be depending on the performance improvement. If you get more than 5% performance improvement over the baseline configuration, you will receive 2 pts, if not, you will get 1 pt based on your report contents.  
Discuss your design space explorations and write a report about your evaluations. 
Evaluate your design with the provided benchmark and report the performance numbers. 
Please print out cycle count, BP accuracy (# of corrected predicted branch/# branch insts), # taken branches, # not-taken branches. # branches.  The cases are no branch predictor, baseline branch predictor (part-1), and your improved versions. Please show the results those are hurting the performance. 
Please show at least 3 different design changes that you have made in addition to the baseline branch predictor. Total 4 branch predictor's results + no branch predictor's result (project #1). 

**Grading**
The contents of the report will be used for the grading part-2.  
Please discuss what design parameters have you changed and discuss why it changes (good or bad or the same) performance.  


**What to submit** 
Report (max 2 pages) (No need to submit the code again) 

## FAQ 
[Q]  I’m debugging my code. I see that there is an X in the BTB. How would it be possible? \
[A] FE stage can have pipeline bubbles. BTB/BP might be indexed with uninitialized values. Please also make it sure when you update BTB/BP, only branch instructions/signals (not including X) can change the BP/BTB values.

[Q] I don’t see performance improvement in testall.mem. Why ?  \
[A]  All branch code in testall.mem are executed only once and not-taken. In order to have a branch predictor works, the processor has to see the same branch over and over. W/o training, the branch predictor would’t work well. 

[Q] Do we insert a BTB entry only for the taken branch or even for not-taken a branch? \
[A] You insert a BTB entry even for the not-taken branch. Because the same branch might be taken in the next time prediction. 

[Q] If we insert a not-taken branch for the BTB entry, what will be the target address? \
[A] You can compute the potential target address and insert the information in the BTB. 

[Q] What if the target in the BTB is wrong? \
[A] Just like a branch misprediction, we flush the pipeline and also update the BTB with the correct information. 

[Q] With a branch predictor, will the pipeline still have pipeline bubbles?  \
[A] The pipeline will have pipeline bubble for dependency stalls but not for branch instructions. 


[Q] My pipeline did not work for project-1. What should I do?  \
[A] Please use the standard solution provided by TAs instead. 


[Q] I want to add a new file (bp.v). can I? \
[A] Please do not add new file, as it might break our auto-grading script. 

[Q] Do I have to show the performance improvement in order to get a full-credit for part-1? \
[A] No. the performance improvement needs to be demonstrated in part-2 only. 

[Q] Are we expected to implement data forwarding in lab 2? \
[A] No. 


[Q] Let’s say my instruction stream is as follows: 
```
BR(1)
ADD
BR(2)
```
. When BR(1) is in EX, it will update the BHR. But BR(2) will be in FETCH at that time.
Which value of BHR should FETCH use? The old value or the updated value from EX? \
[A] This is one of the optimization opportunities. So how you handle this case is up to you for this assignment. Please remember that the branch predictor is just a predictor and it won't affect the correctness of the program. 

[Q] How to initialize PHT as one? \
[A] You explicitly put 1 when it resets. 


[Q] How do I print out the number of corrected branches and the number of mispredicted branches? Do I have to check waveform outputs (.vcd file)? \
[A] You could use waveform outputs. Alternatively, you could add the counter values into ```WB_counters[8], WB_counters[9]``` etc. and printout them in the [sim_main.cpp](sim_main.cpp). If you do not understand how the sim_main.cpp works, just use waveform files then, TAs will not provide support on customizing the simulator code.

[Q] I ran tower.mem and my test case is failed unlike other test cases. Is that expected?\
[A] Yes. The tower.mem returns "255", which does not match the PASS cateria of the simulator. You do not need to worry about it.

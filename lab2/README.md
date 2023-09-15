# CS3220 Lab #2 : Branch Prediction

100 pts in total, will be rescaled into 11.25% of your final score of the course.  

**Part 1: Baseline Branch Predictor**: 60 pts

**Part 2: Performance Measurement & Optimization**: 40 pts + 10 bonus pts

***Submission ddl***: Oct 2nd

This lab is a continuation of lab #1. In this project, you will implement a branch predictor for your RISC-V CPU. If your RISC-V CPU fails to pass all testcaese in lab1, you should work on top of the reference solution for lab #1 from the TAs.

## Part 1: Baseline Branch Predictor (60 points): 
In this design, you will add a baseline branch predictor and a branch target buffer to your pipeline. 

The baseline branch predictor uses a G-share branch predictor (Before Releasing: refer to the speicific slides page): 

1. Its branch history register (BHR) length is 8 bits, you will use the `PC[9:2] XOR BHR` to index a Pattern History Table (PHT), which is composed of 2^8 2-bit counters for branch prediction, and each of the 2bit counter in the PHT is initialized with 1 (weekly taken).

2. The branch target buffer (BTB) has 16 entries, you will use `PC[5:2]` to index it.

Summary of the G-share branch prediction algorithm: 

* FE Stage ([fe_stage.v](fe_stage.v)): 

    Both BTB and PHT are concurrently accessed in this stage. 
    
    1. If there is a hit in the BTB, use the outcome of the PHT to choose the target (i.e. if the outcome is taken, the target address in the BTB is used to fetch in the next cycle. If the outcome is not taken, PC+4 is used for the next fetch address.) 

    2. If BTB misses, then simply use PC+4 for the next instruction. 

    The index (`PC[9:2] XOR BHR`) that was used to access the PHT is passed through the pipeline (from FE stage to EX stage), which will be used to update PHT in the EX stage. 

* EX stage ([agex_stage.v](agex_stage.v)): 

    1. If the address of the next instruction is mispredicted, flush the pipeline.

    2. If an instruction is a branch, no matter it is taken or not, insert the target address into the BTB. 
    
    3. If PHT is used for branching prediction in the FE stage, update PHT using the PHT index value (`PC[9:2] XOR BHR`) that was propagated from the FE stage. 

    4. Update the BHR. 

You should run your branch predictor on </test/part4/testall.mem> and pass this testcase. If you correctly implemented the baseline branch predictor and passed the </test/part4/testall.mem> testcase, you will receive full credits for this part.

<!-- **Grading**:
We will check whether </test/part4/testall.mem> is correctly executed or not. 
There won’t be any performance improvement in testall.mem because the final execution time is already fixed by the test code.  With the branch predictor/BTB, your code should finish testall.mem correctly. 

**What to submit:**
**A zip file of your source code. The zip file must contain the following:**
type ```make submit``` will generate a submission.zip. 
Please submit the submission.zip file. Each submission for each group. -->


## Part 2: Performance Measurement & Optimization (40 points + 10 bonus pts)

1. [10 pts] In this part, you will add counters to the measure branch prediction accuracy (# of correctlt predicted branchs /# branch insts). You should use the </test/towers/towers.mem> testcase for part2 measurement. Write a report about your evaluations.

2. [30 pts + 10 pts bonus] Improve the performance of your branch predictor: you can change your branch predictor design to improve performance of </test/towers/towers.mem>. You can explore other BHR hashing functions (e.g. using different bits of PC for the XOR operation), or change the PHT or BTB size. Please try at least 3 different design changes that you have made, explain your design changes and the performance outcome in your report. If you get more than 5% prediction accuracy improvement over the baseline branch predictor, you will receive 10 bonus pts. 

## Submission

+ Provide a zip file of your source code for part1. Use the command `make submit` to generate submission.zip. Do not manually create a zip file to avoid breaking the autograding script, as this may result in a 30% score deduction.

+ Submit a PDF report for part 2 (no more than 2 pages):
1.  Your perfomance measurement of the baseline branch G-share predictor and your 3 variants.
2.  Discuss which design parameters were changed and discuss why it increases or decreases the branch prediction accuracy.

<!-- Your scores will be depending on the performance improvement. If you get more than 5% performance improvement over the baseline configuration, you will receive 2 pts, if not, you will get 1 pt based on your report contents.  
Discuss your design space explorations and write a report about your evaluations. 
Evaluate your design with the provided benchmark and report the performance numbers. 
Please print out cycle count, BP accuracy (# of corrected predicted branch/# branch insts), # taken branches, # not-taken branches. # branches.  The cases are no branch predictor, baseline branch predictor (part-1), and your improved versions. Please show the results those are hurting the performance. 
Please show at least 3 different design changes that you have made in addition to the baseline branch predictor. Total 4 branch predictor's results + no branch predictor's result (project #1).  -->

<!-- **Grading**
The contents of the report will be used for the grading part-2.  
Please discuss what design parameters have you changed and discuss why it changes (good or bad or the same) performance.  


**What to submit** 
Report (max 2 pages) (No need to submit the code again)  -->

## FAQ 
[Q]  I’m debugging my code. I see that there is an X in the BTB. How would it be possible? \
[A] FE stage can have pipeline bubbles. BTB/BP might be indexed with uninitialized values. Please also make it sure when you update BTB/BP, only branch instructions/signals (not including X) can change the BP/BTB values.

[Q] I don’t see performance improvement in testall.mem. Why ?  \
[A]  All branch code in testall.mem are executed only once and not-taken. In order to have a branch predictor works, the processor has to see the same branch over and over. W/o training, the branch predictor would’t work well. 

[Q] Do we insert a BTB entry only for the taken branch or even for not-taken a branch? \
[A] You insert a BTB entry even for the not-taken branch. Because the same branch might be taken in the next time prediction. 

[Q] If we insert a not-taken branch for the BTB entry, what will be the target address? \
[A] You can compute the potential target address and insert it in the BTB. 

[Q] What if the target in the BTB is wrong? \
[A] Just like a branch misprediction, we flush the pipeline and also update the BTB with the correct information. 

[Q] With a branch predictor, will the pipeline still have pipeline bubbles?  \
[A] The pipeline will have pipeline bubble for dependency stalls but not for branch instructions. 


[Q] My pipeline did not work for lab 1. What should I do?  \
[A] Please use the reference design provided by TAs instead. 


[Q] I want to add a new file (bp.v). can I? \
[A] Please do not add new file, as it might break our auto-grading script. 

[Q] Do I have to show the performance improvement in order to get a full-credit for part 1? \
[A] No. the performance improvement needs to be demonstrated in part 2 only. 

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
[A] This is one of the optimization opportunities. So how you handle this case is up to you. Please remember that the branch predictor is just a predictor and it won't affect the correctness of the program. 

[Q] How to initialize PHT as one? \
[A] You should explicitly put 1s when it resets. 

[Q] I ran tower.mem and my test case is failed unlike other test cases. Is that expected?\
[A] Yes. The tower.mem returns "255", which does not match the PASS cateria of the simulator. You do not need to worry about it.

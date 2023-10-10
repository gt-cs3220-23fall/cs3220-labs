# Lab 5 - AI Accelerator Case Study - SIGMA

**Objective:** The primary aim of this lab is to synthesize the skills and knowledge acquired in previous labs focused on digital design and RTL programming. This will be applied in a practical case study centered on Artificial Intelligence (AI) accelerators.

**Description:**  This lab consists of two main components. First, you will read, comprehend, and summarize a classic research paper on AI accelerators. The second part involves hands-on experience: based on your understanding of the paper, you will delve into the actual code implementation of the discussed accelerator. You will be assigned specific modules that make up this accelerator. Your task is to understand the code in the context of the paper's insights and to provide both a high-level summary and detailed annotations for the code.

1. **Paper summary:**
    1. **Paper link:** [SIGMA: A Sparse and Irregular GEMM Accelerator with Flexible Interconnects for DNN Training](https://ieeexplore.ieee.org/document/9065523)
    2. **Format for paper summary:**
        1. Organized section layout, comprising:
            1. Abstract: Provide a high-level description of the paper's main contributions. (Note: Do not copy the original abstract.)
            2. Motivation: Explain the significance of the techniques introduced in the paper.
            3. Methods: Outline the key technical aspects and methodologies presented in the paper.
            4. Effectiveness: Discuss how the paper's experiments validate the efficacy of the proposed techniques.
            5. Summary: Conclude with an overall assessment of the paper's contributions and impact.
            6. Under 1000 words; figures are welcome but do not directly copy the ones in the paper; show your understanding 
    3. **Submission**: A PDF containing the above contents
2. **Code implementation understanding and documentation:**
    1. **[Available Modules](assets/SIGMA_undocumented):**
        1. These RTL modules contain a combination of high-level module instantiation and porting and low-level detailed logic implementations
    2. **Module assignment:**
        1. Each student will be randomly assigned with **3** modules.
        2. Assignment will be listed in a sheet posted in both Canvas and Piazza
    3. **Documentation format:**
        1. Summary of the code file
        2. Line by line comments of the code (meaningless lines can be skipped, e.g., “begin”, “end”, parentheses…)
        3. [Example code documentation](assets/examples)
    4. **Submission:**
        1. All documented code pieces
        2. Do not change the original code file name
3. **Submission Format:** 
    1. Copy the [makefile](Makefile) to your folder containing paper summary pdf and documented code pieces
    2. **`make submit`**
    3. Rename submission.zip to <you_gt_user_name>.zip
    4. Make sure the zip file containing the paper summary pdf and documented code pieces

**Due:** Oct. 30th 11:59PM EST

**Grading Policy**: 

1. Paper summary (25 points): 
    1. **Abstract (6 points)**
        - Clarity and conciseness: 3 points
        - Accurate representation of the paper's main contributions: 3 points
    2. **Motivation (3 points)**
        - Explanation of the paper's significance: 2 point
        - Relevance to the preceding working and existing solutions: 1 point
    3. **Methods (6 points)**
        - Clarity in outlining key technical aspects: 4 points
        - Depth of understanding: 2 points
    4. **Effectiveness (4 points)**
        - Discussion of the paper's experimental validation: 3 points
        - Critical evaluation of the results: 1 point
    5. **Summary (3 points)**
        - Overall assessment of the paper: 2 points
        - Coherence and flow of the summary: 1 points
    6. **Formatting and Structure (3 points)**
        - Adherence to guidelines: 2 points
        - Grammar and spelling: 1 points
2. Code documentation  (25 points / code file; 75 points in total):
    1. **Summary of the Code File (5 points)**
        - Clarity and conciseness: 2 points
        - Accurate representation of the code's main functionalities: 3 points
    2. **Line-by-Line Comments (15 points)**
        - Completeness: Covering all meaningful lines of code: 7.5 points
        - Clarity: Making complex or non-intuitive lines understandable: 7.5 points

3. Late submission policy: 3 hours grace period for potential canvas submission issues; 10% per day late, up to 3 days. No credit will be given for submissions later than 3 days.

**Bonus Points (15 points)**: 

- In this lab, you'll gain a fundamental understanding of the design and implementation of a run-time reconfigurable sparse accelerator. However, you'll notice that the current implementation is modular and not fully complete. Are you interested in diving deeper into a more comprehensive implementation? For this bonus assignment, **you'll explore the complete codebase of MAERI, a reconfigurable sparse accelerator that serves as the inspiration for SIGMA.**
- This assignment is both challenging and open-ended, offering you considerable latitude in your approach. Your primary task is to
    - 1) Write a short summary (150~250 words) of MAERI design.
    - 2) Choose one or more modules within the MAERI architecture that interest you.
        - Document the code, focusing on its structure, functionality, and any unique features.
- Note: MAERI is written in Bluespec System Verilog which you can find more information [here](https://github.com/maeri-project/MAERI_bsv#software-requirement)
- MAERI source code: https://github.com/maeri-project/MAERI_bsv/tree/master/src
- MAERI paper: https://bpb-us-w2.wpmucdn.com/sites.gatech.edu/dist/c/332/files/2018/01/maeri_asplos2018.pdf
- Grading:
    - Two modules’ full documentation at [this level](https://github.com/maeri-project/MAERI_bsv/blob/master/src/maeri_accelerator/MAERI_Accelerator.bsv) will lead to full points
    - Your documentation will be scaled with the above level
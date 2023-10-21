# Lab 4 - AI Accelerator Case Study - DNNBuilder

**Objective:** The primary aim of this lab is to synthesize the skills and knowledge acquired in previous labs focused on digital design and RTL programming. This will be applied in a practical case study centered on Artificial Intelligence (AI) accelerators.

**Description:**  This lab consists of two main components. First, you will read, comprehend, and summarize a classic research paper on AI accelerators. The second part involves hands-on experience: based on your understanding of the paper, you will delve into the actual code implementation of the discussed accelerator. You will be assigned specific modules that make up this accelerator. Your task is to understand the code in the context of the paper's insights and to provide both a high-level summary and detailed annotations for the code.

1. **Paper summary:**
    1. **Paper link:** [DNNBuilder: an Automated Tool for Building High-Performance DNN Hardware Accelerators for FPGAs](https://ieeexplore.ieee.org/document/8587697)
    2. **Format for paper summary:**
        1. Organized section layout, comprising:
            1. Abstract: Provide a high-level description of the paper's main contributions. (Note: Do not copy the original abstract.)
            2. Motivation: Explain the significance of the techniques introduced in the paper.
            3. Methods: Outline the key technical aspects and methodologies presented in the paper.
            4. Effectiveness: Discuss how the paper's experiments validate the efficacy of the proposed techniques.
            5. Summary: Conclude with an overall assessment of the paper's contributions and impact.
            6. Under 1000 words; figures are welcome but do not directly copy the ones in the paper; show your understanding 
    3. **Submission**: A txt file containing the above contents
2. **Code implementation understanding and documentation:**
    1. **[Available Modules](assets/DNNBuilder_undocumented)**
        1. **High-Level Modules**: These are RTL modules primarily responsible for instantiating and utilizing lower-level modules. They provide a broader view of the overall design architecture.
        2. **Low-Level Modules**: These RTL modules contain detailed logic implementations, offering a more nuanced understanding of the control scheme.
    2. **Module assignment:**
        1. Each student will be randomly assigned with **2** high-level modules and **2** low-level modules.
        2. Assignment will be listed in a sheet posted in both Canvas and Piazza
    3. **Documentation format:**
        1. Summary of the code file
        2. Line by line comments of the code (meaningless lines can be skipped, e.g., “begin”, “end”, parentheses…)
        3. [Example code documentation](assets/examples)
    4. **Submission:**
        1. All documented code pieces
            1. Summary of the code file in a separate txt file
            2. Line by line in code comments
        2. Do not change the original code file name
    5. The source code is adapted from: https://github.com/IBM/AccDNN 
3. **Submission Format:** 
    1. Copy the [makefile](Makefile) to your folder containing paper summary txt and documented code pieces
        1. Double check the zip file contain necessary contents
    2. **`make submit`**
    3. Rename submission.zip to <you_gt_user_name>.zip
    4. Make sure the zip file containing the paper summary txt and documented code pieces

**Due:** Oct. 23th 11:59PM EST

**Grading Policy**: 

1. Paper summary (30 points): 
    1. **Abstract (6 points)**
        - Clarity and conciseness: 3 points
        - Accurate representation of the paper's main contributions: 3 points
    2. **Motivation (6 points)**
        - Explanation of the paper's significance: 3 points
        - Relevance to the preceding working and existing solutions: 3 points
    3. **Methods (6 points)**
        - Clarity in outlining key technical aspects: 4 points
        - Depth of understanding: 2 points
    4. **Effectiveness (6 points)**
        - Discussion of the paper's experimental validation: 4 points
        - Critical evaluation of the results: 2 points
    5. **Summary (3 points)**
        - Overall assessment of the paper: 2 points
        - Coherence and flow of the summary: 1 points
    6. **Formatting and Structure (3 points)**
        - Adherence to guidelines: 2 points
        - Grammar and spelling: 1 points
2. Code documentation (17.5 points / code file; 70 points in total):
    1. **Summary of the Code File (7.5 points)**
        - Clarity and conciseness: 3.5 points
        - Accurate representation of the code's main functionalities: 4 points
    2. **Line-by-Line Comments (10 points)**
        - Completeness: Covering all meaningful lines of code: 5 points
        - Clarity: Making complex or non-intuitive lines understandable: 5 points

3. Late submission policy: 3 hours grace period for potential canvas submission issues; 10% per day late, up to 3 days. No credit will be given for submissions later than 3 days.

**Bonus Points (15 points)**: 

- Having gained a foundational understanding of the design and implementation of accelerators from academia, are you interested in exploring how industry-grade accelerators are developed? For this bonus assignment, you will **delve into the architecture and codebase of NVIDIA's Deep Learning Accelerator (NVDLA), a leading example of an industry-grade AI accelerator.**
- This assignment is both challenging and open-ended, offering you considerable latitude in your approach. Your primary task is to
    - Choose one or more modules within the NVDLA architecture that interest you.
        - Document the code, focusing on its structure, functionality, and any unique features.
- NVDLA source code: https://github.com/nvdla/hw/tree/nvdlav1/vmod/nvdla
- NVDLA documentation: http://nvdla.org/hw/v1/hwarch.html
- Grading:
    - Two modules’ full documentation at [this level](https://github.com/nvdla/hw/blob/nvdlav1/vmod/nvdla/cmac/NV_NVDLA_CMAC_CORE_MAC_mul.v) will lead to full points
    - Your documentation will be scaled with the above level


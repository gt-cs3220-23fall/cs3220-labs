# CS3220 Lab #7 : On-chip Communication Protocols

100 pts in total, will be rescaled into 11.25% of your final score of the course.  

**Part 1: AXI-Stream FIFO**: 40 pts

**Part 2: AXI4 RAM**: 60 pts + 10 bonus pts

***Submission ddl***: Nov 27th

In this lab, you will delve into the robust and scalable on-chip communication protocol, AXI4, along with its streaming variant, AXI-Stream. The objective is to design and implement FIFOs/RAMs that leverage these two protocols for content reading and writing. While the previous lab focused on a straightforward register-based communication protocol for data exchange between the CPU and ALU, it lacked the scalability and robustness required for intricate communication scenarios. Such scenarios might involve more advanced modules, like a systolic array. Building on the knowledge gained in this assignment, the subsequent lab will guide you in utilizing the FIFOs/RAMs you've crafted to interconnect components within a sophisticated heterogeneous system.

## Part 1: AXI-Stream FIFO: 

In this section, you'll finish the implementation of an AXI-Stream FIFO. Please refer to [Lecture xx](404.com) ~ [Lecture xx](404.com) for the details of AXI-Stream protocol. Please also refer to the FAQ section for more design references.

The code skeleton is provided in [axi_stream_fifo.v](links/to/axi_stream_fifo.v). Finish all the TODOs in the code.

To test your implementation, run the following command:

```./run.sh axi_stream_fifo```

The test script is based on the testbench provided in [axi_stream_fifo_tb.v](links/to/axi_stream_fifo_tb.v).







## Part 2: AXI4 RAM (60 points + 10 bonus pts)
In this section, you'll finish the implementation of an AXI4 RAM. Please refer to [Lecture xx](404.com) ~ [Lecture xx](404.com) for the details of AXI4 protocol. Please also refer to the FAQ section for more design references.

The code skeleton is provided in [axi4_ram.v](links/to/axi4_ram.v). Finish all the TODOs in the code.

To test your implementation, run the following command:

```./run.sh axi4_ram```

The test script is based on the testbench provided in [axi4_ram_tb.v](links/to/axi4_ram_tb.v).

## Submission

+ Provide a zip file containing your source code. Generate the submission.zip file using the command `make submit`. Avoid manual zip file creation to prevent any issues with the autograding script, which could lead to a 30% score deduction.
* Late submission policy: 3 hours grace period for potential canvas submission issues; 10% per day late, up to 3 days. No credit will be given for submissions later than 3 days.



## FAQ 
[Q] Useful links to refer to for AXI4 design?\
[A] Official AXI4 specification: [link1](https://developer.arm.com/documentation/ihi0022/g/) [link2](https://documentation-service.arm.com/static/642583d7314e245d086bc8c9?token=); Handy timing diagrams from Xilinx: [link3](https://docs.google.com/presentation/d/1fUulgpJMmuZ_iGeoqGIIaTosDAveB6BM/edit?usp=sharing&ouid=103731133449796992574&rtpof=true&sd=true); Another set of diagrams from Oakland University: [link4](https://www.secs.oakland.edu/~llamocca/Courses/ECE495/Notes%20-%20Unit%205.pdf) 



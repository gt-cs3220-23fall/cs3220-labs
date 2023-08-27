# Lab1Part0

Follow this [document](https://docs.google.com/document/d/1AEyVnDq-EX87BF8rP6L7kGDFoxXFHFT3Fsqeemnlcyk/edit?usp=sharing) from lab0 to request an interactive desktop and setup experiment environment.

Then, run `source /storage/ice-shared/cs3220/labs_setup.sh` in your terminal.

## Ready to run?
Step 0: go back to home folder and then download the testing file from repo 
```
cd ~
git clone https://github.com/gt-cs3220-23fall/cs3220-labs.git
```

Step 1: Change to the path of part0 and compile the verilog module of **adder_var_seq**. 
```
cd cs3220-labs/lab1/part0
verilator --cc adder_var_seq.v --top-module adder_var_seq
```

Step 2: Pls take a look at the **adder_var_seq.cpp** in the current folder. The detail explainations are listed inside the  **adder_var_seq.cpp**.

Step 3: Compile the executable file
```
verilator -Wall --trace --exe --build -cc adder_var_seq.cpp adder_var_seq.v
```

Step 4: Run the exectuable file and obtain the waveform file (.vcd)
```
./obj_dir/Vadder_var_seq
```

Step 5: Open the GTKWave to visualize the generated trace:

```
# in your terminal, type in
gtkwave
```

open "File" -> "Open New Tab" -> "Select the generated waveform.vcd and click Open" -> "click on Top" -> "Right click the signals below " -> "Recurse Import" -> "Append".
Then all waveforms will show up in the Waves window.

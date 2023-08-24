# Lab1Part0
## system requirment
OS tested: macOS Ventura 13.1

It should theoretically be fine with older macOS versions as well (Monterey, BigSur, Catalina).

## Install all related prerequisites
Some things are here for the sake of completion. Skip any step if you already have it, eg. I expect most people using macOS already have homebrew.

### Install homebrew
Link: https://brew.sh
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Install verilator
Homebrew Link: https://formulae.brew.sh/formula/verilator
```
brew install verilator
```
Please check homebrew link for any dependencies you may need. 


### Install the GTKwave
Homebrew Link: https://formulae.brew.sh/cask/gtkwave
```
brew install --cask gtkwave
```
Please check homebrew link for any dependencies you may need. 



## Ready to run?
Step 0: go back to parent directory and then download the testing file from repo 
```
cd ~
git clone https://github.com/gt-cs3220-23fall/cs3220-labs.git
```

Step 1: compile the verilog module of **adder_var_seq**. 
```
cd cs3220-labs/lab1/part0
verilator --cc adder_var_seq.v --top-module adder_var_seq
```

Step 2: Create the Cpp simulation file for Verilator. Pls take a look at the **adder_var_seq.cpp** in the current folder. The detail explainations are listed inside the **adder_var_seq.cpp**.


Step 3: Compile the executable file
```
verilator -Wall --trace --exe --build -cc adder_var_seq.cpp adder_var_seq.v
```

Step 4: Run the executable file.
Inside `obj_dir` there should be a `Vadder_var_seq` executable. Run it. 
```
./Vadder_var_seq
```

Step 5: Open the GTKWaver to open the generated trace
open "GTKWaver" -> "Open New Tab" -> "Select the generated waveform.vcd" -> "click on Top" -> "Right click the signals below" -> "Recurse Import" -> "Append" 
Then all waveforms will show up in the Waves window.


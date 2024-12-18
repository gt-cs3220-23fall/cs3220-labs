
#
# DESCRIPTION: Verilator Example: Small Makefile
#
# This calls the object directory makefile.  That allows the objects to
# be placed in the "current directory" which simplifies the Makefile.
#
# Copyright 2003-2018 by Wilson Snyder. This program is free software; you can
# redistribute it and/or modify it under the terms of either the GNU
# Lesser General Public License Version 3 or the Perl Artistic License
# Version 2.0.
#
######################################################################
# Check for sanity to avoid later confusion

.PHONY: default tests submit clean

ifneq ($(words $(CURDIR)),1)
 $(error Unsupported: GNU Make cannot build in directories containing spaces, build elsewhere: '$(CURDIR)')
endif

######################################################################

# This is intended to be a minimal example.  Before copying this to start a
# real project, it is better to start with a more complete example,
# e.g. examples/tracing_c.

# If $VERILATOR_ROOT isn't in the environment, we assume it is part of a
# package inatall, and verilator is in your path. Otherwise find the
# binary relative to $VERILATOR_ROOT (such as when inside the git sources).
ifeq ($(VERILATOR_ROOT),)
VERILATOR = verilator
else
export VERILATOR_ROOT
VERILATOR = $(VERILATOR_ROOT)/bin/verilator
endif


PYTHON = python
VL_FLAGS_TEST_AXIS_FIFO += --exe -cc tb_axis_fifo.v --top-module tb_axis_fifo --trace --trace-structs
VL_FLAGS_TEST_AXI4_RAM += --exe -cc tb_axi4_ram.v --top-module tb_axi4_ram --trace --trace-structs --timing 
VL_FLAGS_TEST_AXI4_RAM_BURST += --exe -cc tb_axi4_ram_burst.v --top-module tb_axi4_ram_burst --trace --trace-structs --timing
#VL_FLAGS += --assert -Wall -Wpedantic -Wno-DECLFILENAME -Wno-UNUSED --x-initial unique --x-assign unique
VL_FLAGS += --assert -Wpedantic -Wno-DECLFILENAME -Wno-UNUSED --x-initial unique --x-assign unique
CXXFLAGS += -DVCD_OUTPUT -DDPRINTF
#CXXFLAGS += -DVCD_OUTPUT 
LDFLAGS += 

default:
	@echo "-- VERILATE ----------------"
	$(VERILATOR) $(VL_FLAGS_TEST_AXIS_FIFO) $(VL_FLAGS) test_axis_fifo.cpp axis_data_fifo.v -CFLAGS '$(CXXFLAGS)'
	@echo "-- COMPILE -----------------"
	$(MAKE) -j 4 -C obj_dir -f Vtb_axis_fifo.mk 
	@echo "-- RUN ---------------------"
	obj_dir/Vtb_axis_fifo
	@echo "-- DONE --------------------"
	
axis_data_fifo:
	@echo "-- VERILATE ----------------"
	$(VERILATOR) $(VL_FLAGS_TEST_AXIS_FIFO) $(VL_FLAGS) test_axis_fifo.cpp axis_data_fifo.v -CFLAGS '$(CXXFLAGS)'
	@echo "-- COMPILE -----------------"
	$(MAKE) -j 4 -C obj_dir -f Vtb_axis_fifo.mk
	@echo "-- RUN ---------------------"
	obj_dir/Vtb_axis_fifo > axis_data_fifo.log
	$(PYTHON) data_gen.py parse_log
	@echo "-- DONE --------------------"

axi4_ram:
	@echo "-- VERILATE ----------------"
	$(VERILATOR) $(VL_FLAGS_TEST_AXI4_RAM) $(VL_FLAGS) test_axi4_ram.cpp axi4_ram.v axi4_tester_src_non_burst/*.v -CFLAGS '$(CXXFLAGS)'
	@echo "-- COMPILE -----------------"
	$(MAKE) -j 4 -C obj_dir -f Vtb_axi4_ram.mk
	@echo "-- RUN ---------------------"
	obj_dir/Vtb_axi4_ram
	@echo "-- DONE --------------------"

axi4_ram_burst:
	@echo "-- VERILATE ----------------"
	$(VERILATOR) $(VL_FLAGS_TEST_AXI4_RAM_BURST) $(VL_FLAGS) test_axi4_ram_burst.cpp axi4_ram_burst.v axi4_tester_src_burst/*.v -CFLAGS '$(CXXFLAGS)'
	@echo "-- COMPILE -----------------"
	$(MAKE) -j 4 -C obj_dir -f Vtb_axi4_ram_burst.mk
	@echo "-- RUN ---------------------"
	obj_dir/Vtb_axi4_ram_burst
	@echo "-- DONE --------------------"


axi4_ram_burst_on_non_burst:
	@echo "-- VERILATE ----------------"
	$(VERILATOR) $(VL_FLAGS_TEST_AXI4_RAM_BURST) $(VL_FLAGS) test_axi4_ram_burst.cpp axi4_ram_burst.v axi4_tester_src_non_burst/*.v -CFLAGS '$(CXXFLAGS)'
	@echo "-- COMPILE -----------------"
	$(MAKE) -j 4 -C obj_dir -f Vtb_axi4_ram_burst.mk
	@echo "-- RUN ---------------------"
	obj_dir/Vtb_axi4_ram_burst
	@echo "-- DONE --------------------"

submit: 
	@echo "-- ZIPPING ALL THE FILE ---------"
	zip submission.zip ./*.v ./*.h ./*.vh ./*.cpp ./Makefile

maintainer-copy::
clean mostlyclean distclean maintainer-clean::
	-rm -rf obj_dir *.log *.dmp *.vpd core trace.vcd

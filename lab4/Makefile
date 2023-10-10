
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

.PHONY: submit clean

ifneq ($(words $(CURDIR)),1)
 $(error Unsupported: GNU Make cannot build in directories containing spaces, build elsewhere: '$(CURDIR)')
endif


#zip all the txts and the two folders high_level_modules low_level_modules
submit: 
	@echo "-- ZIPPING ALL THE FILE ---------"
	zip -r submission.zip high_level_modules low_level_modules *.txt

maintainer-copy::
clean mostlyclean distclean maintainer-clean::
	-rm *.zip
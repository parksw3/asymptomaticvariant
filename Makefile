## This is a new, repo Makefile for omicron generations 2022 Apr 21 (Thu)

current: target
-include target.mk

# -include makestuff/perl.def

# vim_session:
#	 bash -cl "vmt"

######################################################################

Sources += $(wildcard *.R)

figure.Rout: figure.R summarize.R simulate.R funs.R
	$(pipeR)

simulate.Rout: simulate.R funs.R
	$(pipeR)

######################################################################
### Makestuff

# Sources += Makefile

Ignore += makestuff
msrepo = https://github.com/dushoff

Makefile: makestuff/00.stamp
makestuff/%.stamp:
	- $(RM) makestuff/*.stamp
	(cd makestuff && $(MAKE) pull) || git clone $(msrepo)/makestuff
	touch $@

-include makestuff/os.mk

-include makestuff/texi.mk
-include makestuff/pipeR.mk
-include makestuff/hotcold.mk

-include makestuff/git.mk
-include makestuff/visual.mk

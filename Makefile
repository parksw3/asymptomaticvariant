## This is a new, repo Makefile for omicron generations 2022 Apr 21 (Thu)

current: target
-include target.mk

# -include makestuff/perl.def

# vim_session:
#	 bash -cl "vmt"

######################################################################

Sources += $(wildcard *.R)

## Simulations functions
funs.Rout: funs.R
	$(wrapR)

## Do some simulations
simulate.Rout: simulate.R funs.rda
	$(pipeR)

summarize.Rout: summarize.R simulate.rds
	$(pipeR)

figure.Rout: figure.R summarize.rda
	$(pipeR)

# figure.ggp.pdf: figure.Rout

######################################################################
### Makestuff

Sources += Makefile

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
-include makestuff/pdfpages.mk

-include makestuff/git.mk
-include makestuff/visual.mk

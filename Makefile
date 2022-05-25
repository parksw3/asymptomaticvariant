## This is a new, repo Makefile for asymptomatic variant 2022 May 17 (Tue)

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

## Do base simulations
simulate_base.Rout: simulate_base.R funs.rda
	$(pipeR)

## make base figure	
figure_base.Rout: figure_base.R simulate_base.rds
	$(pipeR)	

## base diagram
diagram_base.pdf: diagram_base.tex

## Do some simulations
simulate_immune.Rout: simulate_immune.R funs.rda
	$(pipeR)

summarize_immune.Rout: summarize_immune.R simulate_immune.rds
	$(pipeR)

figure_immune.Rout: figure_immune.R summarize_immune.rda
	$(pipeR)
	
diagram_immune.pdf: diagram_immune.tex

## another set of simulations and figures

param_variant.Rout: param_variant.R
	$(wrapR)

simulate_variant.Rout: simulate_variant.R funs.rda param_variant.rda
	$(pipeR)
	
simulate_variant_profile.Rout: simulate_variant_profile.R simulate_variant.rda funs.rda param_variant.rda
	$(pipeR)
	
figure_variant.Rout: figure_variant.R simulate_variant_profile.rda
	$(pipeR)
	
## Simulations functions
funs_pre.Rout: funs_pre.R
	$(wrapR)	
	
## Do supp simulations
simulate_pre.Rout: simulate_pre.R funs_pre.rda
	$(pipeR)

figure_pre.Rout: figure_pre.R simulate_pre.rds
	$(pipeR)

diagram_pre.pdf: diagram_pre.tex

main.pdf: main.tex

######################################################################
## Final-size approach

fs.Rout: fs.R
	$(pipeR)

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

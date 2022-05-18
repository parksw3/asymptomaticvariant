

######################################################################
## Single-pop stuff (cribbed from PopEco
balance <- function(Re, z){
	return(Re*z+log(1-z))
}

## Final size is a function only of Re, if there is no variation in susceptibility
onefs <- function(Re){
	if(Re<=1) return(0)
	bot <- 1-1/Re
	top <- 1-exp(-Re)
	u <- uniroot(balance, c(bot, top), Re=Re)
	return(u$root)
}

## fs <- Vectorize(onefs, "Re")

######################################################################

## General, multi-group with susceptibility

## Given an FoI and a heterogeneous population, find out whether the 
## FoI can balance itself: who is infected, and how infectious are they?
deltaFoI <- function(Lam, props, sig, tau){
	inf <- 1 - exp(Lam*sig)
	newLam <- sum(inf*props*tau)
	return(newLam-Lam)
}

## Given a heterogeneous population, find the final size of the canonical 
## large epidemic by balancing FoI
## FIXME: bot, top not working (unit mismatch!)
epiSize <- function(props, sig, tau){
	Rstart <- sum(props*sig*tau)
	if (Rstart<=1) return(0)

	bot <- 1-1/Rstart
	top <- 1-exp(-Rstart)
	Lam <- uniroot(deltaFoI, c(bot, top), props=props, sig=sig, tau=tau)
	return(Lam)
}

epiSize(1, 2, 2)

library(deSolve)
library(dplyr)

library(shellpipes)

loadEnvironments()

R0 <- 4
pbase <- 0.5
p <- seq(0, 1, length.out=101)
delta <- 0:5 * 0.2
beta_a_ratio <- c(0.25, 0.5, 0.75, 1)

simparam <- expand.grid(p, delta, beta_a_ratio)
names(simparam) <- c("p", "delta", "beta_a_ratio")

simulation_base_sens_fixR0 <- apply(simparam, 1, function(x) {
  baratio <- x[[3]]
  
  beta_s <- R0/(1 + baratio)/5*2
  
  param <- list(
    p=x[[1]],
    delta=x[[2]],
    beta_s=beta_s,
    beta_a=beta_s*x[[3]]
  )
  
  out <- do.call(simulate, c(param, S=1, D0=0))
  
  as.data.frame(append(out, x))
}) %>% bind_rows(.id="sim")

rdsSave(simulation_base_sens_fixR0)

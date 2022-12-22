library(deSolve)
library(dplyr)

library(shellpipes)

loadEnvironments()

p <- seq(0, 1, length.out=101)
delta <- 0:5 * 0.2
beta_a <- c(0.25, 0.5, 0.75, 1) * 4/5

simparam <- expand.grid(p, delta, beta_a)
names(simparam) <- c("p", "delta", "beta_a")

simulation_base_sens <- apply(simparam, 1, function(x) {
  out <- do.call(simulate, c(as.list(x), S=1, D0=0))
  
  as.data.frame(append(out, x))
}) %>% bind_rows(.id="sim")

rdsSave(simulation_base_sens)

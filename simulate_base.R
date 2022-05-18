library(deSolve)
library(dplyr)

library(shellpipes)

loadEnvironments()

p <- seq(0, 1, length.out=101)
delta <- 0:5 * 0.2

simparam <- expand.grid(p, delta)
names(simparam) <- c("p", "delta")

simulation_base <- apply(simparam, 1, function(x) {
  out <- do.call(simulate, c(as.list(x), S=1, D0=0))
  
  as.data.frame(append(out, x))
}) %>% bind_rows(.id="sim")

rdsSave(simulation_base)

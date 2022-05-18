library(dplyr)
library(deSolve)
library(shellpipes)

loadEnvironments()

p <- seq(0, 1, length.out=101)

simulate_orig_profile <- lapply(p, function(p) {
  out <- simulate(S=1, D0=0, p=p)
  
  out$p <- p
  
  out
}) %>% bind_rows(.id="sim")

simulate_var_profile  <- lapply(p, function(p) {
  out <- simulate(S0=tail(simulate_orig, 1)$S_n,
                  D0=tail(simulate_orig, 1)$D_n,
                  p=p,
                  epsilon_s=epsilon_s)
  
  out$D_n <- out$D_n - tail(simulate_orig, 1)$D_n
  
  out$p <- p
  
  out
}) %>% bind_rows(.id="sim")


simulate_var_cross_profile  <- lapply(p, function(p) {
  out <- simulate(S0=tail(simulate_orig, 1)$S_n,
                  D0=tail(simulate_orig, 1)$D_n,
                  p=p,
                  epsilon_s=epsilon_s,
                  epsilon_i=epsilon_i)
  
  out$D_n <- out$D_n - tail(simulate_orig, 1)$D_n
  
  out$p <- p
  
  out
}) %>% bind_rows(.id="sim")

saveEnvironment()

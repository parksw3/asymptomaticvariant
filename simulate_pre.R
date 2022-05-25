library(deSolve)
library(dplyr)

library(shellpipes)

loadEnvironments()

## all presymptomatic transmission
R0 <- 4
D_s <- 3
D_p <- 2
p <- 0

p_pre <- seq(0, 1, length.out=101)
delta <- 0:5 * 0.2
power <- c(-1, 1, 2, 5)

simparam <- expand.grid(p_pre, delta, power)
names(simparam) <- c("p_pre", "delta", "power")

simulation_pre <- apply(simparam, 1, function(x) {
  with(as.list(x), {
    Rpre <- R0 * p_pre
    Rsymp <- R0 * (1-p_pre)
    
    beta_s <- Rsymp/D_s
    beta_p <- Rpre/D_p
    
    if (power==-1) {
      f <- p_pre_to_f(0)
    } else {
      f <- p_pre_to_f(p_pre, power=power)
    }
    
    out <- do.call(simulate_pre, c(as.list(x[-c(1, 3)]), f=f, beta_s=beta_s, beta_p=beta_p, beta_a=0, p=p))
    
    as.data.frame(append(out, x))
  })
  
}) %>% bind_rows(.id="sim")

rdsSave(simulation_pre)

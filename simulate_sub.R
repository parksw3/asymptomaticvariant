library(deSolve)
library(dplyr)

library(shellpipes)

loadEnvironments()

R <- 4
D_p <- 2
D_s <- D_a <- 3
ratio <- 0.75

p_sub <- seq(0, 1, length.out=101) # proportion of subclinical transmission
p_pre_ratio <- 0:5 * 0.2 # proportion of subclinical transmission that is caused by presymptomatic transmission
delta <- 0:5 * 0.2
power <- c(-1, 1, 2, 5)

simparam <- expand.grid(p_sub, p_pre_ratio, delta, power)
names(simparam) <- c("p_sub", "p_pre_ratio", "delta", "power")

simulation_sub <- apply(simparam, 1, function(x) {
  with(as.list(x), {
    # what we're given
    # Rtotal = p * Rasymp + (1-p) * Rsymp + Rpre
    # p_sub = (p * Rasymp + Rpre)/Rtotal
    # p_pre_ratio = Rpre/(p * Rasymp + Rpre)
    # Rasymp/Rsymp = ratio
    # R = Rsymp + Rpre
    
    # Rtotal = p * Rasymp + (1-p) * Rsymp + Rpre
    # p_sub * (p * Rasymp + (1-p) * Rsymp + Rpre) = p * Rasymp + Rpre
    # p * Rasymp + Rpre = Rpre/p_pre_ratio
    # p * Rasymp = (1/p_pre_ratio-1) * Rpre
    # p = (1/p_pre_ratio-1) * Rpre/Rasymp 
    # p= (1/p_pre_ratio-1) * Rpre * 1/ratio/Rsymp
    
    # p_sub * ((1/p_pre_ratio) * Rpre + (1-p) * Rsymp) = (1/p_pre_ratio) * Rpre
    
    # (1-p) * Rsymp= Rsymp-(1/p_pre_ratio-1) * Rpre/ratio
    
    # (1/p_pre_ratio) * Rpre + Rsymp -(1/p_pre_ratio-1) * Rpre/ratio = Rpre/p_pre_ratio/p_sub
    # (1/p_pre_ratio) + Rsymp/Rpre - (1/p_pre_ratio-1)/ratio = 1/p_pre_ratio/p_sub
    # Rsymp/Rpre = 1/p_pre_ratio/p_sub - 1/p_pre_ratio + (1/p_pre_ratio-1)/ratio 
    # Rsymp/Rpre = 1/p_pre_ratio * (1/p_sub - 1) + (1/p_pre_ratio-1)/ratio = y
    if (p_pre_ratio==0) {
      Rpre <- 0
      Rsymp <- R
      Rasymp <- Rsymp * ratio
      
      p <- p_sub * Rsymp/(p_sub * Rsymp + Rasymp - p_sub * Rasymp)
    } else {
      y <- 1/p_pre_ratio * (1/p_sub - 1) + (1/p_pre_ratio-1)/ratio
      Rpre <- R/(1+y)
      Rsymp <- R - Rpre
      Rasymp <- Rsymp * ratio
      p <- (1/p_pre_ratio-1) * Rpre/Rasymp 
      
      if (p_sub==1) {
        if (p_pre_ratio==1) {
          p <- 0
        } else {
          p <- 1
        }
      } 
    }
    
    beta_s <- Rsymp/D_s
    beta_p <- Rpre/D_p
    beta_a <- Rasymp/D_a
    
    p_pre <- Rpre/(Rpre + Rsymp)
    
    if (power==-1) {
      f <- p_pre_to_f(0)
    } else {
      f <- p_pre_to_f(p_pre, power=power)
    }
    
    out <- do.call(simulate_pre, list(delta=delta, 
                                   beta_s=beta_s, 
                                   beta_p=beta_p, 
                                   beta_a=beta_a,
                                   f=f,
                                   p=p))
    
    as.data.frame(append(out, x))
  })
}) %>% bind_rows(.id="sim")

rdsSave(simulation_sub)

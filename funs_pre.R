model_pre <- function(t, y, parms) {
  with(as.list(c(parms, y)), {
    foi <- (beta_p * Ip + beta_a * Ia + (1 - delta) * beta_s * Is)
    
    dS <- - foi * S
    
    dE <- foi * S - mu * E
    dIp <- mu * E - sigma * Ip
    dIa <- p * sigma * Ip - gamma * Ia
    dIs <- (1-p) * sigma * Ip - gamma * Is
    dR <- gamma * Ia + (1-f) * gamma * Is
    dD <- f * gamma * Is
    
    list(c(dS, dE, dIp, dIa, dIs, dR, dD),
         dD=dD)
  })
}

simulate_pre <- function(N=1,
                         beta_a,
                         beta_s,
                         beta_p,
                         mu=1/2,
                         sigma=1/2,
                         gamma=1/3,
                         delta=0.8,
                         f=0.01,
                         p=0.5,
                         tvec=seq(0, 365, by=1),
                         I0=1e-4) {
  y0 <- c(S=N-I0, E=0, Ip=I0, Ia=0, Is=0, R=0, D=0)
  
  parms <- c(beta_a=beta_a, beta_s=beta_s, beta_p=beta_p, mu=mu, sigma=sigma, gamma=gamma, delta=delta, f=f, p=p)
  
  out <- as.data.frame(ode(y0, tvec, model_pre, parms))
  
  out
}

p_pre_to_f <- function(x, f=0.01, 
                       power=1) {
  f * (1 - x^power)
}

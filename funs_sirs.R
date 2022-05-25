model_sirs <- function(t, y, parms) {
  with(as.list(c(parms, y)), {
    beta <- beta * (1 + phi * cos(2 * pi * t/365))
    
    foi <- (beta * (Ia_n + Ia_p) + (1 - delta) * beta * (Is_n + Is_p))
    
    dS_n <- b - foi * S_n - b * S_n ## naive
    dS_p <- sigma * R_n + sigma * R_p - (1-epsilon_i) * foi * S_p - b * S_p ## protected
    
    dE_n <- foi * S_n - mu * E_n- b * E_n
    dIa_n <- p * mu * E_n - gamma * Ia_n - b * Ia_n
    dIs_n <- (1-p) * mu * E_n - gamma * Is_n - b * Is_n
    
    dR_n <- gamma * Ia_n + (1-f) * gamma * Is_n - b * R_n - sigma * R_n
    
    dD_n <- f * gamma * Is_n
    
    dE_p <- (1-epsilon_i) * foi * S_p - mu * E_p - b * E_p
    dIa_p <- (1-(1-epsilon_s) * (1-p)) * mu * E_p - gamma * Ia_p - b * Ia_p
    dIs_p <- (1-epsilon_s) * (1-p) * mu * E_p - gamma * Is_p - b * Ia_p
    
    dR_p <- gamma * Ia_p + (1-(1-epsilon_d) * f) * gamma * Is_p - b * R_p - sigma * R_p
    
    dD_p <- (1-epsilon_d) * f * gamma * Is_p
    
    list(c(dS_n, dS_p, dE_n, dIa_n, dIs_n, dR_n, dD_n, dE_p, dIa_p, dIs_p, dR_p, dD_p),
         dD_n=dD_n, dD_p=dD_p)
  })
}

simulate_sirs <- function(N=1,
                     S0=1,
                     D0=0,
                     beta=4/5,
                     mu=1/2,
                     gamma=1/5,
                     delta=0.9,
                     sigma=1/365,
                     b=1/365/80,
                     f=0.01,
                     p=0.25,
                     phi=0.1,
                     epsilon_i=0,
                     epsilon_s=0,
                     epsilon_d=0,
                     tvec=seq(0, 5*365, by=1),
                     I0=1e-4) {
  y0 <- c(S_n=S0-I0, S_p=1-S0-D0, E_n=0, Ia_n=p * I0, Is_n=(1-p) * I0,  R_n=0, D_n=D0, E_p=0, Ia_p=0, Is_p=0, R_p=0, D_p=0)
  
  parms <- c(beta=beta, mu=mu, gamma=gamma, delta=delta, f=f, p=p, epsilon_i=epsilon_i, epsilon_s=epsilon_s, epsilon_d=epsilon_d,
             sigma=sigma, b=b, phi=phi)
  
  out <- as.data.frame(ode(y0, tvec, model_sirs, parms))
  
  out
}

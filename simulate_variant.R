library(deSolve)
library(shellpipes)

loadEnvironments()

simulate_orig <- simulate(N=1,
                          S0=1,
                          delta=delta,
                          p=p_orig,
                          tvec=tvec_orig)

simulate_var1 <- simulate(N=1,
                          S0=tail(simulate_orig, 1)$S_n,
                          D0=tail(simulate_orig, 1)$D_n,
                          delta=delta,
                          p=p_var1,
                          tvec=tvec_var,
                          epsilon_s=epsilon_s)

simulate_var1_cross <- simulate(N=1,
                          S0=tail(simulate_orig, 1)$S_n,
                          D0=tail(simulate_orig, 1)$D_n,
                          delta=delta,
                          p=p_var1,
                          tvec=tvec_var,
                          epsilon_i=epsilon_i,
                          epsilon_s=epsilon_s)

simulate_var2 <- simulate(N=1,
                          S0=tail(simulate_orig, 1)$S_n,
                          D0=tail(simulate_orig, 1)$D_n,
                          delta=delta,
                          p=p_var2,
                          tvec=tvec_var,
                          epsilon_s=epsilon_s)

simulate_var2_cross <- simulate(N=1,
                                S0=tail(simulate_orig, 1)$S_n,
                                D0=tail(simulate_orig, 1)$D_n,
                                delta=delta,
                                p=p_var2,
                                tvec=tvec_var,
                                epsilon_i=epsilon_i,
                                epsilon_s=epsilon_s)

saveEnvironment()

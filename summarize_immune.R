library(dplyr)

library(shellpipes)

simulate_immune <- rdsRead()

outsumm <- . %>%
  group_by(sim) %>%
  filter(time==max(time)) %>%
  ungroup

simulate_immune_i <- simulate_immune %>%
  filter(epsilon_s==0, epsilon_d==0)

simulate_immune_s <- simulate_immune %>%
  filter(epsilon_i==0, epsilon_d==0)

simulate_immune_d <- simulate_immune %>%
  filter(epsilon_i==0, epsilon_s==0)

simulate_immune_i_summarize <- simulate_immune_i %>%
  outsumm

simulate_immune_s_summarize <- simulate_immune_s %>%
  outsumm

simulate_immune_d_summarize <- simulate_immune_d %>%
  outsumm

saveEnvironment()

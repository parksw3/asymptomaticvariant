library(dplyr)

library(shellpipes)

allout <- rdsRead()

outsumm <- . %>%
  group_by(sim) %>%
  filter(time==max(time)) %>%
  ungroup

allout_i <- allout %>%
  filter(epsilon_s==0, epsilon_d==0)

allout_s <- allout %>%
  filter(epsilon_i==0, epsilon_d==0)

allout_d <- allout %>%
  filter(epsilon_i==0, epsilon_s==0)

allout_i_summarize <- allout_i %>%
  outsumm

allout_s_summarize <- allout_s %>%
  outsumm

allout_d_summarize <- allout_d %>%
  outsumm

saveEnvironment()

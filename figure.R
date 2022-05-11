library(ggplot2); theme_set(theme_bw())

ggplot(allout_i_summarize) +
  geom_line(aes(p, D_p+D_n, col=factor(epsilon_i))) +
  scale_x_continuous("Proportion asymptomatic")

ggplot(allout_s_summarize) +
  geom_line(aes(p, D_p+D_n, col=factor(epsilon_s))) +
  scale_x_continuous("Proportion asymptomatic")

ggplot(allout_d_summarize) +
  geom_line(aes(p, D_p+D_n, col=factor(epsilon_d))) +
  scale_x_continuous("Proportion asymptomatic")

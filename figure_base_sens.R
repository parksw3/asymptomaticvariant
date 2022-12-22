library(dplyr)
library(ggplot2); theme_set(theme_bw(base_family="Times", base_size = 14))
library(egg)
library(shellpipes)

simulate_base_sens <- rdsRead()

simulate_base_max <- simulate_base_sens %>%
  group_by(sim) %>%
  filter(
    time==max(time)
  ) %>%
  mutate(
    beta_a=factor(beta_a, 
                  levels=c(0.2, 0.4, 0.6, 0.8),
                  labels=c(expression(beta[a]==0.25~beta[s],
                                      beta[a]==0.5~beta[s],
                                      beta[a]==0.75~beta[s],
                                      beta[a]==beta[s])))
  )

g1 <- ggplot(simulate_base_max) +
  geom_line(aes(p, D_n, col=factor(delta), group=factor(delta))) +
  scale_x_continuous("Proportion asymptomatic", 
                     breaks=c(0, 0.2, 0.4, 0.6, 0.8, 1),
                     labels=c("0", "0.2", "0.4", "0.6", "0.8", "1"),
                     expand=c(0, 0)) +
  scale_y_continuous("Proportion deceased",
                     limits=c(0, 0.01),
                     expand=c(0, 0)) +
  scale_color_viridis_d(expression(delta)) +
  facet_wrap(~beta_a, labeller = label_parsed) +
  theme(
    panel.grid = element_blank(),
    legend.position = "right"
  )

saveGG(g1, width=6, height=4)

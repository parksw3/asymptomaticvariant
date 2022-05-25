library(dplyr)
library(ggplot2); theme_set(theme_bw(base_family="Times", base_size = 14))
library(egg)
library(shellpipes)

simulate_pre <- rdsRead()

simulate_pre_max <- simulate_pre %>%
  group_by(sim) %>%
  filter(
    time==max(time)
  ) %>%
  mutate(
    power=paste0("f(theta)==f[0](1-theta^", power, ")"),
    power=factor(power,
                 levels=paste0("f(theta)==f[0](1-theta^", c(1, 2, 5, 10), ")"))
  )

g1 <- ggplot(simulate_pre_max) +
  geom_line(aes(p_pre, D, col=factor(delta), group=factor(delta))) +
  scale_x_continuous(expression(Proportion~presymptomatic~"transmission,"~theta), 
                     breaks=c(0, 0.2, 0.4, 0.6, 0.8, 1),
                     labels=c("0", "0.2", "0.4", "0.6", "0.8", "1"),
                     expand=c(0, 0)) +
  scale_y_continuous("Proportion deceased",
                     limits=c(0, 0.01),
                     expand=c(0, 0)) +
  scale_color_viridis_d(expression(delta)) +
  facet_wrap(~power, labeller = label_parsed) +
  theme(
    panel.grid = element_blank(),
    strip.background = element_blank(),
    legend.position = "right"
  )

saveGG(g1, width=8, height=6)


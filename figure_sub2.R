library(dplyr)
library(ggplot2); theme_set(theme_bw(base_family="Times", base_size = 14))
library(egg)
library(shellpipes)

simulate_sub <- rdsRead()

simulate_sub_max <- simulate_sub %>%
  group_by(sim) %>%
  filter(
    time==max(time)
  ) %>%
  mutate(
    power=paste0("f(phi)==f[0](1-phi^", power, ")"),
    power=factor(power,
                 levels=paste0("f(phi)==f[0](1-phi^", c(-1, 1, 2, 5), ")"),
                 labels=c("No~tradeoff", paste0("f(phi)==f[0](1-phi^", c(1, 2, 5), ")"))),
    p_pre_ratio=factor(paste0(p_pre_ratio*100, "*\'%\'"),
                       levels=paste0(0:5*0.2*100, "*\'%\'"))
  )

g1 <- ggplot(simulate_sub_max) +
  geom_line(aes(p_sub, D, col=factor(delta), group=factor(delta))) +
  scale_x_continuous(expression(Proportion~subclinical~"transmission,"~phi), 
                     breaks=c(0, 0.2, 0.4, 0.6, 0.8, 1),
                     labels=c("0", "0.2", "0.4", "0.6", "0.8", "1"),
                     expand=c(0, 0)) +
  scale_y_continuous("Proportion deceased",
                     limits=c(0, 0.0103),
                     expand=c(0, 0)) +
  scale_color_viridis_d(expression(delta)) +
  facet_grid(p_pre_ratio~power, labeller = label_parsed) +
  theme(
    panel.grid = element_blank(),
    strip.background = element_blank(),
    legend.position = "right"
  )

saveGG(g1, width=8, height=8)


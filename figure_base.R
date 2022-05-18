library(dplyr)
library(ggplot2); theme_set(theme_bw(base_family="Times", base_size = 16))
library(egg)
library(shellpipes)

startGraphics()

simulate_base <- rdsRead()

simulate_base_max <- simulate_base %>%
  group_by(sim) %>%
  filter(
    time==max(time)
  )

g1 <- ggplot(simulate_base_max) +
  geom_line(aes(p, 1-S_n, col=factor(delta), group=factor(delta))) +
  scale_x_continuous("Proportion asymptomatic", 
                     breaks=c(0, 0.2, 0.4, 0.6, 0.8, 1),
                     labels=c("0", "0.2", "0.4", "0.6", "0.8", "1"),
                     expand=c(0, 0)) +
  scale_y_continuous("Proportion infected",
                     limits=c(0, 1),
                     expand=c(0, 0)) +
  scale_color_viridis_d(expression(delta)) +
  theme(
    panel.grid = element_blank(),
    legend.position = c(0.8, 0.45)
  )

g2 <- ggplot(simulate_base_max) +
  geom_line(aes(p, D_n, col=factor(delta), group=factor(delta))) +
  scale_x_continuous("Proportion asymptomatic", 
                     breaks=c(0, 0.2, 0.4, 0.6, 0.8, 1),
                     labels=c("0", "0.2", "0.4", "0.6", "0.8", "1"),
                     expand=c(0, 0)) +
  scale_y_continuous("Proportion deceased",
                     limits=c(0, 0.01),
                     expand=c(0, 0)) +
  scale_color_viridis_d(expression(delta)) +
  theme(
    panel.grid = element_blank(),
    legend.position = "none"
  )

gfinal <- ggarrange(g1, g2, nrow=1, draw=FALSE)

saveGG(gfinal, width=8, height=3)

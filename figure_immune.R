library(ggplot2); theme_set(theme_bw(base_family="Times"))
library(egg)
library(shellpipes)

startGraphics()

loadEnvironments()

ymax <- 0.0052

g1 <- ggplot(simulate_immune_i_summarize) +
  geom_line(aes(p, (D_p+D_n), col=factor(epsilon_i))) +
  scale_x_continuous("Proportion asymptomatic", 
                     breaks=c(0, 0.2, 0.4, 0.6, 0.8, 1),
                     labels=c("0", "0.2", "0.4", "0.6", "0.8", "1"),
                     expand=c(0, 0)) +
  scale_y_continuous("Proportion deceased",
                     limits=c(0, ymax),
                     expand=c(0, 0)) +
  scale_color_viridis_d("Protection", option="B", end=0.9) +
  ggtitle("A. Protection against\ninfection") +
  theme(
    panel.grid = element_blank(),
    legend.position = "none"
  )

g2 <- ggplot(simulate_immune_s_summarize) +
  geom_line(aes(p, (D_p+D_n), col=factor(epsilon_s))) +
  scale_x_continuous("Proportion asymptomatic", 
                     breaks=c(0, 0.2, 0.4, 0.6, 0.8, 1),
                     labels=c("0", "0.2", "0.4", "0.6", "0.8", "1"),
                     expand=c(0, 0)) +
  scale_y_continuous("Proportion deceased",
                     limits=c(0, ymax),
                     expand=c(0, 0)) +
  scale_color_viridis_d("Protection", option="B", end=0.9) +
  ggtitle("B. Protection against\nsymptoms") +
  theme(
    panel.grid = element_blank(),
    legend.position = "none"
  )

g3 <- ggplot(simulate_immune_d_summarize) +
  geom_line(aes(p, (D_p+D_n), col=factor(epsilon_d))) +
  scale_x_continuous("Proportion asymptomatic", 
                     breaks=c(0, 0.2, 0.4, 0.6, 0.8, 1),
                     labels=c("0", "0.2", "0.4", "0.6", "0.8", "1"),
                     expand=c(0, 0)) +
  scale_y_continuous("Proportion deceased",
                     limits=c(0, ymax),
                     expand=c(0, 0)) +
  scale_color_viridis_d(expression(epsilon), option="B", end=0.9) +
  ggtitle("C. Protection against\ndeaths") +
  theme(
    panel.grid = element_blank(),
    legend.position = "right"
  )

gfinal <- ggarrange(g1, g2, g3, nrow=1, draw=FALSE)

saveGG(gfinal, width=8, height=3)

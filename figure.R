library(ggplot2); theme_set(theme_bw(base_family="Times"))
library(egg)
library(shellpipes)

startGraphics()

loadEnvironments()

pop <- 1e7

g1 <- ggplot(allout_i_summarize) +
  geom_line(aes(p, (D_p+D_n) * pop, col=factor(epsilon_i))) +
  scale_x_continuous("Proportion asymptomatic") +
  scale_y_continuous("Total deaths") +
  scale_color_viridis_d("VE") +
  ggtitle("A. Protection against infection") +
  theme(
    panel.grid = element_blank(),
    legend.position = c(0.85, 0.7)
  )

g2 <- ggplot(allout_s_summarize) +
  geom_line(aes(p, D_p+D_n, col=factor(epsilon_s))) +
  scale_x_continuous("Proportion asymptomatic") +
  scale_y_continuous("Total deaths") +
  scale_color_viridis_d("VE") +
  ggtitle("B. Protection against symptoms") +
  theme(
    panel.grid = element_blank(),
    legend.position = "none"
  )

g3 <- ggplot(allout_d_summarize) +
  geom_line(aes(p, D_p+D_n, col=factor(epsilon_d))) +
  scale_x_continuous("Proportion asymptomatic") +
  scale_y_continuous("Total deaths") +
  scale_color_viridis_d("VE") +
  ggtitle("C. Protection against deaths") +
  theme(
    panel.grid = element_blank(),
    legend.position = "none"
  )

gfinal <- ggarrange(g1, g2, g3, nrow=1, draw=FALSE)

saveGG(gfinal, width=12, height=4)

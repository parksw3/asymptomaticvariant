library(ggplot2); theme_set(theme_bw(base_family="Times"))
library(gridExtra)
library(egg)
library(shellpipes)

startGraphics()

loadEnvironments()

ymax <- 0.0052
ymax2 <- 0.19
ymax3 <- 0.000155

simulate_orig_profile_summarize <- simulate_orig_profile %>%
  group_by(sim) %>%
  filter(time==max(time)) %>%
  mutate(
    type="Resident"
  )

simulate_var_profile_summarize <- simulate_var_profile %>%
  group_by(sim) %>%
  filter(time==max(time)) %>%
  mutate(
    type="Invading"
  )

simulate_var_cross_profile_summarize <- simulate_var_cross_profile %>%
  group_by(sim) %>%
  filter(time==max(time)) %>%
  mutate(
    type="Invading"
  )

g1 <- ggplot(simulate_orig_profile_summarize, aes(p, (D_p+D_n), lty=type)) +
  #annotate("segment", x=p_orig, y=tail(simulate_orig$D_p+simulate_orig$D_n, 1),
  #         xend=p_var1, yend=tail(simulate_var1$D_p+simulate_var1$D_n, 1)-tail(simulate_orig$D_p+simulate_orig$D_n, 1)-0.00015,
  #         arrow = arrow(length=unit(0.1, "inches")), col="orange") +
  #annotate("segment", x=p_orig, y=tail(simulate_orig$D_p+simulate_orig$D_n, 1),
  #         xend=p_var2-0.03, yend=tail(simulate_var2$D_p+simulate_var2$D_n, 1)-tail(simulate_orig$D_p+simulate_orig$D_n, 1),
  #         arrow = arrow(length=unit(0.1, "inches")), col="purple") +
  geom_line() +
  geom_line(data=simulate_var_profile_summarize) +
  geom_point(x=p_orig, y=tail(simulate_orig$D_p+simulate_orig$D_n, 1), size=3) +
  geom_point(x=p_var1, y=tail(simulate_var1$D_p+simulate_var1$D_n, 1)-tail(simulate_orig$D_p+simulate_orig$D_n, 1), col="orange", size=3, shape="triangle") +
  geom_point(x=p_var2, y=tail(simulate_var2$D_p+simulate_var2$D_n, 1)-tail(simulate_orig$D_p+simulate_orig$D_n, 1), col="purple", size=3, shape="square") +
  scale_x_continuous("Proportion asymptomatic", 
                     breaks=c(0, 0.2, 0.4, 0.6, 0.8, 1),
                     labels=c("0", "0.2", "0.4", "0.6", "0.8", "1"),
                     expand=c(0, 0)) +
  scale_y_continuous("Proportion deceased",
                     limits = c(0, ymax),
                     expand=c(0, 0)) +
  ggtitle("A. Without cross protection against infection") +
  scale_linetype_manual("Variant", values=c(2, 1)) +
  theme(
    panel.grid = element_blank(),
    legend.position = c(0.8, 0.8),
    legend.background = element_rect(fill=NA)
  )

g2 <- ggplot(simulate_orig, aes(time, Ia_n + Is_n + Ia_p + Is_p)) +
  geom_line() +
  geom_line(data=simulate_var1, col="orange", lty=2) +
  geom_line(data=simulate_var2, col="purple", lty=2) +
  scale_x_continuous("Time (days)", expand=c(0, 0)) +
  scale_y_continuous("Infection\nprevalence", expand=c(0, 0), limits=c(0, ymax2)) +
  ggtitle("B") +
  theme(
    panel.grid = element_blank()
  )

g3 <- ggplot(simulate_orig, aes(time, dD_n + dD_p)) +
  geom_line() +
  geom_line(data=simulate_var1, col="orange", lty=2) +
  geom_line(data=simulate_var2, col="purple", lty=2) +
  scale_x_continuous("Time (days)", expand=c(0, 0)) +
  scale_y_continuous("Daily deaths", limits=c(0, ymax3), expand=c(0, 0)) +
  ggtitle("C") +
  theme(
    panel.grid = element_blank()
  )

gcomb1 <- ggarrange(g2, g3, nrow=2, draw=FALSE)

g4 <- ggplot(simulate_orig_profile_summarize, aes(p, (D_p+D_n), lty=type)) +
  #annotate("segment", x=p_orig, y=tail(simulate_orig$D_p+simulate_orig$D_n, 1),
  #         xend=p_var1, yend=tail(simulate_var1_cross$D_p+simulate_var1_cross$D_n, 1)-tail(simulate_orig$D_p+simulate_orig$D_n, 1)+0.00015,
  #         arrow = arrow(length=unit(0.1, "inches")), col="orange") +
  #annotate("segment", x=p_orig, y=tail(simulate_orig$D_p+simulate_orig$D_n, 1),
  #         xend=p_var2, yend=tail(simulate_var2_cross$D_p+simulate_var2_cross$D_n, 1)-tail(simulate_orig$D_p+simulate_orig$D_n, 1)+0.00015,
  #         arrow = arrow(length=unit(0.1, "inches")), col="purple") +
  geom_line() +
  geom_line(data=simulate_var_cross_profile_summarize) +
  geom_point(x=p_orig, y=tail(simulate_orig$D_p+simulate_orig$D_n, 1), size=3) +
  geom_point(x=p_var1, y=tail(simulate_var1_cross$D_p+simulate_var1_cross$D_n, 1)-tail(simulate_orig$D_p+simulate_orig$D_n, 1), col="orange", size=3, shape="triangle") +
  geom_point(x=p_var2, y=tail(simulate_var2_cross$D_p+simulate_var2_cross$D_n, 1)-tail(simulate_orig$D_p+simulate_orig$D_n, 1), col="purple", size=3, shape="square") +
  scale_x_continuous("Proportion asymptomatic", 
                     breaks=c(0, 0.2, 0.4, 0.6, 0.8, 1),
                     labels=c("0", "0.2", "0.4", "0.6", "0.8", "1"),
                     expand=c(0, 0)) +
  scale_y_continuous("Proportion deceased",
                     limits = c(0, ymax),
                     expand=c(0, 0)) +
  scale_linetype_manual("Variant", values=c(2, 1)) +
  ggtitle("D. With cross protection against infection") +
  theme(
    panel.grid = element_blank(),
    legend.position = "none"
  )

g5 <- ggplot(simulate_orig, aes(time, Ia_n + Is_n + Ia_p + Is_p)) +
  geom_line() +
  geom_line(data=simulate_var1_cross, col="orange", lty=2) +
  geom_line(data=simulate_var2_cross, col="purple", lty=2) +
  scale_x_continuous("Time (days)", expand=c(0, 0)) +
  scale_y_continuous("Infection\nprevalence", expand=c(0, 0), limits=c(0, ymax2)) +
  ggtitle("E") +
  theme(
    panel.grid = element_blank()
  )

g6 <- ggplot(simulate_orig, aes(time, dD_n + dD_p)) +
  geom_line() +
  geom_line(data=simulate_var1_cross, col="orange", lty=2) +
  geom_line(data=simulate_var2_cross, col="purple", lty=2) +
  scale_x_continuous("Time (days)", expand=c(0, 0)) +
  scale_y_continuous("Daily deaths", limits=c(0, ymax3), expand=c(0, 0)) +
  ggtitle("F") +
  theme(
    panel.grid = element_blank()
  )

gcomb2 <- ggarrange(g5, g6, nrow=2, draw=FALSE)

gfinal <- arrangeGrob(g1, gcomb1, g4, gcomb2, widths=c(1, 2))

saveGG(gfinal, target="figure_variant.Rout", width=10, height=6)

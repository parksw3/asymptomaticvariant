library(dplyr)
library(ggplot2); theme_set(theme_bw(base_family = "Times"))
library(egg)
library(gridExtra)
library(shellpipes)

## data from NBA
data <- read.csv("indiv_data.csv") %>%
  mutate(
    symptomatic=factor(symptomatic, 
                       labels=c("Asymptomatic", "Symptomatic"))
  )

## posterior from diamond
posterior <- readRDS("primary.rds")

theta_a <- posterior$output$theta_a
chi <- posterior$output$chi

g1 <- ggplot(chi) +
  geom_histogram(aes(value, y=..density..), color="black", fill=NA) +
  scale_x_continuous("Proportion of asymptomatic infection", limits=c(0, 1)) +
  scale_y_continuous("Density") +
  ggtitle("A. Diamond Princess cruise ship") +
  theme(
    panel.background = element_blank(),
    legend.position = "none",
    strip.background = element_blank(),
    panel.grid = element_blank()
  )

g2 <- ggplot(theta_a) +
  geom_histogram(aes(value, y=..density..), color="black", fill=NA) +
  scale_x_continuous("Relative asymptomatic transmission rate") +
  scale_y_continuous("Density") +
  ggtitle("B. Diamond Princess cruise ship") +
  theme(
    panel.background = element_blank(),
    legend.position = "none",
    strip.background = element_blank(),
    panel.grid = element_blank()
  )

gcomb1 <- ggarrange(g1, g2, ncol=1, draw=FALSE)

g3 <- ggplot(data) +
  geom_point(aes(t, y, col=factor(symptomatic))) +
  # geom_line(aes(t, y, col=factor(symptomatic), group=id), alpha=0.4) +
  geom_smooth(aes(t, y, col=factor(symptomatic), fill=factor(symptomatic))) +
  scale_x_continuous("Time since peak viral load") +
  scale_y_reverse("Ct values") +
  scale_color_manual(values=c("orange", "black")) +
  scale_fill_manual(values=c("orange", "black")) +
  facet_wrap(~symptomatic, ncol=1) +
  ggtitle("C. National Basketball Association (NBA) ") +
  theme(
    panel.background = element_blank(),
    legend.position = "none",
    strip.background = element_blank(),
    panel.grid = element_blank()
  )

gfinal <- arrangeGrob(gcomb1, g3, nrow=1)

saveGG(gfinal, width=8, height=6)
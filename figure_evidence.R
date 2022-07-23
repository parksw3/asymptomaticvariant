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

data_age <- data.frame(
  age=c("0-9", "10-19", "20-29", "30-39", "40-49", "50-59", "60-69", "70+"),
  mean=c(0.29, 0.21, 0.27, 0.33, 0.4, 0.49, 0.63, 0.69),
  lwr=c(0.18, 0.12, 0.18, 0.24, 0.28, 0.37, 0.49, 0.57),
  upr=c(0.44, 0.31, 0.38, 0.43, 0.52, 0.6, 0.76, 0.82)
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

g4 <- ggplot(data_age) +
  geom_point(aes(age, 1-mean)) +
  geom_line(aes(age, 1-mean, group=1), lty=2) +
  geom_errorbar(aes(age, ymin=1-lwr, ymax=1-upr), width=0.2) +
  scale_x_discrete("Age") +
  scale_y_continuous("Inferred proportion of infections that are subclinical") +
  ggtitle("D. Surveillance data from 6 countries") +
  theme(
    panel.grid = element_blank()
  )

gfinal <- arrangeGrob(gcomb1, g3, g4, nrow=1)

saveGG(gfinal, width=12, height=6)
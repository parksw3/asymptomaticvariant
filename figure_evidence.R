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

gamma_p <- 1/2.1
gamma_s <- 1/2.9
gamma_a <- 1/5

theta_a <- posterior$output$theta_a$value
theta_p <- posterior$output$theta_p$value

R_s <- 1/gamma_s + theta_p * 1/gamma_p
R_a <- theta_a * 1/gamma_a

Rratio <- data.frame(
  value=R_a/R_s
)

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

g2 <- ggplot(Rratio) +
  geom_histogram(aes(value, y=..density..), color="black", fill=NA) +
  scale_x_continuous("Relative infectiousness of asymptomatic infection") +
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
library(deSolve)
library(dplyr)

library(shellpipes)

loadEnvironments()

delta <- 0.8

p <- seq(0, 1, length.out=101)
epsilon_i <- epsilon_s <- epsilon_d <- c(0, 0.2, 0.4, 0.6, 0.8)

simparam <- expand.grid(p, epsilon_i, epsilon_s, epsilon_d)
names(simparam) <- c("p", "epsilon_i", "epsilon_s", "epsilon_d")

simparam2 <- simparam %>%
  filter(
    (epsilon_i==0) + (epsilon_s==0) + (epsilon_d==0) >= 2
  )

simulate_immune <- apply(simparam2, 1, function(x) {
  out <- do.call(simulate, c(as.list(x), delta=delta))
  
  as.data.frame(append(out, x))
}) %>% bind_rows(.id="sim")

rdsSave(simulate_immune)


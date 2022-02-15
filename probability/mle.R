library(tidyverse)

tibble(x = seq(-3, 3, 1)) %>% 
  ggplot(aes(x)) + 
  stat_function(
    fun = dnorm, 
    geom = "line"
  ) +
  stat_function(
    fun = dnorm,
    geom = "area",
    fill = "steelblue",
    xlim = c(0.5, 2)) +
  scale_x_continuous(breaks = seq(-3, 3, 1)) +
  annotate("segment", x = 1.85, xend = 1, y = 0.25, yend = 0.15, colour = "pink", size = 2.5, alpha = 0.6, arrow = arrow()) +
  annotate("text", x = 2, y = 0.3, colour = "pink", label = "Probability") +
  labs(y = "Density") +
  hrbrthemes::theme_ft_rc()
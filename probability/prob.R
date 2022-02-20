library(tidyverse)
library(scales)

tibble(heads = 0:10, prob = dbinom(x = 0:10, size = 10, prob = 0.5)) %>%
  mutate(Heads = ifelse(heads == 8, "8", "other")) %>%
  ggplot(aes(x = factor(heads), y = prob, fill = Heads)) +
  theme_minimal()+
  geom_col() +
  geom_text(
    aes(label = round(prob, 2), y = prob + 0.01),
    position = position_dodge(0.9),
    size = 3,
    vjust = 0) +
  labs(title = "Probability of X = 8 successes",
       subtitle = "b(10, .5)",
       x = "Successes (x)",
       y = "probability") 



tibble(rep = 1:10) %>% 
  #resampling the function as many times as you called in the line above
  mutate(samples = map(rep, ~ rnorm(100))) %>%
  #mean of each sample
  mutate(means = map_dbl(samples, ~ mean(.)))


#more simple approach
rerun(10, rnorm(100)) %>%
  map_dbl(~ mean(.))
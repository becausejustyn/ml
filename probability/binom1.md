## Binomial Distribution

The binomial distribution is a **discrete probability distribution**. 

- It describes the outcome of $n$ **independent trials** in an experiment. 
- Each trial is assumed to have only two outcomes, either `success` or `failure`. 

The binomial distribution formula is:

$$
B(k; n, P) = \binom{n}{k} \times P^{k} \times (1-P)^{n-k}
$$

Or sometimes written as

$$
B(x) = \frac{n!}{k!(n-k)!} \times P^{k} \times (1 - P)^{n - k}
$$

where,

- $B$ : binomial probability
- $\binom{n}{k}$ : binomial distribution formula uses factorials $\frac{n!}{k!(n-k)!}$
    - Represents how many distinct ways we can get k `successes` out of n trials. 
- $k$ : total number of `successes` (binary outcome)
- $P$ : probability of a success on an individual trial
- $n$ : number of trials

### Example 1

What is the probability of 8 heads in 10 coin flips where probability of heads is 0.5?

$$
p = 0.5 \\
n = 10 \\
k = 8
$$

Giving us

$$
P(8; 0.5, 10) = \binom{10}{8} 0.5^{8} (1 - 0.5)^{10-8} \approx 0.044
$$

First we use n choose k to see how many distinct ways we can get 8 `successes` from 10 flips or events.

$$\binom{10}{8} = 45$$

With n choose k showing the amount of distinct combinations, the next two terms represent the probability of any one order. $n - k$ is the amount of failures.

$p^{k} = 0.5^{8} \approx 0.004$  
$(1 - p)^{n-k} = (1 - 0.5)^{10-8} = 0.25$

```r
#exact
dbinom(x = 8, size = 10, prob = 0.5)

#manually but slightly less accurate
choose(10, 8) * 0.5^8 * (1 - 0.5) ^ (10 - 8)
```

```r
#simulated
mean(rbinom(n = 10000, size = 10, prob = 0.5) == 8)
```

```r
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
```

### Example 2

What is the probability of <= 8 heads in 10 coin flips where probability of heads is 0.5?

#### Cumulative Distribution Function (CDF)

If we want to know the probability of observing 8 or more `successes` we simply add together the probabilities of observing exactly $8, \dots, n$ heads, which is represented as

$$
\sum_{k = 8}^{10} \binom{10}{k} 0.5^{k} (1 - 0.5)^{10 - k} 
$$

```r
pbinom(8, size = 10, prob = 0.5, lower.tail = FALSE)

# equivalent
1 - pbinom(8, size = 10, prob = 0.5)
```

The odds are slightly better if we want to know the odds of getting 8 or more heads in the 10 flips since it also allows for more possibilities.


### Example 3


### Example 4

### Example 5

Imagine you have two sets of coin flip results.



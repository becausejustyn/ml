# Probability


## Distributions

The general naming structure of the relevant `R` functions is:

- The density (pdf) at a particular value.
    - dname calculates density (pdf) at input x.
- The distribution (cdf) at a particular value.
    - pname calculates distribution (cdf) at input x.
- The quantile value corresponding to a particular probability.
    - qname calculates the quantile at an input probability.
- A random draw of values from a particular distribution.
    - rname generates a random draw from a particular distribution.

For example, consider a random variable $X$ which is $N(\mu = 2, \sigma^{2} = 25)$. (Note, we are parameterizing using the variance $\sigma^{2}$. `R` however uses the standard deviation.)

To calculate the value of the pdf at `x = 3`, that is, the height of the curve at `x = 3`, use:

```r
dnorm(x = 3, mean = 2, sd = 5)
```

To calculate the value of the cdf at `x = 3`, that is $P(X <= 3)$, the probability that $X$ is less than or equal to `3`, use:

```r
pnorm(q = 3, mean = 2, sd = 5)
```
Or, to calculate the quantile for probability 0.975, use:

```r
qnorm(p = 0.975, mean = 2, sd = 5)
```

Lastly, to generate a random sample of size n = 10, use:

```r
rnorm(n = 10, mean = 2, sd = 5)
```

## Simulating

```r
tibble(rep = 1:10) %>% 
  #resampling the function as many times as you called in the line above
  mutate(samples = map(rep, ~ rnorm(100))) %>%
  #mean of each sample
  mutate(means = map_dbl(samples, ~ mean(.)))
```

```r
#more simple approach
rerun(10, rnorm(100)) %>%
  map_dbl(~ mean(.))
```

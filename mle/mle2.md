## Poisson

The Poisson distribution is used to model the number of events that happen in some unit of time or space. This distribution is often used to model events that can only be positive integers. This distribution is parameterized by $\lambda$, which represents the expected number of events that happen (as defined as the average over an infinitely large number of draws). Because $\lambda$ represents the average number of events, the $\lambda$ parameter must be greater than or equal to 0.

The function that defines the relationship between the parameter $\lambda$ and what values are most probable is called the *probability mass function* when talking about discrete random variables and *probability density functions* in the continuous case.  Either way, these functions are traditionally notated using $f(x)$.
$$f(x|\lambda) = \frac{e^{-\lambda} \lambda^x}{x!} \;\;\;\; \textrm{for}\;\;  x \in \{0,1,2,\dots\}$$

```{r, echo=FALSE, warning=FALSE, message=FALSE}
data <- tibble(x=0:10) %>%
  mutate(upr = dpois(x, lambda = 3.5), lwr=0) %>%
  pivot_longer(lwr:upr, names_to='Type', values_to='y') 
 
ggplot(data, aes(x=x, y=y)) +
  geom_point(data=data%>%filter(Type=='upr')) + 
  geom_path(aes(group=x)) +
  annotate('path', x=c(3.5,3.5), y=c(.25,0), color='blue') +
  annotate('text', x=3.5, y=0.27, label=latex2exp::TeX('$\\lambda$'), color='blue') +
  scale_x_continuous(breaks = seq(0,10,by=2)) +
  labs(x='X', y=latex2exp::TeX('$f(x \\,|\\, \\lambda = 3.5)$'), 
      title=latex2exp::TeX('Poisson $(\\, \\lambda = 3.5 \\,)$') )
```

The notation $f(x|\lambda)$ read as "f *given* $\lambda$" and is used to denote that this is a function that describes what values of the data $X$ are most probable and that the function depends on the parameter value.  This is emphasizing that if we were to change the parameter value (to say $\lambda = 10$), then a different set of data values would be more probable. In the above example with $\lambda = 3.5$, the most probable outcome is $3$ but we aren't surprised if we were to observe a value of $x=1,2,$ or $4$. However, from this graph, we see that $x=10$ or $x=15$ would be highly improbable.


Suppose that we have observed a single data point drawn from a Poisson($\lambda$) and we don’t know what $\lambda$ is. We first write down the likelihood function

$$
\mathcal{L}(\lambda \mid x) = f(x \mid \lambda) = \frac{e^{-\lambda}\lambda^{x}}{x!}
$$

If we have observed $x = 4$, then $\mathcal{L}(\lambda \mid x = 4)$ is the following function

```r
library(tidyverse)

data <- tibble(
  lambda = seq(0, 15, by = 0.01)) %>%
  mutate(L = dpois(4, lambda = lambda))

P1 <- ggplot(data, aes(
  x = lambda, y = L)) +
  geom_line() +
  annotate('path', x = c(4, 4), y = c(.195, 0), color='blue') +
  annotate('text', x = 4, y = .215, label = latex2exp::TeX('$\\hat{\\lambda}$'), color = 'blue') +
  labs(
    x = latex2exp::TeX('$\\lambda$'),
    y = latex2exp::TeX('$L(\\, \\lambda \\,|\\, x=4 \\,)$'),
    title = latex2exp::TeX('Poisson Likelihood given $x=4$')
    )

P2 <- ggplot(data, aes(
  x = lambda, y = log(L))) +
  geom_line() +
  annotate('path', x = c(4, 4), y = c(-20, -1.5), color = 'blue') +
  annotate('text', x = 4, y = .5, label = latex2exp::TeX('$\\hat{\\lambda}$'), color = 'blue') +
  scale_y_continuous(limits = c(-20, 2)) +
  labs(
    x = latex2exp::TeX('$\\lambda$'), 
    y = latex2exp::TeX('$logL(\\, \\lambda \\,|\\, x=4 \\,)$'),
    title = latex2exp::TeX('Poisson log-Likelihood given $x=4$')
    )

cowplot::plot_grid(P1, P2, nrow = 2)
```

Our best estimate for $\lambda$ is the value that maximizes $\mathcal{L}(\lambda \mid x)$. We could do this two different ways. First we could mathematically solve by taking the derivative, setting it equal to zero, and then solving for lambda. Often this process is made mathematically simpler (and computationally more stable) by instead maximizing the log of the Likelihood function. This is equivalent because the log function is monotonically increasing and if $a < b$ then $log(a) < log(b)$. It is simpler because taking logs makes everything 1 operation simpler and reduces the need for using the chain rule while taking derivatives. We could also find the value of $\lambda$ that maximizes the likelihood using numerical methods. Again because the log function makes everything nicer, in practice we’ll always maximize the log likelihood. Many optimization functions are designed around finding function minimums, so to use those, we’ll actually seek to minimize the negative log likelihood which is simply $-1 \times log \mathcal{L}()$.

Numerical solvers are convenient, but are only accurate to machine tolerance you specify. In this case where $x = 4$, the actual maximum likelihood value is $\hat{\lambda} = 4$.

```r
x <- 4
neglogL <- function(param){
  dpois(x, lambda=param) %>%
    log() %>%     # take the log
    prod(-1) %>%  # multiply by -1
    return()      
}

# Optimize function will find the maximum of the Likelihood function
# over the range of lambda values [0, 20]. By default, the optimize function
# finds the minimum, but has an option to find the maximum. Alternatively
# we could find the minimum of the -logL function.
optimize(neglogL, interval=c(0,20) )
```

But what if we have multiple observations from this Poisson distribution? If the observations are *independent*, then the probability mass or probability density functions $f(x_i|\theta)$ can just be multiplied together. 

$$\begin{aligned}
\mathcal{L}(\lambda|\textbf{x}) = \prod_{i=1}^{n}f(x_i|\lambda) = \prod_{i=1}^n\frac{e^{-\lambda} \lambda^x_i}{x_i!}
\end{aligned}$$

So, suppose we have observed $\textbf{x} = \{4,6,3,3,2,4,3,2\}$. We could maximize this function either using calculus methods  or numerical methods this function and discover that the maximum occurs at $\hat{\lambda} = \bar{x} = 3.375$.

```r
x <- c(4,6,3,3,2,4,3,2)
data <- 
  expand.grid( lambda=seq(0,15, by=0.01), x=x) %>%
  mutate(L = dpois(.$x, lambda = .$lambda)) %>%
  group_by(lambda) %>%
  summarize( L = prod(L) )
P1 <- 
  ggplot(data, aes(x=lambda, y=L)) +
  geom_line() +
  annotate('path', x=c(3.375,3.375), y=c(.96e-6, 0), color='blue') +
  annotate('text', x=3.375, y=1.05e-6, label=latex2exp::TeX('$\\hat{\\lambda}$'), color='blue') +
  labs( x = latex2exp::TeX('$\\lambda$'), 
        y = latex2exp::TeX('$L(\\, \\lambda \\,|\\, \\textbf{x} \\,)$'),
        title = latex2exp::TeX('Poisson Likelihood given $\\textbf{x}$') )
P2 <- 
  ggplot(data, aes(x=lambda, y=log(L) )) +
  geom_line() +
  annotate('path', x=c(3.375,3.375), y=c(-13.75, -100), color='blue') +
  annotate('text', x=3.375, y=-5, label=latex2exp::TeX('$\\hat{\\lambda}$'), color='blue') +
  scale_y_continuous(limits=c(-100,-0)) +
  labs( x = latex2exp::TeX('$\\lambda$'), 
        y = latex2exp::TeX('$logL(\\, \\lambda \\,|\\, \\textbf{x} \\,)$'),
        title = latex2exp::TeX('Poisson log-Likelihood given $\\textbf{x}$') )
cowplot::plot_grid(P1, P2, nrow=2)
```

If we are using the log-Likelihood, then the multiplication is equivalent to summing and we'll define and subsequently optimize our log-Likelihood function like this:  

```r
x <- c(4,6,3,3,2,4,3,2)
neglogL <- function(param){
  dpois(x, lambda=param) %>%
    log() %>% sum() %>% prod(-1) %>%
    return()
}
optimize(neglogL, interval=c(0,20) )
```

### Normal

We finally consider the case where we have observation coming from a distribution that has multiple parameters. The normal distribution is parameterized by a mean $\mu$ and spread $\sigma$. Suppose that we had observed $x_i \stackrel{iid}{\sim} N(\mu, \sigma^2)$ and saw $\textbf{x} = \{5, 8, 9, 7, 11, 9\}$.

As usual we can calculate the likelihood function

$$\mathcal{L}(\mu,\sigma | \textbf{x}) = \prod_{i=1}^n f(x_i|\mu,\sigma) = \prod_{i=1}^n \frac{1}{\sqrt{2\pi}\sigma} \exp \left[ -\frac{1}{2}\frac{(x_i-\mu)^2}{\sigma^2} \right]$$

Again using calculus, it can be shown that the maximum likelihood estimators in this model are
$$\hat{\mu} = \bar{x} = 8.16666$$
$$\hat{\sigma}_{mle} = \sqrt{ \frac{1}{n}\sum_{i=1}^n (x_i-\bar{x})^2 } = 1.8634$$
which is somewhat unexpected because the typical estimator we use has a $\frac{1}{n-1}$ multiplier. 



```r
x <- c(5, 8, 9, 7, 11, 9)
xbar <- mean(x)
s2 <- sum( (x - xbar)^2 / 6 )
s <- sqrt(s2)
```

```r
x <- c(5, 8, 9, 7, 11, 9)
data <- 
  expand.grid( mu=seq(5,12, by=0.01), sigma=seq(1, 3.0, by=0.01), x=x) %>%
  mutate(L = dnorm(.$x, mean=.$mu, sd=.$sigma)) %>%
  group_by(mu, sigma) %>%
  summarize( L = prod(L) )
P1 <- 
  ggplot(data, aes(x=mu, y=sigma, z=L)) +
  geom_contour(color='black') +
  geom_vline( xintercept=xbar, color='blue') +
  geom_hline( yintercept=s,    color='red' ) +
  annotate('text', x=8.3, y=1,   label=latex2exp::TeX('$\\hat{\\mu}$'), color='blue') +
  annotate('text', x=6,   y=1.8, label=latex2exp::TeX('$\\hat{\\sigma}_{mle}$'), color='red') +  
  scale_x_continuous(limits=c(5, 12 )) + 
  scale_y_continuous(limits=c(1, 2.5)) +
  labs( x = latex2exp::TeX('$\\mu$'), 
        y = latex2exp::TeX('$\\mu$'),
        title = latex2exp::TeX('Normal Likelihood given $\\textbf{x}$') )
P1
```


```r
x <- c(5, 8, 9, 7, 11, 9)
neglogL <- function(param){
  dnorm(x, mean=param[1], sd=param[2]) %>%
    log() %>% sum() %>% prod(-1) %>%
    return()
}
# Bivariate optimization uses the optim function that only can search
# for a minimum. The first argument is an initial guess to start the algorithm.
# So long as the start point isn't totally insane, the numerical algorithm should
# be fine.
optim(c(5,2), neglogL )  
```
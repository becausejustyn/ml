# Maximum Likelihood Estimation

`http://campus.murraystate.edu/academic/faculty/cmecklin/STA565/_book/maximum-likelihood.html`

Essentially, the goal is to estimate an unknown parameter $\theta$ by collecting a random sample that is independently and identically distributed (i.i.d.) from some probability distribution/model $f(x | \theta)$ and finding the value of $\theta$ that maximizes the **likelihood function**

$$
\mathcal{L}(\theta) = \prod_{i = 1}^{n} f(x_{i})
$$

Typically this involves finding the derivative of the likelihood function (or more commonly, the log-likelihood fucntion if it is more mathematically convenient), setting that derivative equal to `zero`, and solving for $\hat{\theta}$ the **maximum likelihood estimate** or $MLE$. 

If there are $k$ parameters $\theta$, then this involves finding $k$ partial derivatives and solving a system of equation for $k$ unknowns. MLE can be easy when the functions are easy to differentiate, or can require numerical approximation methods when the partial derivatives and the resulting system of equations is difficult.

## MLE For Non-Math/Stat Majors

If you got lost, here we’ll look at a very simple example of maximum likelihood estimation. Suppose we wish to estimate the probability of getting heads when a coin is flipped, and call that parameter $\theta$. Your intution is that the probability should be 0.50, but suppose you are dealing with a coin that is potentially biased and you don’t want to rely on intuition.

We will assume that the experiment of flipping a coin satisfies the following conditions:

1. Each trial has 2 possible outcomes. One of these outcomes is deemed a “success” (heads) and the other outcome is a “failure” (tails).
2. Each trial is independent.
3. The probability of success $\theta$ is the same for every trial.

These are the well-known Bernoulli conditions which describe a binomial experiment. A special case of the binomial distribution called the Bernoulli distribution deals with $n = 1$ trial of the experiment, such as a single toss of a coin,

$$
f(x) = P(X = x) = \theta^{x} (1 - \theta)^{1 - x}, x = 0, 1; 0 \le \theta le 1
$$

Where $X \sim BERN(\theta) \text{ or } X \sim BIN(n = 1, \theta)$. $x$ represents the observed number of success in the single trial, which can either be 0 or 1. $1 - x$ is the observed number of failures. $\theta$ is the probability of success and $1 - \theta$ is the probability of failure.

Notice that if we flip the coin and get heads, then $x = 1$ and

$$
f(1) = \theta^{1} (1 - \theta)^{1 - 1} = \theta
$$

If we get tails, then $x = 0$

$$
f(0) = \theta^{0} (1 - \theta)^{1 - 0} = \theta
$$

## MLE For a Coin Flipping Experiment

Suppose I flip a coin three times. I get heads on the first toss, tails on the second toss, and heads on the third toss, so I have a sample of size $n = 3$ with $x_{1} = 1, x_{2} = 0, x_{3} = 1$. This is an i.i.d. random sample from some assumed model, which here is the Bernoulli probability distribution.

I will compute its likelihood function

$$
\mathcal{L}(\theta) = \prod_{i = 1}^{n} f(x_{i})
$$

$$
\mathcal{L}(\theta) = f(x_{1}) \cdot f(x_{2}) \cdot f(x_{3})
$$

$$
\mathcal{L}(\theta) = f(1) \cdot f(0) \cdot f(1)
$$

$$
\mathcal{L}(\theta) = \theta \cdot (1 - \theta) \cdot \theta
$$

$$
\mathcal{L}(\theta) = \theta^{2} (1 - \theta) 
$$

For a second, I will pretend like I don’t know how to take the derivative of this function, but I will graph $\mathcal{L}(\theta)$ across all possible values $0 \le \theta \le 1$ of the unknown parameter. The maximum of this graph will be our $MLE \hat{\theta}$.

I think the MLE is at aboutI think the MLE is at about $\hat{\theta} = \frac{2}{3}$, where $\mathcal{L}(\frac{2}{3}) = \frac{4}{27}$

```r
library(tidyverse)

theta <- seq(0, 1, by = 0.001)
L_theta <- theta^2 * (1-theta)
MLE <- data.frame(theta, L_theta)

MLE %>%
  ggplot(aes(
  x = theta, y = L_theta)) +
  geom_line() + 
  geom_vline(
    xintercept= 2/3, linetype = "dashed", colour = "red") +
  geom_hline(
    yintercept = 4/27, linetype = "dashed", colour = "red") +
  theme_bw()
```

Okay, for this problem the calculus to find the $MLE$ is pretty trivial.

$$\mathcal{L}(\theta) = \theta^{2} (1 - \theta) = \theta^{2} - \theta^{3}$$

$$\mathcal{L}'(\theta) = 2 \theta - 3 \theta^{2}$$

Take the first derivative where we substitute $\hat{\theta}$ for $\theta$, set equal to zero, and solve for $\hat{\theta}$. (technically we should also take the second derivative and verify that we are maximizing the function rather than minimizing it)

$$2 \theta - 3 \theta^{2} = 0$$

$$2 \theta = 3 \theta^{2}$$

$$2 = 3 \hat{\theta}$$ 
$$\hat{\theta} = \frac{2}{3}$$

Notice the $MLE$ for the binomial distribution is merely the number of observed successes in $n$ independent trials, i.e. we flipped our coin 3 times and got 2 heads. A parameter value  
$\theta = \frac{2}{3}$ is most likely to produce such a sample.

For more complicated scenarios, this can be much more complicated. As the mathematical statistics students know, we usually maximize the log of the likelihood function instead, as it is usually easier to differentiate $ln \mathcal{L}(\theta)$ than $\mathcal{L}(\theta)$. Often when using a computer to find MLEs in situations where an analytic solution cannot be found (i.e. you can’t take a derivative), we minimize the negative log-likelihood function as the numerical optimizers usually minimize functions rather than maximizing.

## Likelihood Ratio Test

We can compare two nested models with a technique called the likelihood ratio test or $LRT$. A model is said to be nested within another model when its parameters are a subset of the other models parameters.  For example, the two models below are nested.

$$
Model 1: Y = \beta_{0} + \beta_{1}X_{1} + \beta_{2}X_{2} + \beta_{3}X_{3} + \epsilon
$$

$$
Model 2: Y = \beta_{0} + \beta_{1}X_{1} + \beta_{3}X_{3} + \ epsilon
$$

Model 2 is nested in model 1, as both models share the parameters $\beta_{0}, \beta_{1}$, and $\beta_{3}$, with model 1 having the additional parameter $\beta_{2}$ that is not in Model 2.

However, these two models are NOT nested.

$$
Model 1: Y = \beta_{0} + \beta_{1}X_{1} + \beta_{2}X_{2} + \beta_{3}X_{3} + \epsilon
$$

$$
Model 3: Y = \beta_{0} + \beta_{1}X_{1} + \beta_{3}X_{3} + \beta_{4}X_{4} + \epsilon
$$

Notice that both models contain a parameter that the other model does not contain, with Model 1 having $\beta_{3}$ and model 3 having $\beta_{4}$. Neither model’s set of parameters is a subset of the other model, and we would NOT be able to compare them with with a partial $F$ test or the likelihood ratio test. You could compute the $AIC$ values for both Models 1 and 3 and compare their $\Delta_{i}$, relative likelihoods, or Akaike weights.

## Likelihood Ratio Test for a Linear Model

Assume we have two linear models, with one model (the reduced model $R$) nested in the other model (the full model $F$).

Let’s try another example, this one with a data set used by Brad Efron in his book Computer Age Statistical Inference and some of his lectures. This a data set of size $n = 164$, where the subjects are men in an experiment for a medication that is supposed. The response `cholesterol.decrease` is the decrease in their cholesterol level over the course of the experiment, while the predictor `compliance` is a standardized variable that was the fraction of the intended dose that was actually taken. Efron used this as an example where fitting a cubic regression might be a good idea. I’ll compare a linear regression with a cubic regression, using this data. Using `poly(x, degree = 3)` uses orthogonal polynomials and prevents possible issues with collinearity.

The likelihood ratio test of the two models, the linear model of degree 1 (reduced) and the cubic model of degree 3 (full) is:

$$T = -2ln \frac{\mathcal{R}}{\mathcal{F}}$$ 
$$T = -2[ln \mathcal{L}_{R} - ln \mathcal{L}_{F}]$$
$$T = − 2 [− 739.4499 − − 736.9263]$$
$$T = − 2 [− 2.5236]$$ 
$$T = 5.0472, df = 2, p = 0.082$$

It’s not very clear what the “best” degree polynomial is to fit to this data set.

```r
URL <- "https://web.stanford.edu/~hastie/CASI_files/DATA/cholesterol.txt"
cholesterol <- read.table(URL,header=TRUE)
str(cholesterol)
```

```r
ggplot(cholesterol,aes(x=compliance,y=cholesterol.decrease)) +
  geom_point(color="green") + theme_bw() +
  geom_smooth(method="loess",se=FALSE) +
  geom_smooth(method="lm",color="red",se=FALSE) +
  geom_smooth(method="lm",formula=y~poly(x,3),color="black",se=FALSE)
```

```r
model.lin <- lm(cholesterol.decrease~compliance,data=cholesterol)
summary(model.lin)
```

```r
model.cubic <- lm(cholesterol.decrease~poly(compliance,degree=3),data=cholesterol)
summary(model.cubic)
```

```r
anova(model.lin,model.cubic)
```

```r
logLik(model.lin)
```

```r
logLik(model.cubic)
```

```r
T <- -2*(logLik(model.lin)[1]-logLik(model.cubic)[1])
T
```

```r
pval <- 1-pchisq(q=T,df=2)
pval
```

```r
anova(model.lin,model.cubic,test="Chisq")
```

```r
require(bbmle)
model.quad <- lm(cholesterol.decrease~poly(compliance,degree=2),data=cholesterol)
model.quart <- lm(cholesterol.decrease~poly(compliance,degree=4),data=cholesterol)
AICtab(model.lin,model.quad,model.cubic,model.quart,base=TRUE,weights=TRUE,delta=TRUE,sort=TRUE)
```
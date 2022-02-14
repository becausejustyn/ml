

# Sample from the same distribution with different parameters

list(5, 15, -5) %>% 
  map(rnorm, n = 5) %>% 
  str()

# If you want to specify two parameters in the distribution

tribble(
  ~n, ~mean, ~sd, 
  10,    0,    1,     
  20,    5,    1,     
  30,    10,   2      
) %>% 
  pmap(rnorm) %>% 
  str()

# Multiple distributions with different parameters

f <- c("runif", "rnorm", "rpois")

tribble(
  ~f,      ~params,                  
  "runif", list(min = -1, max = 1,n=10),  
  "rnorm", list(sd = 5, n=15),             
  "rpois", list(lambda = 10,n=30)   
) %>% 
  mutate(sim = invoke_map(f, params))



# Coin Toss Example

sim <- tribble(
  ~f,      ~params,
  "rbinom", list(size = 1, prob = 0.5)
)

sim %>% 
  mutate(sim = invoke_map(f, params, n = 10)) %>% 
  unnest(sim) %>% 
  summarise(mean_sim = mean(sim))

# Adding replications

rep_sim <- sim %>% 
  crossing(rep = 1:1e5) %>%
  mutate(sim = invoke_map(f, params, n = 10)) %>% 
  unnest(sim) %>% #flatten the list
  group_by(rep) %>% 
  summarise(mean_sim = mean(sim))

head(rep_sim)

ggplot(rep_sim) +
  aes(x = mean_sim) +
  geom_histogram(bins = 10L, fill = "#6FBAD2") +
  labs(
    x = "Mean Heads",
    y = "Count",
    title = "Mean 'Heads' fom 10 Coin Tosses"
  ) +
  theme_gray()

ggplot(rep_sim) +
  aes(x = mean_sim) +
  geom_bar() +
  scale_x_binned() +
  labs(
    x = "Mean Heads",
    y = "Count",
    title = "Mean 'Heads' fom 10 Coin Tosses"
  ) +
  theme_gray()



set.seed(42)

params <- tribble(
  ~size, ~prob,
  1,     0.5
)

p <- params %>% 
  crossing(n=1:1e4) %>% 
  pmap(rbinom) %>% 
  enframe(name="num_toss",value="observation") %>%  
  unnest(observation) %>% 
  group_by(num_toss) %>% 
  summarise(vale = mean(observation))

p %>%
  ggplot(aes(num_toss, vale)) + 
  geom_point(stat = "identity", fill = "purple", alpha = 0.75) + 
  labs(
    x = "Number of Heads", 
    y = "Probability of Heads in 10 flips (p)") +
  theme_minimal()


p %>% 
  ggplot(aes(x = num_toss, y = vale)) +
  geom_point() +
  labs(
    x = "x",
    y = "y",
    title = "Title"
  ) +
  geom_hline(aes(yintercept = 0.5, colour = "pink")) +
  theme_minimal()


sim <- tribble(
  ~n_tosses, ~f, ~params,
  10, "rbinom", list(size = 1, prob = 0.5, n = 15),
  30, "rbinom", list(size = 1, prob = 0.5, n = 30),
  100, "rbinom", list(size = 1, prob = 0.5, n = 100),
  1000, "rbinom", list(size = 1, prob = 0.5, n = 1000),
  10000, "rbinom", list(size = 1, prob = 0.5, n = 1e4)
)

sim_rep <- sim %>%
  crossing(replication = 1:50) %>%
  mutate(sims = invoke_map(f, params)) %>%
  unnest(sims) %>%
  group_by(replication, n_tosses) %>%
  summarise(avg = mean(sims))

sim_rep %>%
  ggplot(aes(x = factor(n_tosses), y = avg)) +
  ggbeeswarm::geom_quasirandom(color = "lightgrey") +
  scale_y_continuous(limits = c(0, 1)) +
  geom_hline(
    yintercept = 0.5,
    color = "skyblue", lty = 1, size = 1, alpha = 3 / 4
  ) +
  ggthemes::theme_pander() +
  labs(
    title = "50 Replicates Of Mean 'Heads' As Number Of Tosses Increase",
    y = "mean",
    x = "Number Of Tosses"
  )


## James-Stein Theorem

library(Lahman)
set.seed(42)

# Select 30 players that don't have missing values
# and have a good amount of data (total hits > 500)
players <- Batting %>%
  group_by(playerID) %>%
  summarise(
    AB_total = sum(AB),
    H_total = sum(H)
  ) %>%
  na.omit() %>%
  filter(H_total > 500) %>% # collect players with a lot of data
  sample_n(size = 30) %>% # randomly sample 30 players
  pull(playerID) # `select` will produce a dataframe,
# `pull` gives a list which will be easier
# to work with when we `filter` by players

# 2. Get "truth"
TRUTH <- Batting %>%
  filter(playerID %in% players) %>%
  group_by(playerID) %>%
  summarise(
    AB_total = sum(AB),
    H_total = sum(H)
  ) %>%
  mutate(TRUTH = H_total / AB_total) %>%
  select(playerID, TRUTH)

# 3. Collect 5 observations per player
# 4.Predict truth with MLE and James-Stein Estimator
set.seed(42)
obs <- Batting %>%
  filter(playerID %in% players) %>%
  group_by(playerID) %>%
  do(sample_n(., 5)) %>%
  group_by(playerID) %>%
  summarise(
    AB_total = sum(AB),
    H_total = sum(H)
  ) %>%
  mutate(MLE = H_total / AB_total) %>%
  select(playerID, MLE, AB_total) %>%
  inner_join(TRUTH, by = "playerID")

# Define variables for James-Stein estimator
p_ <- mean(obs$MLE)
N <- length(obs$MLE)
obs %>% summarise(median(AB_total))

df <- obs %>%
  mutate(
    sigma2 = (p_ * (1 - p_)) / 1624.5,
    JS = p_ + (1 - ((N - 3) * sigma2 / (sum((MLE - p_)^2)))) * (MLE - p_)
  ) %>%
  select(-AB_total, -sigma2)

head(df)

errors <- df %>%
  mutate(
    mle_pred_error_i = (MLE - TRUTH)^2,
    js_pred_error_i = (JS - TRUTH)^2
  ) %>%
  summarise(
    js_pred_error = sum(js_pred_error_i),
    mle_pred_error = sum(mle_pred_error_i)
  )


#### Binomial Approximation

# build data with MLE estiamte
set.seed(42)
sim <- tibble(player = letters, 
              AB_total=300, 
              TRUTH = rbeta(100,300,n=26),
              hits_list = map(.f=rbinom,TRUTH,n=300,size=1)
)
bats_sim <- sim %>% 
  unnest(hits_list) %>% 
  group_by(player) %>% 
  summarise(Hits = sum(hits_list)) %>% 
  inner_join(sim, by = "player") %>% 
  mutate(MLE = Hits/AB_total) %>% 
  select(-hits_list)

bats_sim

#calculate variables for JS estimator
p_=mean(bats_sim$MLE)
N = length(bats_sim$MLE)

# add JS to simulated baseball data 
bats_sim <- bats_sim %>% 
  mutate(sigma2 = (p_*(1-p_))/300,
         JS=p_+(1-((N-3)*sigma2/(sum((MLE-p_)^2))))*(MLE-p_)) %>% 
  select(-AB_total,-Hits,-sigma2)

# plot
bats_sim %>% 
  gather(type,value,2:4) %>% 
  mutate(is_truth=+(type=="TRUTH")) %>% 
  mutate(type = factor(type, levels = c("TRUTH","JS","MLE"))) %>%
  arrange(player, type) %>% 
  ggplot(aes(x=value,y=type))+
  geom_path(aes(group=player),lty=2,color="lightgrey")+
  scale_color_manual(values=c("lightgrey", "skyblue"))+ #truth==skyblue
  geom_point(aes(color=factor(is_truth)))+
  guides(color=FALSE)+ #remove legend
  labs(title="The James-Stein Estimator Shrinks the MLE")+
  theme_minimal()


errors <- bats_sim %>% 
  mutate(mle_pred_error_i = (MLE-TRUTH)^2,
         js_pred_error_i = (JS-TRUTH)^2) %>% 
  summarise(js_pred_error = sum(js_pred_error_i),
            mle_pred_error = sum(mle_pred_error_i))

errors
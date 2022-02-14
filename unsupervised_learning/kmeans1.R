library(tidyverse)
library(broom)
library(gt)

options(scipen = 999, digits = 3)

earn <- readr::read_csv(
  'https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-02-23/earn.csv')

earn %>% 
  head() %>%
  gt() %>%
  tab_header(title = md("Datos de Salarios Medianos en EEUU"))

skimr::skim(earn)

earn %>%
  select(where(is_character)) %>%
  map(unique)
  
## Data Visualization

earn %>%
  filter(sex != "Both Sexes") %>%
  ggplot(aes(
    x = race,
    y = age,
    colour = sex
  )) +
  geom_count() +
  facet_wrap(~sex) +
  coord_flip() +
  tomtom::theme_538() +
  labs(y = NA) +
  theme(
    axis.text.x = element_text(angle = 90),
    legend.position = "right",
    legend.direction = "vertical"
  ) 

# Next we will analyze how the median weekly wage varies as a function of 
#sex and race:

earn %>%
  filter(sex != "Both Sexes") %>%
  ggplot(aes(
    x = median_weekly_earn,
    fill = sex
  )) +
  geom_histogram(color = "black") +
  scale_fill_manual(values = c("#3A7767", "#286D8F")) +
  tomtom::theme_538() +
  facet_wrap(~race, nrow = 2, scales = "free") +
  scale_y_continuous(breaks = scales::pretty_breaks(5)) +
  labs(
    fill = "Sex",
    x = "Median Weekly Earning",
    y = "Count", 
    caption = "Groups are on different scales."
  ) +
  theme(
    plot.caption = element_text(family = "mono"),
    axis.title = element_text(family = "mono"),
    plot.title = element_text(family = "mono"),
    legend.text = element_text(family = "mono"),
    legend.title = element_text(family = "mono"),
    plot.background = element_rect(
      fill = "gray92",
      linetype = "solid"), 
    strip.text = element_text(family = "mono"),
    legend.background = element_rect(fill = NA, colour = NA),
    legend.position = c(0.1, -0.15)
  ) 

# We can see how men get paid more than women regardless of race (as can be 
#seen by growing the red bars in the last sections of the distributions with 
#respect to the blue ones).

earn %>%
  filter(sex != "Both Sexes") %>%
  ggplot(aes(median_weekly_earn, fill = sex)) +
  geom_histogram(color = "black", position = "dodge") +
  tidyquant::theme_tq() +
  scale_fill_manual(values = c("#3A7767", "#286D8F")) +
  scale_x_continuous(limits = c(300, 1800)) +
  facet_wrap(~ethnic_origin, nrow = 2, scales = "free") +
  theme(
    legend.background = element_rect(fill = NA, colour = NA),
    legend.position = c(0.875, 0.25)
    ) +
  labs(
    fill = "Sex",
    x = "Median Weekly Earning",
    y = "Count", 
    caption = "Groups are on different scales."
  )

#The same pattern is observed as we saw in the previous graph, where we see 
#how men are generally paid more than women. We can also see how Hispanics have 
#lower than average salaries (both men and women) as can be seen in the ranges 
#that the distributions reach (the maximum value for Hispanics does not reach 
#the median of $900 per week).

earn %>%
  filter(sex != "Both Sexes") %>%
  filter(ethnic_origin == "All Origins" & !is.na(age)) %>%
  mutate(yearq = as.Date(paste(year, case_when(
    nchar(quarter * 3) == 1 ~ paste("0", quarter * 3, sep = ""),
    TRUE ~ as.character(quarter * 3)
  ), "01", sep = "-"))) %>%
  group_by(sex, race, yearq) %>%
  summarise(
    median_weekly_earn = median(median_weekly_earn),
    n_persons = sum(n_persons)
  ) %>%
  ungroup() %>%
  mutate(
    agrupar = paste(sex, race, sep = "-"),
    agrupar = case_when(
      agrupar == "Men-Black or African American" ~ "Men-Black/African",
      agrupar == "Women-Black or African American" ~ "Women-Black/African",
      TRUE ~ agrupar
    )
  ) %>%
  group_by(agrupar) %>%
  timetk::plot_time_series(
    .date_var    = yearq,
    .value       = median_weekly_earn,
    .color_var   = agrupar,
    .smooth      = FALSE,
    .facet_ncol  = 3,
    .facet_scales = "free",
    .line_size   = 0.8,
    .interactive = FALSE,
    .legend_show = FALSE
  ) +
  labs(
    title = "Median Salary by Race and Sex"
  ) +
  theme(
    plot.title = element_text(hjust = 0.5, margin = margin(b = 20))
  )

# Clearly we can see an increasing trend for all races and sexes between 2010 
#and 2020, with a higher wage increase for Asians over the rest of the groups 
#studied (for both sexes, both men and women). 

earn %>%
  filter(sex != "Both Sexes") %>%
  filter(ethnic_origin == "All Origins" & !is.na(age)) %>%
  mutate(yearq = as.Date(paste(year, case_when(nchar(quarter*3) == 1 ~ paste("0", quarter*3, sep = ""),
                                               TRUE ~ as.character(quarter*3)), "01", sep = "-"))) %>%
  group_by(sex, race, yearq) %>%
  summarise(median_weekly_earn = median(median_weekly_earn),
            n_persons          = sum(n_persons)) %>%
  ungroup() %>%
  mutate(agrupar = paste(sex, race, sep = "-"),
         agrupar = case_when(agrupar == "Men-Black or African American" ~ "Men-Black/African",
                             agrupar == "Women-Black or African American" ~ "Women-Black/African",
                             TRUE ~ agrupar)) %>%
  group_by(agrupar) %>%
  timetk::plot_time_series(
    .date_var    = yearq,
    .value       = n_persons,
    .color_var   = agrupar, 
    .smooth      = FALSE,
    .facet_ncol  = 3,
    .facet_scales = "free",
    .line_size   = 0.8, 
    .interactive = FALSE,
    .legend_show = FALSE
  ) +
  labs(
    title = "Median Salary by Race and Sex"
  ) +
  theme(plot.title = element_text(hjust = 0.5, margin = margin(b = 20)))

###########################
### KMeans Implementation
###########################

#first we adapt the data to a format suitable for applying the KMeans algorithm:

earn_tidy <- earn %>%
  mutate(
    median_weekly = cut(median_weekly_earn, 50)
    ) %>%
  group_by(sex, race, median_weekly) %>%
  summarise(
    n_persons = sum(n_persons)
    ) %>%
  select(sex, race, median_weekly, n_persons) %>%
  pivot_wider(
    names_from = sex:race,
    values_from = n_persons,
    id_cols = median_weekly,
    values_fill = 0
  ) %>%
  janitor::clean_names() %>%
  mutate(across(where(is.numeric), ~ as.numeric(scale(.))))

earn_tidy %>%
  head() %>%
  gt() %>%
  tab_header(title = md("Data Transformados Wider")) %>%
  opt_align_table_header(align = "left")

kclusts <- tibble(k = 1:9) %>%
  mutate(
    kclust = map(k, ~kmeans(select(earn_tidy, -median_weekly), .x)),
    tidied = map(kclust, tidy),
    glanced = map(kclust, glance),
    augmented = map(kclust, augment, select(earn_tidy, -median_weekly))
  )

kclusts

clusters <- kclusts %>%
  unnest(cols = c(tidied))

clusters %>%
  select(-c(kclust, glanced, augmented)) %>%
  head() %>%
  gt() %>%
  tab_header(title = md("Información a nivel Cluster")) %>%
  opt_align_table_header(align = "left")

assignments <- kclusts %>% 
  unnest(cols = c(augmented))

assignments %>%
  select(-c(kclust, tidied, glanced)) %>%
  head() %>%
  gt() %>%
  tab_header(title = md("Dataset con Cluster Asignado")) %>%
  opt_align_table_header(align = "left")

clusterings <- kclusts %>%
  unnest(cols = c(glanced))

clusterings %>%
  select(-c(kclust, tidied, augmented)) %>%
  gt() %>%
  tab_header(title = md("Información a nivel k"))

#Let’s explore some of the results below:

p1 <- ggplot(assignments, aes(x = women_all_races, y = women_asian)) +
  geom_point(aes(color = .cluster), alpha = 0.8) + 
  facet_wrap(~ k) +
  tidyquant::theme_tq() +
  theme(legend.position = "right")

p1 + geom_point(data = clusters, size = 6, shape = "x")

#We can create a function to explore the combinations that interest us in a more comfortable way:

explore_kmeans_results <- function(.assignments, .clusters,  .var1, .var2){
  
  p1 <- ggplot(.assignments, aes(x = {{.var1}}, y = {{.var2}})) +
    geom_point(aes(color = .cluster), alpha = 0.8) + 
    facet_wrap(~ k) +
    tidyquant::theme_tq() +
    theme(legend.position = "right")
  
  p1 + geom_point(data = .clusters, size = 6, shape = "x")
  
}

explore_kmeans_results(assignments, clusters, men_all_races, men_asian)

#We can also see what is the appropriate number of clusters for this dataset 
#using the famous elbow rule. For this we need to plot the intracluster 
#variance per k value:

ggplot(clusterings, aes(k, tot.withinss)) +
  geom_line() +
  geom_point() +
  scale_x_continuous(breaks = seq(1, 9, 1)) +
  tidyquant::theme_tq() +
  ggtitle("Número Óptimo de Clusters")

#https://albertoalmuinha.com/posts/2021-08-19-kmeans-tidymodels/kmeans-en/
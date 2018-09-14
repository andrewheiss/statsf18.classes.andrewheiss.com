library(tidyverse)  # Load ggplot2, dplyr, and other helpful packages
library(ggplot2movies)  # Load the package that has the movie data in it

star_movies <- movies %>%
  filter(str_detect(title, "Star Wars") | str_detect(title, "Star Trek"),
         length > 100) %>%  # Get rid of some short Star Trek movies 
  select(title, year, length, budget, rating) %>% 
  mutate(budget = budget / 1000000,  # Make the budget more manageable
         series = ifelse(str_detect(title, "Wars"), "Star Wars", "Star Trek"))

# Scatterplots
ggplot(data = star_movies, 
       mapping = aes(x = budget, y = rating)) +
  geom_point()

# Linegraphs
ggplot(data = star_movies, 
       mapping = aes(x = year, y = rating, color = series)) +
  geom_point() +
  geom_line()

# Histograms
ggplot(data = star_movies, 
       mapping = aes(x = budget)) +
  geom_histogram(binwidth = 10)

# Boxplots
ggplot(data = star_movies, 
       mapping = aes(x = series, y = budget)) +
  geom_boxplot()

ggplot(data = star_movies, 
       mapping = aes(x = series, y = budget)) +
  geom_violin(draw_quantiles = 0.5) +
  geom_point()

# Bar charts
star_movies_count <- star_movies %>% 
  count(series)

ggplot(data = star_movies_count, 
       mapping = aes(x = series, y = n)) +
  geom_col()

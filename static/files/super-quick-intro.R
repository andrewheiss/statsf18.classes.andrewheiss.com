# Running R code ----------------------------------------------------------

# You can run R code directly in the console. Go ahead and type 2 + 2 in the
# console below and press enter.
#
# Typing everything there is tedious and not reproducible, though, since you
# won't always remember what you need to type to run all the steps of your
# analysis. Instead, you can type code in a script, which is just a text file
# with code in it.
#
# Lines that start with a # are commented out---they will not run as code and
# are good for leaving yourself notes about what's happening.
#
# To move a line of code from a script to the console, you can put your cursor
# somewhere in the line of code and press this keyboard shortcut:
# - Windows: ctrl + enter
# - Mac: ⌘ + enter

# Try it here!
2 + 2

# RStudio will automatically move your cursor to the next line of code, so you
# can keep pressing ctrl/⌘ + enter to step through your code. Try it:
1 + 2
3 - 6
6 / 2


# Objects (aka variables) -------------------------------------------------

# Something that contains some sort of value
#
# We assign values to variables/objects with the assignment operator, or <-
#
# This is just a weird historical quirk of R. You can also use = if you really
# want, but best practices say to use <-
#
# If you don't want to press two keys to type this, you can use a keyboard
# shortcut instead: 
# - Windows: alt + - (dash)
# - Mac: option + - (dash)
x <- 4
y <- 10

# What happens if you run this?
x + y


# What's the difference between this:
x + y

# and this:
z <- x + y

# You can create a list or vector of multiple values too:
my_cool_list <- c(1, 5, 2, 7, 3, 9)
my_other_cool_list <- c(5, 2, 6, 1, 2, 0)

# And then you can do stuff with them! What happens if you run this?
my_cool_list + my_other_cool_list


# Functions ---------------------------------------------------------------

# Take objects and do stuff to them

# What does this do?
my_neat_function <- function(x) {
  new_x <- x + 5
  return(new_x)
}

# Functions work on single values and on multiple values:
my_neat_function(14)
my_neat_function(x)
my_neat_function(my_cool_list)

# There are lots of built-in functions, like mean() and median():
mean(my_cool_list)
median(my_cool_list)


# Libraries (aka packages) ------------------------------------------------

# Collections of functions that other people have written and published 
# for you to use
library(dplyr)

# This loads a bunch of functions like tibble(), mutate(), and filter()
#
# What do you think this does?
my_tibble <- tibble(height = c(52, 56, 71, 62, 63),
                    weight = c(103, 159, 181, 163, 188))
my_tibble

# Tidyverse = special package that loads a bunch of other packages
library(tidyverse)



# Pipes -------------------------------------------------------------------

# You can nest functions inside each other
plot(mean(my_neat_function(my_cool_list)))

# But this can get really hard to read, since you have to read from the inside
# out. In English, this nested mess reads "Plot the average of the results of
# my_neat_function applied to my_cool_list." We can simplify this by reversing
# the nested chain:
my_cool_list %>% 
  my_neat_function() %>% 
  mean() %>% 
  plot()

# The strange %>% thing takes the value to the left of it and pipes it through
# to the thing to the right of it. You can read this chain as "Take
# my_cool_list, feed it through my_neat_function, take the mean of that, and
# plot it"
#
# The %>% is called a "pipe." You can also read it as "and then."
#
# There's also a keyboard shortcut for this too, since typing %>% all the time
# can be tedious:
# - Windows: ctrl + shift + m
# - Mac: ⌘ + shift + m

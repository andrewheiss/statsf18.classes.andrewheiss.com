library(tidyverse)
library(readxl)

# Food Environment Atlas by the USDA
# https://catalog.data.gov/dataset/food-environment-atlas-f4a22
food_atlas_path <- "data/DataDownload.xlsx"

food_access_raw <- read_excel(food_atlas_path, sheet = "ACCESS")
food_stores_raw <- read_excel(food_atlas_path, sheet = "STORES")
food_rest_raw <- read_excel(food_atlas_path, sheet = "RESTAURANTS")

food_access <- food_access_raw %>% 
  select(FIPS, 
         low_access_pop = LACCESS_POP15, 
         low_access_change = PCH_LACCESS_POP_10_15,
         pct_low_access_pop = PCT_LACCESS_POP15,
         children_low_access = LACCESS_CHILD15,
         pct_children_low_access = PCT_LACCESS_CHILD15) %>% 
  mutate(FIPS = parse_number(FIPS),
         pct_low_access_pop = pct_low_access_pop / 100,
         pct_children_low_access = pct_children_low_access / 100)

food_stores <- food_stores_raw %>% 
  select(FIPS, 
         grocery_stores = GROC14, grocery_stores_per_1000 = GROCPTH14,
         snap_stores = SNAPS16, snap_stores_per_1000 = SNAPSPTH16) %>% 
  mutate(FIPS = parse_number(FIPS))

food_rest <- food_rest_raw %>% 
  select(FIPS,
         fastfood = FFR14, fastfood_per_1000 = FFRPTH14) %>% 
  mutate(FIPS = parse_number(FIPS))


# Mortality data from the CDC's "Compressed Mortality File 1999-2015 Series 20 No. 2U, 2016"
# http://wonder.cdc.gov/cmf-icd10.html
mortality_raw <- read_tsv("data/mortality_2013-2015.csv")

mortality <- mortality_raw %>% 
  select(FIPS = `County Code`,
         deaths = Deaths, population = Population,
         mortality_rate = `Age Adjusted Rate`) %>% 
  mutate(FIPS = parse_number(FIPS),
         mortality_rate = parse_number(mortality_rate))


# Election results
election_raw <- read_csv("data/election_results.csv")

election <- election_raw %>% 
  select(FIPS, votes_dem_2012, votes_dem_2016, total_votes_2012, total_votes_2016,
         per_dem_2012, per_dem_2016, diff_2016, per_point_diff_2012, per_point_diff_2016) %>% 
  mutate(FIPS = parse_number(FIPS))


# Combine everything!
# Make a data frame of just FIPS codes, state names, and county names
only_counties_states_fips <- food_access_raw %>% 
  select(FIPS, state = State, county = County) %>% 
  mutate(FIPS = parse_number(FIPS))

full_data <- only_counties_states_fips %>% 
  left_join(food_access, by = "FIPS") %>% 
  left_join(food_stores, by = "FIPS") %>% 
  left_join(food_rest, by = "FIPS") %>% 
  left_join(mortality, by = "FIPS") %>% 
  left_join(election, by = "FIPS")

# Save this to a CSV tht we can work with later in other files
write_csv(full_data, "data/clean_combined_data.csv")

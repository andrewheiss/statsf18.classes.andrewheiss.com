library(tidyverse)
library(tidycensus)

states_to_get <- c("UT", "ID", "AZ", "NV", "CA")

# Search here for these codes
# https://www.socialexplorer.com/data/ACS2011_5yr/metadata/?ds=ACS11_5yr
vars_to_get <- c(
  population = "B01003_001",
  kids_population = "B09001_001",
  households = "B11005_001",
  households_with_kids = "B11005_002",
  households_no_kids = "B11005_011",
  median_income = "B19013_001",
  housing_units = "B25001_001",
  median_home_value = "B25077_001",
  real_estate_taxes_paid = "B25090_001",
  median_real_estate_taxes = "B25103_001"
)

acs_raw <- states_to_get %>% 
  map_dfr(~ get_acs(geography = "county", variables = vars_to_get,
                    state = ., year = 2016, survey = "acs5", geometry = FALSE))

state_fips_lookup <- fips_codes %>% 
  distinct(state_code, state_name)

property_taxes <- acs_raw %>% 
  select(-moe) %>% 
  spread(variable, estimate) %>% 
  mutate(state_code = substr(GEOID, 1, 2)) %>% 
  left_join(state_fips_lookup, by = "state_code") %>% 
  select(FIPS = GEOID, county = NAME, state = state_name, one_of(names(vars_to_get))) %>% 
  mutate(tax_per_housing_unit = real_estate_taxes_paid / housing_units,
         prop_houses_with_kids = households_with_kids / households * 100)

write_csv(property_taxes, "data/property_taxes_2016.csv")

# Load libraries ----------------------------------------------------------

library(tidyverse)
# This package provides access to the World Bank's World Development Indicators
# (WDI) database (https://data.worldbank.org/)
library(WDI)
# This package provides a helpful countrycode() function that converts country
# names ("United States") into country codes ("US" or "USA")
library(countrycode)


# Load raw data -----------------------------------------------------------

# This is a list of indicators I want to download from the World Bank. The
# cryptic names from from the URLs of the different pages at the World Bank's
# website. For instance, data for "school enrollment, primary" is available at
# https://data.worldbank.org/indicator/SE.PRM.NENR (I found that page by
# searching for primary school enrollment at data.worldbank.org). That last part
# of the URL (SE.PRM.NENR) is the magic ID code for the variable.

indicators <- c("SE.PRM.NENR",     # School enrollment, primary (% net)
                "SP.DYN.LE00.IN",  # Life expectancy
                "EG.ELC.ACCS.ZS",  # Access to electricity
                "SH.DYN.AIDS.ZS",  # HIV prevalence
                "EN.ATM.CO2E.PC",  # CO2 emissions
                "SI.POV.DDAY",     # Extreme poverty (% earning less than $2/day)
                "NY.GDP.PCAP.KD")  # GDP per capita

# The WDI() function connects to the World Bank's server and downloads data for
# all the indicators defined in the indicators list above. I only want data from
# 2015 here, so I limit the years with start and end. The extra=TRUE argument
# means that it'll also include other helpful details like region, aid status,
# etc. Without it, it would only download the indicators we listed.
wdi_raw <- WDI(country = "all", indicators, extra = TRUE, start = 2015, end = 2015)


# Data from the UN's World Happiness Report is available at Kaggle:
# https://www.kaggle.com/unsdsn/world-happiness
# You have to download the data onto your computer and load it with read_csv()
# If you're using an RStudio project, put it somewhere in your project folder, 
# like in a subfolder named data
happiness_raw <- read_csv("data/2015.csv")
# happiness_raw <- read_csv("~/Downloads/2015.csv")  # Read directly from my downloads folder
# happiness_raw <- read_csv("static/data/2015.csv")  # Read from where it is in this website thing


# Clean and combine data --------------------------------------------------

# First we clean up the raw World Bank data. It includes rows for regions, like
# the Middle East, so we filter those out (they're helpfully marked as
# "Aggregates" in the income colum). Then we rename some of the ugly World Bank
# codes to actual words
wdi_clean <- wdi_raw %>% 
  filter(income != "Aggregates") %>% 
  select(iso2c, country, year, school_enrollment = SE.PRM.NENR,
         life_expectancy = SP.DYN.LE00.IN, access_to_electricity = EG.ELC.ACCS.ZS,
         gdp_per_cap = NY.GDP.PCAP.KD, region, income)

# Then we clean the happiness data. In order to get the two datasets to combine,
# they have to have a shared column. The World Bank data has a column called
# "iso2c", which is a standard 2-character code for each country. We can use the
# countrycode() function here to convert country names into 2-character codes.
# We also remove Kosovo because it doesn't have an official ISO code. Finally we
# rename some columns to make them easier to type out
happiness_clean <- happiness_raw %>% 
  filter(Country != "Kosovo") %>% 
  mutate(iso2c = countrycode(Country, "country.name", "iso2c")) %>% 
  select(iso2c, happiness_score = `Happiness Score`, happiness_se = `Standard Error`)

# Finally we join the two datasets based on the shared ISO column
all_data <- happiness_clean %>% 
  right_join(wdi_clean, by = "iso2c")


# Save data ---------------------------------------------------------------

# Then we save this data frame as a CSV file and we're done!
write_csv(all_data, "data/world_happiness.csv")
# write_csv(all_data, "~/Desktop/world_happiness.csv")  # On my desktop

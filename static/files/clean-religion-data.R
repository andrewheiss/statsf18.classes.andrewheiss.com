# Load libraries ----------------------------------------------------------
library(tidyverse)
library(readxl)


# Deal with religion data -------------------------------------------------

religion_raw <- read_excel("U.S. Religion Census Religious Congregations and Membership Study, 2010 (County File).XLSX")

religion_intermediate <- religion_raw %>% 
  # Only look at UTAH
  filter(STABBR == "UT") %>% 
  # Rearrange columns so they make more sense
  select(STCODE, STABBR, STNAME, CNTYCODE, CNTYNAME, FIPS, POP2010, everything()) %>% 
  # Gather all the RELIGIONCNG, RELIGIONADH, and RELIGIONRATE columns into one super long column
  gather(key, value, -c(STCODE, STABBR, STNAME, CNTYCODE, CNTYNAME, FIPS, POP2010)) %>% 
  # Split the new super long column into two parts, based on the regular
  # expression search pattern (regex)
  extract(key, c("religion", "variable"), regex = "(.*?)(CNG|ADH|RATE)") %>% 
  # Make these new variables nicer
  mutate(variable = recode(variable,
                           CNG = "congregations",
                           ADH = "adherents",
                           RATE = "adherents_per_1000"))

# Find out which religions have more than 4000 adherents
religions_greater_4000 <- religion_intermediate %>% 
  filter(variable == "adherents") %>% 
  group_by(religion) %>% 
  summarize(total = sum(value, na.rm = TRUE)) %>% 
  arrange(desc(total)) %>% 
  filter(total > 4000) %>% 
  # Remove "total" and "other"
  filter(religion != "TOT", religion != "OTH")

# Make a list of just the religion abbreviations
religions_to_keep <- religions_greater_4000 %>% 
  pull(religion)
religions_to_keep

religion_utah <- religion_intermediate %>% 
  # Only select religions that have at least 4000 adherents
  filter(religion %in% religions_to_keep) %>% 
  # Make columns for congregations, adherents, and adherents per 1000
  spread(variable, value) %>% 
  # Only select a few columns and make their names nicer
  select(county = CNTYNAME, population_2010 = POP2010,
         religion, adherents, adherents_per_1000, congregations)

# Save this cleaner version
write_csv(religion_utah, "religion_utah.csv")



# Deal with religion names ------------------------------------------------

# Manually create a table of religion abbreviations and full names
# (I looked these up in the codebook for the original data)
religion_names <- tribble(
  ~religion,                ~religion_clean,
  "AG",                 "Assemblies of God",
  "EC",                  "Episcopal Church",
  "PC",         "Pentecostal Church of God",
  "GRK",                   "Greek Orthodox",
  "LDS",                              "LDS",
  "SBC",      "Southern Baptist Convention",
  "UMC",          "United Methodist Church",
  "BUDM",              "Buddhism, Mahayana",
  "CATH",                        "Catholic",
  "EVAN",                     "Evangelical",
  "LCMS", "Lutheran Church, Missouri Synod",
  "MPRT",             "Mainline Protestant",
  "MSLM",                          "Muslim",
  "NOND",              "Non-denominational",
  "ORTH",                        "Orthodox"
)

write_csv(religion_names, "religion_names.csv")

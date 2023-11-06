#----------------------------------------
# Script to clean data
#----------------------------------------
# Date: November 3rd, 2023
#----------------------------------------

#----------------------------------------
# Read data
#----------------------------------------
cps <- read_csv(file.path(cps_data,"cps_00058.csv"),
                name_repair = make_clean_names
                ) 
cps  |> glimpse()

#----------------------------------------
# Clean data
#----------------------------------------

# restrict sample to 18 to 65 years old
cps  <- cps  |>
    filter(age >= 18 & age <= 65)

# restrict sample to people working full time
cps  <- cps  |>
    filter(fullpart == 1)

# remove self-employed and wokring without 
# pay workers
cps  <- cps  |>
    filter(!(classwkr %in% c(10, 13, 14, 29, 99)))

# remove people living in group quarters
cps  <- cps  |> 
    filter(famunit == 1)


# remove NA and NIU from wage
cps  <- cps  |>
    filter(!is.na(incwage) & incwage != 99999999 & incwage != 99999998)

# change the top coding of incwage 

cps  <- cps |> 
    mutate(incwage_topcoded = case_when(
        year <= 1967 & year >= 1962 & incwage == 99999   ~ 99999 * 1.33,
        year <= 1975 & year >= 1968 & incwage == 99999   ~ 99999 * 1.33,
        year <= 1981 & year >= 1976 & incwage == 50000   ~ 50000 * 1.33,
        year <= 1984 & year >= 1982 & incwage == 75000   ~ 75000 * 1.33,
        year <= 1987 & year >= 1985 & incwage == 99999   ~ 99999 * 1.33,
        year <= 1995 & year >= 1988 & incwage == 199998  ~ 199998 * 1.33,
        year <= 2010 & year >= 1996 & incwage == 999999  ~ 999999 * 1.33,
        year <= 2023 & year >= 2011 & incwage == 9999999 ~ 9999999 * 1.33,
        TRUE ~ incwage
    ))

# remove NA and NIU from ahrsworkt
cps  <- cps  |>
    filter(!is.na(ahrsworkt) & ahrsworkt != 999)

# remove NIU and Unknown from ind1990
cps  <- cps  |>
    filter(!is.na(ind1990) & ind1990 != 000 & ind1990 != 998)

# only keep californians
cps  <- cps  |>
    filter(statefip == 6)

# Group by year and industry and count the number of people in each
year_industry_counts <- cps %>%
  group_by(year, ind1990) %>%
  summarise(count = n(), .groups = 'drop')

# Calculate the total number of employees for each year
total_employees_by_year <- year_industry_counts %>%
  group_by(year) %>%
  summarise(total_count = sum(count), .groups = 'drop')

# Join the counts with the total counts by year to be able to calculate shares
year_industry_shares <- year_industry_counts %>%
  left_join(total_employees_by_year, by = "year") %>%
  mutate(share = count / total_count)

# Convert shares to percentages
year_industry_shares <- year_industry_shares %>%
  mutate(percentage = share * 100)

# View the industry shares by year in percentage
print(year_industry_shares)

# save data
write_csv(year_industry_shares, file.path(datasets,"year_industry_shares.csv"))

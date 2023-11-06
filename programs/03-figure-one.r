#----------------------------------------
# Script to create figure
#----------------------------------------
# Date: November 5th, 2023
#----------------------------------------

#----------------------------------------
# load data
#----------------------------------------
year_industry_shares <- read_csv(file.path(datasets,"year_industry_shares.csv"))

#----------------------------------------
# create a plot of share of labor
# by industry in California over time
# also highlight industries that are
# probably carbon intensive (dirty)
# and clean industries
#----------------------------------------

# Define the mapping of industries to labels
# and Filter and summarize the data

# Filter and summarize the data
industry_focus <- year_industry_shares |>
  filter(year >= 2000, year <= 2023) |>
  mutate(industry_label = case_when(
    ind1990 %in% 40:50 ~ "Mining",
    ind1990 %in% 200:201 ~ "Petroleum and coal products",
    ind1990 %in% 450:472 ~ "Utilities and sanitary services",
    ind1990 %in% 700:760 ~ "Finance, Insurance, and Real Estate",
    ind1990 %in% 800:810 ~ "Entertainment"
  )) |>
  group_by(year, industry_label) |> 
  summarise(average_percentage = mean(percentage), .groups = 'drop')

industry_focus <- industry_focus  |>  
  filter(!is.na(industry_label))  # Keep only the industries of interest

# Determine the location for the labels
label_data <- industry_focus |>
  group_by(industry_label) |>
  filter(year == max(year))  # Assuming the latest year is the most appropriate for label placement

# Create the plot
ggplot(industry_focus, aes(x = year, y = average_percentage, group = industry_label)) +
  geom_line(aes(color = industry_label)) +
  geom_text_repel(data = label_data, aes(label = industry_label), vjust = -0.5, hjust = 1.1) +
  geom_vline(xintercept = 2020, linetype="dashed", color = "red") +
  scale_color_brewer(palette = "Set2") +  # Colorblind-friendly palette
  labs(title = "Average Percentage of Workers by Industry (2000-2023)",
       x = "Year",
       y = "Average Percentage of Labor Share") +
  theme_customs() +
  theme(legend.position = "none") # No legend needed


# Save the plot if needed
ggsave(file.path(figures_wd,"highlighted_industry_labor_shares_over_time.png"), width = 12, height = 8, units = "in")
ggsave(file.path(thesis_plots,"highlighted_industry_labor_shares_over_time.png"), width = 12, height = 8, units = "in")

setwd('/Users/gc3045/scmail_v1/sc-mail-experiments/Real_biodata/TLSCL/pynbs/')
library(ggplot2)

install.packages('tidyverse')
library(tidyverse)

d = read.table("bar12_cellstates_over_time.csv", sep=",", header=T)

d2 = d %>% mutate(sum_of_rows = rowSums)
d$interval_start <- d$interval_start * 120

# Reshape the dataframe from wide to long format
df_long <- d %>%
  pivot_longer(cols = -interval_start, names_to = "Cell_Type", values_to = "Count")


ggplot(df_long, aes(x = interval_start, y = Count, fill = Cell_Type)) +
  geom_area() +
  labs(x = "Interval Start", y = "Count", title = "Cell Types (Experiment Barcode 12: TLSCL)") +
  theme_minimal()

# the kinds of transitions over time are more interesting
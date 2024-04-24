setwd('/Users/gc3045/scmail_v1/sc-mail-experiments/Real_biodata/TLSCL/evaluation/Bar12/CellTypeAnnotation')
library(ggplot2)

#install.packages('tidyverse')
library(tidyverse)

# d = read.table("bar12_cellstates_over_time.csv", sep=",", header=T)
d = read.table("bar12_improved_cellstates_over_time.csv", sep=",", header=T)


# Normalize each row
df_normalized <- d %>%
  # Select only the columns with observed counts (excluding Interval_Start)
  select(-interval_start) %>%
  # Apply row-wise normalization
  rowwise() %>%
  # Normalize each value by dividing by the row sum
  mutate(across(everything(), ~ . / sum(c_across(everything()))))


#d2 = d %>% mutate(sum_of_rows = rowSums)
df_normalized$interval_start <- d$interval_start * 120
#df_normalized$interval_start <- df_normalized$interval_start * 120

# Reshape the dataframe from wide to long format
df_long <- df_normalized %>%
  pivot_longer(cols = -interval_start, names_to = "Cell_Type", values_to = "Count")


PCGLC_idx <- df_normalized$interval_start[which(df_normalized['PCGLC'] != 0)[1]]
endoderm_idx <- df_normalized$interval_start[which(df_normalized['Endoderm'] != 0)[1]]
SomiteDermo_idx <- df_normalized$interval_start[which(df_normalized['SomiteDermo'] != 0)[1]]
SomiteSclero_idx <- df_normalized$interval_start[which(df_normalized['SomiteSclero'] != 0)[1]]
NeuralTube1_idx <- df_normalized$interval_start[which(df_normalized['NeuralTube1'] != 0)[1]]
NeuralTube2_idx <- df_normalized$interval_start[which(df_normalized['NeuralTube2'] != 0)[1]]

ggplot(df_long, aes(x = interval_start, y = Count, fill = Cell_Type, label=Cell_Type)) +
  geom_area() +
  geom_vline(xintercept = PCGLC_idx, linetype = 'dashed', color="#1ABC56") +
  geom_vline(xintercept = endoderm_idx, linetype = 'dashed', color="#E38900") +
  geom_vline(xintercept = SomiteDermo_idx, linetype = 'dashed', color="#FB61D7") +
  geom_vline(xintercept = SomiteSclero_idx, linetype = 'dashed', color="#FC67A9") +
  geom_vline(xintercept = NeuralTube1_idx, linetype = 'dashed', color="#C49A00") +
  geom_vline(xintercept = NeuralTube2_idx, linetype = 'dashed', color="#99A801") +
  labs(x = "Experiment Time", y = "Proportion of Lineages", title = "Cell Types (Experiment Barcode 12: TLSCL)") +
  annotate(geom="label",x=PCGLC_idx,y=0.4,color="#1ABC56",label="PCGLC", fill="white") +
  annotate(geom="label",x=endoderm_idx,y=0.9,color="#E38900",label="Endoderm", fill="white") +
  annotate(geom="label",x=SomiteDermo_idx,y=0.15,color="#FB61D7",label="SomiteDermo", fill="white") +
  annotate(geom="label",x=SomiteSclero_idx,y=0.1,color="#FC67A9",label="SomiteSclero", fill="white") +
  annotate(geom="label",x=NeuralTube1_idx,y=0.9,color="#C49A00",label="NeuralTube1", fill="white") +
  annotate(geom="label",x=NeuralTube2_idx,y=0.70,color="#99A801",label="NeuralTube2", fill="white") +
  theme_minimal() 
  
ggsave("stackedplot_celltype_barcode12_improved.pdf")

# the kinds of transitions over time are more interesting
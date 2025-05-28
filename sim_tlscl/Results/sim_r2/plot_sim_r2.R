
library(dplyr)
library(ggplot2)
setwd("/Users/gc3045/git/laml-experiments/sim_tlscl/Results/sim_r2")


method_colors <- c(
  "Cassiopeia-Greedy" = "#EE3377", 
  "Cassiopeia-Hybrid" = "#56B4E9",  
  "Cassiopeia-ILP-Def " = "#AA4499", 
  "Startle-NNI" = "#0072B2",         
  "LAML" = "#000000",     
  "LAML(Startle)" = "#CC79A7",           
  "LAML(Cass-Hybrid)" = "#D55E00",
  "LAML(Startle)-nomissing" = "#E69F00"
)

################################################################################################################################################################
# set 1
data = read.csv("stats/set1a_stats.txt",header=T)
data <- data %>%
  mutate(rf = as.numeric(rf))

data <- data %>%
  mutate(method = case_when(
    method == "cassgreedy" ~ "Cassiopeia-Greedy",
    method == "casshybrid" ~ "Cassiopeia-Hybrid",
    method == "laml" ~ "LAML",
    method == "startle" ~ "Startle-NNI",
    TRUE ~ method  # Keep other values unchanged if any
  ))
data <- data %>%
  mutate(method = factor(method, levels = c("Cassiopeia-Greedy", "Cassiopeia-Hybrid", "Startle-NNI", "LAML")))

head(data)

ggplot(data, aes(x = k, y = rf, color = method)) +
  stat_summary() + 
  geom_line(stat = "summary") +  # Line plot for each method
  labs(
    title = "RF Error Over Sequence Length K (s50d50)",
    x = "Sequence Length K",
    y = "Mean RF Error",
    color = "Method"
  ) +
  scale_color_manual(values = method_colors) + 
  theme_minimal() + theme_bw() + 
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
    text = element_text(size = 16),
    legend.position = "bottom"
  ) + 
  guides(color = guide_legend(nrow = 2))
ggsave("pdfs/simr2_set1a.cbf.pdf", width=8, height=8)

################################################################################################################################################################
# set 1b
data = read.csv("stats/set1b_stats.txt",header=T)
data <- data %>%
  mutate(rf = as.numeric(rf))

head(data)
data <- data %>%
  filter(method != "laml-casshybrid") %>% # Exclude LAML(Cass-Hybrid)
  filter(method != "laml-startle-nomissing") %>% 
  mutate(method = case_when(
    method == "cassgreedy" ~ "Cassiopeia-Greedy",
    method == "casshybrid" ~ "Cassiopeia-Hybrid",
    method == "laml-startle" ~ "LAML(Startle)",
    method == "laml-casshybrid" ~ "LAML(Cass-Hybrid)",
    method == "laml-startle-nomissing" ~ "LAML(Startle)-nomissing",
    method == "startle" ~ "Startle-NNI",
    TRUE ~ method  # Keep other values unchanged if any
  ))
data <- data %>%
  mutate(method = factor(method, levels = c("Cassiopeia-Greedy", "Cassiopeia-Hybrid", "Startle-NNI", "LAML(Startle)"))) #, "LAML(Cass-Hybrid)", "LAML(Startle)-nomissing")))
       
head(data)

ggplot(data, aes(x = k, y = rf, color = method)) +
  stat_summary() + 
  geom_line(stat = "summary") +  # Line plot for each method
  labs(
    title = "RF Error Over Sequence Length K (s0d0)",
    x = "Sequence Length K",
    y = "Mean RF Error",
    color = "Method"
  ) +
  scale_color_manual(values = method_colors) + 
  theme_minimal() +theme_bw() + 
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
    text = element_text(size = 16),
    legend.position = "bottom"
  ) + 
  guides(color = guide_legend(nrow = 2))

ggsave("pdfs/simr2_set1b.cbf.pdf", width=8, height=8)

################################################################################################################################################################
# set 2
data = read.csv("stats/set2_stats.txt",header=T)
data <- data %>%
  mutate(rf = as.numeric(rf))

head(data)
data <- data %>%
  mutate(method = case_when(
    method == "cassgreedy" ~ "Cassiopeia-Greedy",
    method == "casshybrid" ~ "Cassiopeia-Hybrid",
    method == "laml" ~ "LAML",
    method == "startle" ~ "Startle-NNI",
    TRUE ~ method  # Keep other values unchanged if any
  ))
data <- data %>%
  mutate(method = factor(method, levels = c("Cassiopeia-Greedy", "Cassiopeia-Hybrid", "Startle-NNI", "LAML")))

head(data)

ggplot(data, aes(x = M, y = rf, color = method)) +
  stat_summary() + 
  geom_line(stat = "summary") +  # Line plot for each method
  labs(
    title = "RF Error Over Max Alphabet Size M (s50d50)",
    x = "Max Alphabet Size M",
    y = "Mean RF Error",
    color = "Method"
  ) +
  scale_color_manual(values = method_colors) + 
  theme_minimal() +theme_bw() + 
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
    text = element_text(size = 16),
    legend.position = "bottom"
  ) + 
  guides(color = guide_legend(nrow = 2))
ggsave("pdfs/simr2_set2.cbf.pdf", width=8, height=8)

################################################################################################################################################################
# set 3
data = read.csv("stats/set3_stats.txt",header=T)
data <- data %>%
  mutate(rf = as.numeric(rf))

head(data)
data <- data %>%
  mutate(method = case_when(
    method == "cassgreedy" ~ "Cassiopeia-Greedy",
    method == "casshybrid" ~ "Cassiopeia-Hybrid",
    method == "laml" ~ "LAML",
    method == "startle" ~ "Startle-NNI",
    TRUE ~ method  # Keep other values unchanged if any
  ))
data <- data %>%
  mutate(method = factor(method, levels = c("Cassiopeia-Greedy", "Cassiopeia-Hybrid", "Startle-NNI", "LAML")))

head(data)

# subset to the 34 samples Cassiopeia-Hybrid has data for
library(dplyr)

# Step 1: Subset data for m_prop = m0
m0_data <- data %>% filter(m_prop == "m0") %>%
  filter(!is.na(rf))

# Step 2: Filter to keep only reps and p_reps with all four methods
complete_data <- m0_data %>%
  group_by(p_rep, rep) %>%
  filter(n_distinct(method) == 4) %>%
  ungroup()

head(complete_data)

# Step 3: Calculate average rf for each method
result <- complete_data %>%
  group_by(method) %>%
  summarize(avg_rf = mean(rf, na.rm = TRUE))

# Display the result
print(result)


ggplot(data, aes(x = m_prop, y = rf, color = method)) +
  geom_boxplot() + 
  #geom_line(stat = "summary") +  # Line plot for each method
  labs(
    title = "RF Error Over Missing Data Prop (s50d50)",
    x = "Missing Data Proportion",
    y = "Mean RF Error",
    color = "Method"
  ) +
  scale_color_manual(values = method_colors) + 
  theme_minimal() +theme_bw() + 
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
    text = element_text(size = 16),
    legend.position = "bottom"
  ) + 
  guides(color = guide_legend(nrow = 2))

ggsave("pdfs/simr2_set3.cbf.pdf", width=8, height=8)

################################################################################################################################################################
# set 4
data = read.csv("stats/set4_stats.txt",header=T)
data <- data %>%
  mutate(rf = as.numeric(rf))

head(data)
data <- data %>%
  mutate(method = case_when(
    method == "cassgreedy" ~ "Cassiopeia-Greedy",
    method == "casshybrid" ~ "Cassiopeia-Hybrid",
    method == "cassilp" ~ "Cassiopeia-ILP-Def",
    method == "laml" ~ "LAML",
    method == "startle" ~ "Startle-NNI",
    TRUE ~ method  # Keep other values unchanged if any
  ))
data <- data %>%
  mutate(method = factor(method, levels = c("Cassiopeia-Greedy", "Cassiopeia-Hybrid", "Cassiopeia-ILP-Def", "Startle-NNI", "LAML")))

head(data)

ggplot(data, aes(x = method, y = rf, color = method)) +
  geom_boxplot() + 
  labs(
    title = "RF Error Over Methods on 30 cells (s50d50)",
    x = "",
    y = "Mean RF Error",
    color = "Method"
  ) +
  scale_color_manual(values = method_colors) + 
  theme_minimal() + theme_bw() + 
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
    text = element_text(size = 16),
    legend.position = "none", # Remove the legend
    axis.text.x = element_text(angle = 45, hjust = 1) # Tilt x-axis labels by 45 degrees
  )

ggsave("pdfs/simr2_set4.cbf.pdf", width=8, height=8)


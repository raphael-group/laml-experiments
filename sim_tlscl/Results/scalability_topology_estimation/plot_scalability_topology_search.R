data <- read.csv('/Users/gc3045/laml_experiments/rebuttal/scalability_topology_estimation/resource_results/combined_results.csv')
head(data)
# Convert memory_usage from KB to GB
#data$memory_usage_gb <- data$memory_usage / (1024 * 1024)

library(ggplot2)

# Filter data for laml_fastEM_gpu algorithm
laml_data <- subset(data, algorithm == "laml_fastEM_gpu")

plot_data <- data %>% 
  filter(algorithm %in% c("greedy", "nj", "laml_fastEM_gpu", "laml_fastEM_cpu"),
         alphabet_size %in% c(30, 100),
         num_cells != 10000) %>%  # Add this line to exclude 10,000 cells
  mutate(algorithm = case_when(
    algorithm == "greedy" ~ "Cassiopeia-Greedy",
    algorithm == "nj" ~ "Neighbor Joining",
    algorithm == "laml_fastEM_gpu" ~ "LAML-fastEM-GPU",
    algorithm == "laml_fastEM_cpu" ~ "LAML-fastEM-CPU",
    algorithm == "startle" ~ "Startle-NNI",
    TRUE ~ algorithm
  ))

algorithms_to_check <- c("Neighbor Joining", "LAML-fastEM-GPU", "LAML-fastEM-CPU", "Startle-NNI")

# Create a filtered dataset
filtered_plot_data <- plot_data %>%
  filter(algorithm != "Cassiopeia-Greedy") %>%
  group_by(num_chars, alphabet_size, seed_prior, num_cells, seq_prior) %>%
  filter(all(algorithms_to_check %in% algorithm)) %>%
  ungroup()
print(unique(filtered_plot_data[c("num_chars", "alphabet_size", "seed_prior", "num_cells", "seq_prior")]))


# Define custom color palette
custom_palette <- c("Startle" = "#E41A1C", 
                    "Neighbor Joining" = "#377EB8", 
                    "LAML-fastEM-GPU" = "#4DAF4A",
                    "LAML-fastEM-CPU" = "#984EA3")


# Filter out Cassiopeia-Greedy
filtered_data <- plot_data %>%
  filter(algorithm != "Cassiopeia-Greedy")

ggplot(data, aes(x = num_cells, y = runtime, color = algorithm)) +
  stat_summary(fun = mean, geom = "point", size = 3) +
  stat_summary(fun = mean, geom = "line", aes(group = algorithm)) +
  stat_summary(fun.data = mean_se, geom = "errorbar", width = 0.2) +
  scale_color_brewer(palette = "Set1") +
  scale_y_log10(labels = scales::comma) +
  labs(title = "Runtime Comparison (Log Scale)",
       x = "Number of Cells",
       y = "Runtime (seconds, log scale)",
       color = "Algorithm") +
  theme_minimal() +
  theme(legend.position = "right")


summary_stats <- data %>%
  group_by(algorithm, num_cells) %>%
  summarise(
    avg_runtime = mean(runtime),
    se_runtime = sd(runtime) / sqrt(n()),
    .groups = 'drop'
  ) %>%
  arrange(num_cells, algorithm)

# Print the summary statistics
print(summary_stats, n = Inf)


# Memory usage plot
ggplot(plot_data, aes(x = num_cells, y = memory_usage, color = algorithm, shape = factor(alphabet_size))) +
  geom_point(size = 3, alpha = 0.7) +
  geom_line(aes(group = interaction(algorithm, alphabet_size)), alpha = 0.5) +
  scale_color_brewer(palette = "Set1") +
  scale_shape_manual(values = c(16, 17), name = "Alphabet Size") +
  labs(title = "Memory Usage Comparison",
       x = "Number of Cells",
       y = "Memory Usage (KB)",
       color = "Algorithm") +
  theme_minimal() +
  theme(legend.position = "right")

# CPU usage plot
ggplot(plot_data, aes(x = num_cells, y = cpu_usage, color = algorithm, shape = factor(alphabet_size))) +
  geom_point(size = 3, alpha = 0.7) +
  geom_line(aes(group = interaction(algorithm, alphabet_size)), alpha = 0.5) +
  scale_color_brewer(palette = "Set1") +
  scale_shape_manual(values = c(16, 17), name = "Alphabet Size") +
  labs(title = "CPU Usage Comparison",
       x = "Number of Cells",
       y = "CPU Usage (%)",
       color = "Algorithm") +
  theme_minimal() +
  theme(legend.position = "right")



### 

### GPU memory usage
ggplot(data = na.omit(laml_data), aes(x = factor(num_cells), y = memory_usage_gb)) +
  geom_boxplot(fill = "lightblue", color = "blue") +
  labs(title = "GPU Memory Usage for laml_fastEM_gpu Algorithm",
       x = "Number of Cells",
       y = "Memory Usage (GB)",
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  scale_y_continuous(labels = scales::comma)

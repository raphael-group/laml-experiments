library(ggplot2)
library(dplyr)
library(patchwork)

library(tidyr)
# Read the CSV file
data <- read.csv("/Users/gc3045/laml_experiments/rebuttal/scalability_parameter_estimation/evaluations.csv")

# compare laml and fast-laml-em-cpu
result <- data %>%
  filter(alphabet_size == 100, # 30
         !grepl("failed", status, ignore.case = TRUE),
         algorithm %in% c("laml", "fast-laml-em-cpu")) %>%
  group_by(num_cells, algorithm) %>%
  summarize(avg_runtime = mean(runtime, na.rm = TRUE), .groups = 'drop') %>%
  pivot_wider(names_from = algorithm, values_from = avg_runtime) %>%
  mutate(runtime_speedup = laml / `fast-laml-em-cpu` ) %>%
  arrange(num_cells)

# Print the results
print(result, n = Inf)  # n = Inf ensures all rows are printed

# Define custom color palette
# Filter for LAML algorithm and convert memory to MB
plot_data <- data %>% 
  mutate(memory_usage_mb = memory_usage / 1024) %>%  # Convert KB to MB
  filter(algorithm %in% c("laml-ultrametric", "fast-laml-em-cpu", "fast-laml-em"),
         alphabet_size %in% c(30, 100),
         num_cells != 10000) %>%  # Add this line to exclude 10,000 cells
  mutate(algorithm = case_when(
    algorithm == "fast-laml-em" ~ "LAML-GPU",
    algorithm == "fast-laml-em-cpu" ~ "LAML-CPU",
    algorithm == "laml-ultrametric" ~ "LAML-ultra",
    TRUE ~ algorithm
  ))

plot_data_cpu_ultra <- plot_data %>% 
  mutate(memory_usage_mb = memory_usage / 1024) %>%
  filter(algorithm %in% c("LAML-ultra", "LAML-CPU"),
         alphabet_size %in% c(30, 100),
         num_cells != 10000) 

plot_data_all <- plot_data %>% 
  mutate(memory_usage_mb = memory_usage / 1024) %>%
  filter(algorithm %in% c("LAML-ultra", "LAML-CPU", "LAML-GPU"),
         alphabet_size %in% c(30, 100),
         num_cells != 10000)

library(ggplot2)
library(dplyr)
library(patchwork)

# Define custom color palette with specific order
custom_palette <- c("LAML-ultra" = "#E41A1C", 
                    "LAML-CPU" = "#377EB8", 
                    "LAML-GPU" = "#4DAF4A")

create_plot <- function(data, y_var, y_label, log_scale = FALSE, show_x_label = FALSE, show_legend = FALSE) {
  # Ensure consistent order of algorithms
  data$algorithm <- factor(data$algorithm, levels = names(custom_palette))
  
  p <- ggplot(data, aes(x = factor(num_cells), y = !!sym(y_var), fill = algorithm)) +
    geom_boxplot() +
    scale_fill_manual(values = custom_palette) +
    theme_minimal() +
    theme(
      legend.position = if(show_legend) "bottom" else "none",
      axis.title.x = element_blank(),
      axis.text.x = element_text(angle = 45, hjust = 1),
      panel.grid = element_blank(),
      axis.line = element_line(color = "black"),
      panel.background = element_rect(fill = "white"),
      axis.ticks = element_line(color = "black")
    ) +
    labs(y = y_label)
  
  if (log_scale) {
    p <- p + scale_y_log10()
  }
  
  if (show_x_label) {
    p <- p + labs(x = "Number of cells")
  }
  
  return(p)
}


# Create plots for each alphabet size
plots_30 <- list(
  create_plot(plot_data_cpu_ultra %>% filter(alphabet_size == 30), "memory_usage_mb", "Memory Usage (MB)", log_scale = TRUE, show_legend=FALSE),
  #create_plot(plot_data_cpu_ultra %>% filter(alphabet_size == 30) %>% filter(!grepl("failed", status, ignore.case = TRUE)), "memory_usage_mb", "Memory Usage (MB)", log_scale = TRUE, show_legend=FALSE),
  #  create_plot(plot_data_cpu_ultra %>% filter(alphabet_size == 30) %>% filter(!grepl("failed", status, ignore.case = TRUE)), "cpu_usage", "Usage %", show_legend=FALSE),
  create_plot(plot_data_all %>% filter(alphabet_size == 30) %>% filter(!grepl("failed", status, ignore.case = TRUE)), "runtime", "Runtime (s)", log_scale = TRUE, show_legend=FALSE)
)

plots_100 <- list(
  create_plot(plot_data_cpu_ultra %>% filter(alphabet_size == 100), "memory_usage_mb", "Memory Usage (MB)", log_scale = TRUE, show_x_label = TRUE, show_legend=FALSE),
  #create_plot(plot_data_cpu_ultra %>% filter(alphabet_size == 100) %>% filter(!grepl("failed", status, ignore.case = TRUE)), "memory_usage_mb", "Memory Usage (MB)", log_scale = TRUE, show_x_label = TRUE, show_legend=FALSE),
  #  create_plot(plot_data_cpu_ultra %>% filter(alphabet_size == 100) %>% filter(!grepl("failed", status, ignore.case = TRUE)), "cpu_usage", "Usage %", show_x_label = TRUE, show_legend=TRUE),
  create_plot(plot_data_all %>% filter(alphabet_size == 100) %>% filter(!grepl("failed", status, ignore.case = TRUE)), "runtime", "Runtime (s)", log_scale = TRUE, show_x_label = TRUE, show_legend=FALSE)
)

# Set base font size
base_size <- 28

# Combine plots
combined_plots <- (plots_30[[1]] + plots_30[[2]]) / # + plots_30[[3]]) /
  (plots_100[[1]] + plots_100[[2]]) + # + plots_100[[3]]) +
  plot_layout(guides = "collect") & 
  theme(
    text = element_text(size = base_size),
    axis.text = element_text(size = base_size),
    axis.title = element_text(size = base_size),
    legend.text = element_text(size = base_size),
    legend.title = element_text(size = base_size),
    legend.position = "bottom",
    plot.title = element_text(size = base_size + 2),
    plot.subtitle = element_text(size = base_size)
  )

# Add title for each row and overall x-axis label
combined_plots <- combined_plots +
  plot_annotation(
    title = "Performance Metrics Over Varying Number of Cells",
    subtitle = "Top: Alphabet Size 30, Bottom: Alphabet Size 100",
    theme = theme(
      plot.title = element_text(size = base_size + 2),
      plot.subtitle = element_text(size = base_size)
    ) 
  )
#combined_plot + scale_size_identity()

# Display the combined plot
print(combined_plots)

# Save the combined plot
ggsave("/Users/gc3045/laml_experiments/rebuttal/scalability_parameter_estimation/laml_parameter_estimation_comparison.pdf", 
       combined_plots, width = 18, height = 13, dpi = 300)

# Create new plot with num em_iterations
library(ggplot2)
library(dplyr)

# Create a new plot for EM iterations
em_iterations_plot <- ggplot(plot_data, aes(x = factor(num_cells), y = em_iterations, fill = algorithm)) +
  geom_boxplot() +
  scale_x_discrete(breaks = unique(plot_data$num_cells)) +
  labs(
    x = "Number of Cells",
    y = "Number of EM Iterations") +
  scale_y_log10() +
  theme_minimal() +
  theme(
    axis.title = element_text(size=20),
    axis.text = element_text(size=18),
    axis.text.x = element_text(angle = 45, hjust = 1),
    legend.position = "bottom",
    legend.text = element_text(size=18),
    legend.title = element_text(size=20),
    panel.grid = element_blank(),
    axis.line = element_line(color = "black"),
    axis.ticks = element_line(color = "black"),
    plot.background = element_rect(fill = "white", color = NA),
    panel.background = element_rect(fill = "white", color = NA),
    plot.title = element_text(size = 22, face = "bold", hjust = 0.5)
  ) +
  scale_fill_brewer(palette = "Set1", name = "Algorithm")

# Display the plot
print(em_iterations_plot)


plot_data_filtered_gpu <- plot_data_filtered %>% 
  filter(algorithm == "LAML-GPU")

head(plot_data_filtered_gpu)

plot_data_filtered_gpu <- plot_data_filtered %>% 
  filter(algorithm == "LAML-GPU") %>%
  mutate(alphabet_size = paste("Alphabet Size:", alphabet_size))

plot_data_filtered_gpu$alphabet_size <- factor(plot_data_filtered_gpu$alphabet_size, 
                                               levels = c("Alphabet Size: 30", "Alphabet Size: 100"))

em_iterations_plot <- ggplot(plot_data_filtered_gpu, 
                             aes(x = factor(num_cells), 
                                 y = em_iterations, 
                                 fill = alphabet_size)) +
  geom_boxplot(position = position_dodge(width = 0.8)) +
  scale_x_discrete(breaks = unique(plot_data_filtered_gpu$num_cells)) +
  labs(
    x = "Number of Cells",
    y = "Number of EM Iterations") +
  scale_y_continuous(
    breaks = c(1, 5, 10, 15, 20),
    limits = c(1, 20)
  ) +
  theme_minimal() +
  theme(
    axis.title = element_text(size=20),
    axis.text = element_text(size=18),
    axis.text.x = element_text(angle = 45, hjust = 1),
    legend.position = "bottom",
    legend.text = element_text(size=18),
    legend.title = element_text(size=20),
    panel.grid = element_blank(),
    axis.line = element_line(color = "black"),
    axis.ticks = element_line(color = "black"),
    plot.background = element_rect(fill = "white", color = NA),
    panel.background = element_rect(fill = "white", color = NA),
    plot.title = element_text(size = 22, face = "bold", hjust = 0.5)
  ) +
  scale_fill_manual(values = c("Alphabet Size: 30" = adjustcolor(custom_palette["LAML-GPU"], alpha.f = 0.9),  
                               "Alphabet Size: 100" = adjustcolor(custom_palette["LAML-GPU"], alpha.f = 0.5)), 
                    name = "",
                    breaks = c("Alphabet Size: 30", "Alphabet Size: 100"))

print(em_iterations_plot)




# Save the plot
ggsave("/Users/gc3045/laml_experiments/rebuttal/scalability_parameter_estimation/em_iterations_comparison.pdf", 
       em_iterations_plot, width = 12, height = 8)

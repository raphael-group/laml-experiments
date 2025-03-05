library(ggplot2)
library(dplyr)
library(patchwork)

# Read the data
data <- read.csv('/Users/gc3045/laml_experiments/rebuttal/scalability_topology_estimation/resource_results/evaluations.csv')

custom_palette <- c("LAML" = "#4DAF4A",
                    "Startle-NNI" = "#E41A1C", 
                    "Cassiopeia-Greedy" = "#FF7F00",  
                    "Neighbor Joining" = "#377EB8", 
                    "LAML-CPU" = "#984EA3")

# Process the data
processed_data <- data %>%
  filter(!is.na(cpu_usage) & !is.na(memory_usage) & !is.na(runtime)) %>%
  mutate(
    algorithm = case_when(
      algorithm == "laml_fastEM_gpu" ~ "LAML",
      algorithm == "laml_fastEM_cpu" ~ "LAML-CPU",
      algorithm == "nj" ~ "Neighbor Joining",
      TRUE ~ algorithm
    )
  ) %>%
  group_by(num_cells, algorithm) %>%
  summarise(
    avg_cpu_usage = mean(cpu_usage, na.rm = TRUE),
    avg_memory_usage = mean(memory_usage, na.rm = TRUE) / (1024 * 1024), # Convert to MB
    avg_runtime = mean(runtime, na.rm = TRUE) / 3600, # Convert to hours
    .groups = 'drop'
  )

processed_data <- processed_data %>%
  mutate(algorithm = factor(algorithm, levels = names(custom_palette)))



############################################################################
new_data <- read.csv('/Users/gc3045/laml_experiments/rebuttal/scalability_topology_estimation/combined_results.csv')

# Process the new data
new_processed_data <- new_data %>%
  filter(!(algorithm == "startle" & runtime < 1000)) %>%  # Remove startle entries with runtime < 10 seconds
  mutate(
    algorithm = case_when(
      algorithm == "laml_fastEM_gpu" ~ "LAML",
      algorithm == "laml_fastEM_cpu" ~ "LAML-CPU",
      algorithm == "nj" ~ "Neighbor Joining",
      algorithm == "greedy" ~ "Cassiopeia-Greedy",
      algorithm == "startle" ~ "Startle-NNI",
      TRUE ~ algorithm
    )
  ) %>%
  group_by(num_cells, algorithm) %>%
  summarise(
    avg_runtime = mean(runtime, na.rm = TRUE) / 3600, # Convert to hours
    .groups = 'drop'
  )

new_processed_data <- new_processed_data %>% mutate(algorithm = factor(algorithm, levels = names(custom_palette)))

create_plot <- function(additional_data, y_var, y_label, log_scale = FALSE, y_max = NULL, base_size=20) {
  # Filter out LAML-CPU
  additional_data <- additional_data[additional_data$algorithm != "LAML-CPU", ]
  p <- ggplot(additional_data, aes(x = num_cells, y = !!sym(y_var), color = algorithm)) +
    geom_point(size = 3) +
    geom_line(size = 1.5) +
    scale_color_manual(values = custom_palette)
  
  p <- p +
    scale_x_log10(breaks=c(250, 500, 1000, 2000, 4000), limits = c(250, 5000)) +
    labs(x = "Number of Cells", y = y_label) +
    theme_minimal() +
    theme(
      legend.position = "bottom",
      legend.text = element_text(size = base_size),
      legend.title = element_text(size = base_size),
      axis.title.x = element_text(size = base_size, margin = margin(t = 20, r = 0, b = 0, l = 0)),
      axis.title.y = element_text(size = base_size, margin = margin(t = 0, r = 20, b = 0, l = 0)),
      axis.text.x = element_text(size = base_size, margin = margin(t = 10, r = 0, b = 0, l = 0)),
      axis.text.y = element_text(size = base_size, margin = margin(t = 0, r = 10, b = 0, l = 0)),
      panel.grid = element_blank(),
      axis.line = element_line(color = "black"),
      axis.ticks = element_line(color = "black"),
      plot.margin = margin(t = 20, r = 20, b = 20, l = 20, unit = "pt")
    )
  
  if (log_scale) {
    p <- p + scale_y_log10(labels = scales::comma, breaks = scales::breaks_log(n = 5),
                           expand = expansion(mult = c(0.1, 0.2)),
                           oob = scales::squish_infinite)
  } else {
    y_range <- range(additional_data[[y_var]], na.rm = TRUE)
    y_padding <- diff(y_range) * 0.05
    p <- p + scale_y_continuous(labels = scales::comma, 
                                expand = expansion(mult = c(0.05, 0.1)),
                                limits = c(max(0, y_range[1] - y_padding), y_range[2] + y_padding),
                                oob = scales::squish_infinite,
                                breaks = scales::pretty_breaks(n = 5))
  }
  
  return(p)
}



base_size = 26
runtime_plot <- create_plot(new_processed_data, "avg_runtime", "Runtime (hours)", log_scale = FALSE, base_size=base_size)

runtime_plot

################### MEMORY
new_data <- read.csv('/Users/gc3045/laml_experiments/rebuttal/scalability_topology_estimation/combined_results.csv')


new_processed_data <- new_data %>%
  filter(!(algorithm == "startle" & runtime < 1000)) %>%  # Remove startle entries with runtime < 10 seconds (job failed and batchid stat was recorded wrong)
  filter(!(algorithm == "greedy" & as.numeric(as.character(memory_usage)) < 5000)) %>%  # Remove greedy entries where they used less than the greedy stats on 250 cells
  filter(!(algorithm == "laml_fastEM_gpu"))

kib_conv = 1048.576
new_entries <- data.frame(
  num_chars = c(30, 30, 30, 30),
  alphabet_size = c(30, 30, 30, 30),
  seed_prior = c(1, 1, 1, 1),
  num_cells = c(250, 500, 1000, 5000),
  seq_prior = c(1, 1, 1, 1),
  algorithm = rep("LAML", 4),
  memory_usage = c(474 * kib_conv, 462 * kib_conv, 558 * kib_conv, 898 * kib_conv),
  cpu_usage = c(NA, NA, NA, NA),  
  runtime = c(NA, NA, NA, NA)     
)

additional_data <- rbind(new_processed_data, new_entries)

additional_data <- additional_data %>%
  mutate(
    algorithm = case_when(
      algorithm == "laml_fastEM_gpu" ~ "LAML",
      algorithm == "laml_fastEM_cpu" ~ "LAML-CPU",
      algorithm == "nj" ~ "Neighbor Joining",
      algorithm == "greedy" ~ "Cassiopeia-Greedy",
      algorithm == "startle" ~ "Startle-NNI",
      TRUE ~ algorithm
    ),
    memory_usage_mb = as.numeric(as.character(memory_usage)) / 1024  # Convert KB to MB
  ) %>%
  group_by(num_cells, algorithm) %>%
  summarise(
    avg_memory_usage_mb = mean(memory_usage_mb, na.rm = TRUE),
    .groups = 'drop'
  )

new_processed_data <- new_processed_data %>% mutate(algorithm = factor(algorithm, levels = names(custom_palette)))

# If the original data was in KB, use this line instead:
# new_processed_data$memory_usage_mb <- as.numeric(as.character(new_processed_data$memory_usage)) / 1024 / 1024
create_memory_plot <- function(additional_data, y_var, y_label, log_scale = FALSE, y_max = NULL, base_size=20, exclude_algorithms = NULL) {
  if (!is.null(exclude_algorithms)) {
    additional_data <- additional_data[!additional_data$algorithm %in% exclude_algorithms, ]
  }
  p <- ggplot(additional_data, aes(x = num_cells, y = !!sym(y_var), color = algorithm)) +
    geom_point(size = 3) +
    geom_line(size = 1.5) +
    scale_color_manual(values = custom_palette)
  
  p <- p +
    scale_x_log10(breaks=c(250, 500, 1000, 2000, 4000), limits = c(250, 5000))+
    labs(x = "Number of Cells", y = y_label) +
    theme_minimal() +
    theme(
      legend.position = "bottom",
      legend.text = element_text(size = base_size),
      legend.title = element_text(size = base_size),
      axis.title.x = element_text(size = base_size, margin = margin(t = 20, r = 0, b = 0, l = 0)),
      axis.title.y = element_text(size = base_size, margin = margin(t = 0, r = 20, b = 0, l = 0)),
      axis.text.x = element_text(size = base_size, margin = margin(t = 10, r = 0, b = 0, l = 0)),
      axis.text.y = element_text(size = base_size, margin = margin(t = 0, r = 10, b = 0, l = 0)),
      panel.grid = element_blank(),
      axis.line = element_line(color = "black"),
      axis.ticks = element_line(color = "black"),
      plot.margin = margin(t = 20, r = 20, b = 20, l = 20, unit = "pt")
    )
  
  if (log_scale) {
    p <- p + scale_y_log10(labels = scales::comma, breaks = scales::breaks_log(n = 5),
                           expand = expansion(mult = c(0.1, 0.2)),
                           oob = scales::squish_infinite)
  } else {
    y_range <- range(additional_data[[y_var]], na.rm = TRUE)
    y_padding <- diff(y_range) * 0.05
    p <- p + scale_y_continuous(labels = scales::comma, 
                                expand = expansion(mult = c(0.05, 0.1)),
                                limits = c(max(0, y_range[1] - y_padding), y_range[2] + y_padding),
                                oob = scales::squish_infinite,
                                breaks = scales::pretty_breaks(n = 5))
  }
  
  return(p)
}

# Create the memory usage plot
base_size = 26
memory_plot <- create_memory_plot(additional_data, "avg_memory_usage_mb", "Memory (MB)", 
                                  log_scale = FALSE, base_size=base_size, 
                                  exclude_algorithms = "LAML-CPU")

# Display the plot
memory_plot

################### CPU/GPU Usage (%)
new_data <- read.csv('/Users/gc3045/laml_experiments/rebuttal/scalability_topology_estimation/combined_results.csv')

new_processed_data_cpu <- new_data %>%
  filter(!(algorithm == "startle" & runtime < 1000)) %>%  # Remove startle entries with runtime < 1000 seconds
  filter(!(as.numeric(cpu_usage) < 10)) %>%
  #filter(!(algorithm == "greedy" & num_cells == 500 & as.numeric(cpu_usage) < 10)) %>%
  #filter(!(algorithm == "greedy" & num_cells == 1000 & as.numeric(cpu_usage) < 10)) %>%
  mutate(
    algorithm = case_when(
      algorithm == "laml_fastEM_gpu" ~ "LAML",
      algorithm == "laml_fastEM_cpu" ~ "LAML-CPU",
      algorithm == "nj" ~ "Neighbor Joining",
      algorithm == "greedy" ~ "Cassiopeia-Greedy",
      algorithm == "startle" ~ "Startle-NNI",
      TRUE ~ algorithm
    ),
    cpu_usage = as.numeric(as.character(cpu_usage))  # Convert to numeric if needed
  ) %>%
  group_by(num_cells, algorithm) %>%
  summarise(
    cpu_usage = mean(cpu_usage, na.rm = TRUE),
    .groups = 'drop'
  )

new_processed_data_cpu <- new_processed_data_cpu %>% mutate(algorithm = factor(algorithm, levels = names(custom_palette)))

# Create the CPU usage plot function
create_cpu_plot <- function(additional_data, y_var, y_label, log_scale = FALSE, y_max = NULL, base_size=20, exclude_algorithms = NULL) {
  if (!is.null(exclude_algorithms)) {
    additional_data <- additional_data[!additional_data$algorithm %in% exclude_algorithms, ]
  }
  
  p <- ggplot(additional_data, aes(x = num_cells, y = !!sym(y_var), color = algorithm)) +
    geom_point(size = 3) +
    stat_summary(fun=mean, geom="point") + 
    stat_summary(fun=mean, geom="line") + 
    geom_line(size = 1.5) +
    scale_color_manual(values = custom_palette)
  
  p <- p +
    scale_x_log10(breaks=c(250, 500, 1000, 2000, 4000), limits = c(250, 5000))+
    #scale_x_log10(labels = scales::comma, breaks = scales::breaks_log(n = 5)) +
    labs(x = "Number of Cells", y = y_label) +
    theme_minimal() +
    theme(
      legend.position = "bottom",
      legend.text = element_text(size = base_size),
      legend.title = element_text(size = base_size),
      axis.title.x = element_text(size = base_size, margin = margin(t = 20, r = 0, b = 0, l = 0)),
      axis.title.y = element_text(size = base_size, margin = margin(t = 0, r = 20, b = 0, l = 0)),
      axis.text.x = element_text(size = base_size, margin = margin(t = 10, r = 0, b = 0, l = 0)),
      axis.text.y = element_text(size = base_size, margin = margin(t = 0, r = 10, b = 0, l = 0)),
      panel.grid = element_blank(),
      axis.line = element_line(color = "black"),
      axis.ticks = element_line(color = "black"),
      plot.margin = margin(t = 20, r = 20, b = 20, l = 20, unit = "pt")
    )
  
  if (log_scale) {
    p <- p + scale_y_log10(labels = scales::comma, breaks = scales::breaks_log(n = 5),
                           expand = expansion(mult = c(0.1, 0.2)),
                           oob = scales::squish_infinite)
  } else {
    y_range <- range(additional_data[[y_var]], na.rm = TRUE)
    y_padding <- diff(y_range) * 0.05
    p <- p + scale_y_continuous(labels = scales::comma, 
                                expand = expansion(mult = c(0.05, 0.1)),
                                limits = c(max(0, y_range[1] - y_padding), y_range[2] + y_padding),
                                oob = scales::squish_infinite,
                                breaks = scales::pretty_breaks(n = 5))
  }
  
  return(p)
}

# Create the CPU usage plot
base_size = 26
cpu_plot <- create_cpu_plot(new_processed_data_cpu, "cpu_usage", "Usage (%)", 
                            log_scale = FALSE, base_size=base_size, 
                            exclude_algorithms = "LAML-CPU")

# Display the plot
print(cpu_plot)
################### Combine


cpu_plot <- cpu_plot + theme(legend.position = "none")
memory_plot <- memory_plot + theme(legend.position = "none")

# Keep the legend only for the runtime plot

combined_plot <- (memory_plot | runtime_plot) + #  (memory_plot | cpu_plot | runtime_plot) +
  plot_layout(guides = "collect") &
  plot_annotation(
    title = "Performance Metrics vs Number of Cells",
    theme = theme(
      plot.title = element_text(size = base_size),
      legend.position = "bottom",
      legend.text = element_text(size = base_size),
      legend.title = element_text(size = base_size),
      legend.margin = margin(t = 20, r = 0, b = 0, l = 0),  # Add some top margin
      legend.box.margin = margin(0, 0, 0, 0)  # Remove margin around the legend box
    )
  ) 

# Display combined plot
print(combined_plot)

ggsave("/Users/gc3045/laml_experiments/rebuttal/scalability_topology_estimation/performance_metrics_comparison_plot.pdf", combined_plot, 
       width = 18, height = 6)  # Slightly increased height to accommodate the legend



######################
new_data <- read.csv('/Users/gc3045/laml_experiments/rebuttal/scalability_topology_estimation/combined_results.csv')
result <- new_data %>%
  filter(alphabet_size == 100, 
         algorithm %in% c("laml_fastEM_cpu")) %>%
  group_by(num_cells, algorithm) %>%
  summarize(avg_runtime = mean(runtime, na.rm = TRUE), .groups = 'drop') %>%
  pivot_wider(names_from = algorithm, values_from = avg_runtime) %>%
  arrange(num_cells)
result

#
#[gc3045@rinse stats]$ vi em_ultr_varysize_runtime.txt
#[gc3045@rinse stats]$ awk -F',' 'NR>1 {sum[$2]+=$3; count[$2]++}
#    END {for (size in sum) printf "%d,%.2f\n", size, sum[size]/count[size]}'  em_ultr_varysize_runtime.txt
#250,90.62
#500,187.86
#750,332.48
#1000,580.19

#
#[gc3045@rinse sim_tlscl]$ for file in s50d50p*_sub250_r*/EM_problin_toposearch_ultra.log; do
#tac "$file" | grep -m 1 "Runtime (s)" | awk '{print $NF}'
#done | awk '{ sum += $1; count++ } END { if (count > 0) print "Average runtime:", sum/count, "seconds" }'

#Average runtime for old LAML on 250 cells: 17961.3 seconds

17961.3 / 106
17961.3 / 5560
17961.3 / 5560
17961.3 / 3123.45

# 3123.45 is LAML-CPU runtime on 250 cells
# 17961.3 / 3123.45 = 5.75x
# 7103.12 is LAML-CPU runtime on 500 cells
# 302400 / 7103.12 = 43x

# about 168 hours on 1024 cells. approximate with 84 hours on 500 cells. 




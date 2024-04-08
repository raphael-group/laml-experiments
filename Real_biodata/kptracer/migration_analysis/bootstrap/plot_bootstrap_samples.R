setwd('/Users/gc3045/sc-mail-experiments/Real_biodata/kptracer/migration_analysis/bootstrap')

require(ggplot2)

d = read.table("bootstrap_samples1000.txt",header=T,sep=',')
d = na.omit(d)
d$Scaled_First_Metastasis = d$First_Metastasis * 6 / d$Num_Intervals 
d$Scaled_Peak_Metastasis = d$Peak_Metastasis * 6 / d$Num_Intervals 
d$Scaled_First_Reseeding = d$First_Reseeding * 6 / d$Num_Intervals 
head(d)
library(dplyr)

round_to_1_decimal <- function(value) {
  return(as.character(round(value, 1)))
}

# Calculating average and confidence interval for each column
mean_val <- mean(d$Scaled_First_Metastasis, na.rm = TRUE)
median_val <- median(d$Scaled_First_Metastasis, na.rm = TRUE)
sd_val <- sd(d$Scaled_First_Metastasis, na.rm = TRUE)

mean_val_100 <- mean(d$Scaled_First_Metastasis[1:100], na.rm = TRUE)
median_val_100 <- median(d$Scaled_First_Metastasis[1:100], na.rm = TRUE)
sd_val_100 <- sd(d$Scaled_First_Metastasis[1:100], na.rm = TRUE)

ci <- quantile(d$Scaled_First_Metastasis, c(0.125, 0.875))
ci_100 <- quantile(d$Scaled_First_Metastasis[1:100], c(0.125, 0.875))

obs_first_met <- 1.151981
plot_column1 <- ggplot(d, aes(x = Scaled_First_Metastasis, color = "Column 1")) +
  geom_density() +
  scale_x_continuous(limits = c(0, 6), breaks=seq(0, 6, by = 1)) +
  labs(title = "Bootstrap Samples: First Metastasis", x = "Months", y = "Density") +
  geom_vline(xintercept = obs_first_met, color = "blue", linetype = "solid") +
  geom_vline(xintercept = mean_val, color = "red", linetype = "solid") +
  geom_vline(xintercept = mean_val_100, color = "pink", linetype = "solid") +
  geom_vline(xintercept = ci[1], color = "red", linetype = "dashed") +  # Lower bound of CI
  geom_vline(xintercept = ci[2], color = "red", linetype = "dashed") +  # Upper bound of CI
  geom_vline(xintercept = ci_100[1], color = "pink", linetype = "dashed") +  # Lower bound of CI
  geom_vline(xintercept = ci_100[2], color = "pink", linetype = "dashed") +  # Upper bound of CI
  annotate("text", x = mean_val, y = 0, label = round_to_1_decimal(mean_val), vjust = -1) +
  annotate("text", x = ci[1], y = 0, label = round_to_1_decimal(ci[1]), vjust = -1) +
  annotate("text", x = ci[2], y = 0, label = round_to_1_decimal(ci[2]), vjust = -1) +
  annotate("text", x = obs_first_met, y = 2, label = obs_first_met, color="blue") +
  theme_classic() +
  theme(legend.position = "none")

mean_val <- mean(d$Scaled_Peak_Metastasis, na.rm = TRUE)
median_val <- median(d$Scaled_Peak_Metastasis, na.rm = TRUE)
sd_val <- sd(d$Scaled_Peak_Metastasis, na.rm = TRUE)
ci <- quantile(d$Scaled_Peak_Metastasis, c(0.125, 0.875))

mean_val_100 <- mean(d$Scaled_Peak_Metastasis[1:100], na.rm = TRUE)
median_val_100 <- median(d$Scaled_Peak_Metastasis[1:100], na.rm = TRUE)
sd_val_100 <- sd(d$Scaled_Peak_Metastasis[1:100], na.rm = TRUE)
ci <- quantile(d$Scaled_Peak_Metastasis, c(0.125, 0.875))
ci_100 <- quantile(d$Scaled_Peak_Metastasis[1:100], c(0.125, 0.875))

obs_peak_met <- 1.889248
plot_column2 <- ggplot(d, aes(x = Scaled_Peak_Metastasis, color = "Column 2")) +
  geom_density() +
  scale_x_continuous(limits = c(0, 6), breaks=seq(0, 6, by = 1)) +
  labs(title = "Bootstrap Samples: Peak Metastasis", x = "Months", y = "Density")+ 
  geom_vline(xintercept = obs_peak_met, color = "blue", linetype = "solid") +
  geom_vline(xintercept = mean_val, color = "red", linetype = "solid") +
  geom_vline(xintercept = mean_val_100, color = "pink", linetype = "solid") +
  geom_vline(xintercept = ci[1], color = "red", linetype = "dashed") +  # Lower bound of CI
  geom_vline(xintercept = ci[2], color = "red", linetype = "dashed") +  # Upper bound of CI
  geom_vline(xintercept = ci_100[1], color = "pink", linetype = "dashed") +  # Lower bound of CI
  geom_vline(xintercept = ci_100[2], color = "pink", linetype = "dashed") +  # Upper bound of CI  annotate("text", x = mean_val, y = 0, label = round_to_1_decimal(mean_val), vjust = -1) +
  annotate("text", x = ci[1], y = 0, label = round_to_1_decimal(ci[1]), vjust = -1) +
  annotate("text", x = ci[2], y = 0, label = round_to_1_decimal(ci[2]), vjust = -1) +
  annotate("text", x = obs_peak_met, y = 2, label = obs_peak_met, color="blue") +
  theme_classic() + 
  theme(legend.position = "none")

mean_val <- mean(d$Scaled_First_Reseeding, na.rm = TRUE)
median_val <- median(d$Scaled_First_Reseeding, na.rm = TRUE)
sd_val <- sd(d$Scaled_First_Reseeding, na.rm = TRUE)
ci <- quantile(d$Scaled_First_Reseeding, c(0.125, 0.875))

mean_val_100 <- mean(d$Scaled_First_Reseeding[1:100], na.rm = TRUE)
median_val_100 <- median(d$Scaled_First_Reseeding[1:100], na.rm = TRUE)
sd_val_100 <- sd(d$Scaled_First_Reseeding[1:100], na.rm = TRUE)
ci_100 <- quantile(d$Scaled_First_Reseeding[1:100], c(0.125, 0.875))

obs_first_reseeding <- 2.531932
plot_column3 <- ggplot(d, aes(x = Scaled_First_Reseeding, color = "Column 3")) +
  geom_density() +
  scale_x_continuous(limits = c(0, 6), breaks=seq(0, 6, by = 1)) +
  labs(title = "Bootstrap Samples: First Reseeding", x = "Months", y = "Density")+ 
  geom_vline(xintercept = obs_first_reseeding, color = "blue", linetype = "solid") +
  geom_vline(xintercept = mean_val, color = "red", linetype = "solid") +
  geom_vline(xintercept = mean_val_100, color = "pink", linetype = "solid") +
  geom_vline(xintercept = ci[1], color = "red", linetype = "dashed") +  # Lower bound of CI
  geom_vline(xintercept = ci[2], color = "red", linetype = "dashed") +  # Upper bound of CI
  geom_vline(xintercept = ci_100[1], color = "pink", linetype = "dashed") +  # Lower bound of CI
  geom_vline(xintercept = ci_100[2], color = "pink", linetype = "dashed") +  # Upper bound of CI
  annotate("text", x = mean_val, y = 0, label = round_to_1_decimal(mean_val), vjust = -1) +
  annotate("text", x = ci[1], y = 0, label = round_to_1_decimal(ci[1]), vjust = -1) +
  annotate("text", x = ci[2], y = 0, label = round_to_1_decimal(ci[2]), vjust = -1) +
  annotate("text", x = obs_first_reseeding, y = 2, label = obs_first_reseeding, color="blue") +
  theme_classic() + 
  theme(legend.position = "none")

# Arrange plots in a grid using gridExtra library
library(gridExtra)

# Arrange the plots in a grid
grid_plots <- grid.arrange(plot_column1, plot_column2, plot_column3, nrow = 3)

ggsave("kptracer_bootstrap_samples1000.pdf", grid_plots, width = 6, height = 4)


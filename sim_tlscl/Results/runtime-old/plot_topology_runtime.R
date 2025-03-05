setwd('/Users/gc3045/scmail_v1/sc-mail-experiments/sim_tlscl/Results/runtime')

time_to_seconds <- function(time_str) {
  minutes <- as.numeric(regmatches(time_str, regexpr("\\d+(?=m)", time_str, perl = TRUE)))
  seconds <- as.numeric(regmatches(time_str, regexpr("\\d+\\.\\d+(?=s)", time_str, perl = TRUE)))
  
  if (length(minutes) > 0) {
    total_seconds <- minutes * 60 + seconds
  } else {
    total_seconds <- seconds
  }
  
  return(total_seconds)
}

require(ggplot2)

d = read.table("topology_runtime_results.csv",header=T,sep=',')
nj_runtime = read.table("nj_simtlscl_runtime.txt", header=T, sep=",")
nj_runtime <- nj_runtime %>%
  mutate(TotalSeconds = sapply(Runtime, time_to_seconds))


head(nj_runtime)
head(d)
d$TotalSeconds <- as.numeric(d$TotalSeconds)
nj_runtime$TotalSeconds <- as.numeric(nj_runtime$TotalSeconds)

d <- rbind(d, nj_runtime)
dim(d)
#time_to_seconds("1m11.820s")

d$method = factor(d$Method,levels=c("nj", "cassgreedy","scmail","startle"),labels = c("Neighbor-\nJoining", "Cassiopeia-\nGreedy","Startle-NNI","LAML"))

df <- d %>%
  mutate(total_time = ifelse(method == "Startle-NNI", TotalSeconds[which(method == "Startle-NNI")] + TotalSeconds[which(method == "Cassiopeia-Greedy")], TotalSeconds))
head(df)
df2 <- df %>%
  mutate(total_time = ifelse(method == "LAML", total_time[which(method == "Startle-NNI")] + total_time[which(method == "LAML")], total_time))
head(df2)

scmail_df <- subset(df2, method == "LAML")
startle_df <- subset(df2, method == "Startle-NNI")
cassg_df <- subset(df2, method == "Cassiopeia-\nGreedy")
head(cassg_df)
head(startle_df)
head(scmail_df)

p1 <- ggplot(df2,aes(x=method,y=TotalSeconds/60)) +
  stat_summary() + 
  geom_boxplot() + 
  scale_y_log10() + 
  # geom_smooth() + 
  xlab("") +
  labs(x = "", y = "Runtime (m)", title = "Topology Est. Runtime\n(All model conditions)") + 
  scale_color_discrete(guide = FALSE) +
  theme_classic() + theme(text = element_text(size=15)) + #, legend.title = element_blank(),legend.position = "bottom") #+ 
  scale_x_discrete(labels = c("1" = "Neighbor-Joining", "Cassiopeia-Greedy", "2" = "LAML", "3" = "Startle-NNI"))
# ggsave("brlen_ratio_trueTopo.pdf",width=6,height=4)
ggsave("simtlscl_topology_runtime_comparison.pdf", width=6, height=4)

library(scales)
options(scipen=10000)


########################################
require('dplyr')
d2 = read.table("cassilp_runtime_results.csv",header=T,sep=',')
d2$TotalSeconds <- as.numeric(d2$TotalSeconds)
d2 <- d2[!is.na(d2$TotalSeconds), ]
dim(d2)
head(d2)

d2$method <- "Cassiopeia-ILP"  # Adding the 'method' column to d2
colnames(d2) <- c("Sample", "TotalSeconds", "method")
#d1 <- d[, c("Sample", "TotalSeconds", "method")]
d1 <- df2[, c("Sample", "TotalSeconds", "method")]
head(d1)

head(d2)
# Assuming 'd2' is your dataframe
# Remove NA values from TotalSeconds column


d1_filtered <- d1[d1$Sample %in% d2$Sample, ]
merged_df <- rbind(d1_filtered, d2)
merged_df$Method = factor(merged_df$method,levels= c("Neighbor-Joining", "Cassiopeia-Greedy","Startle-NNI","sc-MAIL", "Cassiopeia-ILP"), labels = c("Neighbor-\nJoining", "Cassiopeia-\nGreedy","Startle-NNI","LAML","Cassiopeia-\nILP"))

p2 <- ggplot(merged_df,aes(x=method,y=TotalSeconds/60)) +
  stat_summary() + 
  geom_boxplot() + 
  scale_y_log10() + 
  # geom_smooth() + 
  xlab("") +
  labs(x = "", y = "Runtime (m)", title = "Topology Est. Runtime\n(All model conditions)") + 
  scale_color_discrete(guide = FALSE) +
  theme_classic() + theme(text = element_text(size=15))


library(gridExtra)
stacked_plot <- grid.arrange(p1, p2, ncol = 1)

ggsave("simtlscl_topology_runtime_comparison.pdf", stacked_plot, width=8, height=6)




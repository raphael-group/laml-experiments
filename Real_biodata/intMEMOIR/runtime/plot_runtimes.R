setwd('/Users/gc3045/scmail_v1/sc-mail-experiments/Real_biodata/intMEMOIR/runtime')

require(ggplot2)

d = read.table("merged_runtimes.txt",header=T)
d = distinct(d)
head(d)
dim(d)

# Melt the data frame into long format for ggplot
library(reshape2)
d <- melt(d, id.vars = "Sample")
dim(d)
df2 <- read.table("runtime.txt", header=F, sep=",")
colnames(df2) <- c("Sample", "variable", "value")
head(df2)
dim(df2)

result_df <- df2 %>%
  filter(Sample %in% d$Sample)
result_df <- distinct(result_df)

df <- rbind(d, result_df)
head(df)
dim(df)


#df$variable <- factor(df$variable, levels = c("cass_greedy", "cass_hybrid", "startlenni", "scmail", "TiDeTree"))
library(scales)
options(scipen=10000)

head(df2)
df2 <- distinct(df2)
dim(df2)
dim(subset(df2, variable == "scmail"))
dim(subset(df2, variable == "cass_greedy"))
dim(subset(df2, variable == "startlenni"))

df3<- df2 %>%
  mutate(total_time = ifelse(variable == "startlenni", value[which(variable == "startlenni")] + value[which(variable == "cass_greedy")], value))
head(df3)
df4<- df3 %>%
  mutate(total_time = ifelse(variable == "scmail", total_time[which(variable == "startlenni")] + total_time[which(variable == "scmail")], total_time))
head(df4)

df4$variable <- factor(df4$variable, levels = c("cass_greedy", "cass_hybrid", "startlenni", "scmail"))
p1 <- ggplot(df4,aes(x=variable,y=value/60)) +
  stat_summary(show.legend=FALSE) + 
  geom_boxplot(show.legend=FALSE) + 
  xlab("Topology Estimation Method") +
  ylab("Runtime (m)") +
  scale_y_log10() +
  scale_x_discrete(labels = c("cass_greedy" = "Cass-Greedy", "cass_hybrid"="Cass-Hybrid", "startlenni"="Startle-NNI", "scmail"="LAML", "TiDeTree" = "TiDeTree")) + 
  labs(x = "", y = "Runtime (m)", title = "Topology Est. Runtime (intMEMOIR-full)") + 
  theme_classic() + theme(text = element_text(size=15)) 

df2<- df %>%
  mutate(total_time = ifelse(variable == "startlenni", value[which(variable == "startlenni")] + value[which(variable == "cass_greedy")], value))
head(df2)
df3<- df2 %>%
  mutate(total_time = ifelse(variable == "scmail", total_time[which(variable == "startlenni")] + total_time[which(variable == "scmail")], total_time))
head(df3)

df3$variable <- factor(df3$variable, levels = c("cass_greedy", "cass_hybrid", "startlenni", "scmail", "TiDeTree"))
df3 <- subset(df3, variable != "sc.MAIL")
p2 <- ggplot(df3,aes(x=variable,y=value/60)) +
  stat_summary(show.legend=FALSE) + 
  geom_boxplot(show.legend=FALSE) + 
  xlab("Topology Estimation Method") +
  ylab("Runtime (m)") +
  scale_y_log10() +
  scale_x_discrete(labels = c("cass_greedy" = "Cass-Greedy", "cass_hybrid"="Cass-Hybrid", "startlenni"="Startle-NNI", "scmail"="LAML", "TiDeTree" = "TiDeTree")) + 
  labs(x = "", y = "Runtime (m)", title = "Topology Est. Runtime (intMEMOIR-subset)") + 
  theme_classic() + theme(text = element_text(size=15)) 

unique(df3$Sample) # "s13c1" "s15c7" "s21c4" "s2c1" 
# "s5c12" "s5c3"  "s5c7"  "s7c3"  "s8c6"  "s9c3"
# 77, 57, 63, 67, 53, 51, 61, 53, 57, 51

library(gridExtra)
stacked_plot <- grid.arrange(p1, p2, ncol = 1)
ggsave("intmemoir_runtime_comparison.pdf", stacked_plot, width = 6, height = 5)


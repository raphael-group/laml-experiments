setwd('/Users/gc3045/sc-mail-experiments/Real_biodata/intMEMOIR/runtime')

require(ggplot2)

d = read.table("merged_runtimes.txt",header=T)

head(d)

# Melt the data frame into long format for ggplot
library(reshape2)
d <- melt(d, id.vars = "Sample")

head(d)
dim(d)

df2 <- read.table("runtime.txt", header=F, sep=",")
colnames(df2) <- c("Sample", "variable", "value")
head(df2)
dim(df2)

result_df <- df2 %>%
  filter(Sample %in% d$Sample)

df <- rbind(d, result_df)
head(df)
dim(df)
#df = merge(df, df2, by="Sample", all=FALSE)
#head(df)
#dim(df)

df <- subset(df, variable != "sc.MAIL")
df

df$variable <- factor(df$variable, levels = c("cass_greedy", "cass_hybrid", "startlenni", "scmail", "TiDeTree"))
library(scales)
options(scipen=10000)
p1 <- ggplot(df,aes(x=variable,y=value/60)) +
  stat_summary(show.legend=FALSE) + 
  geom_boxplot(show.legend=FALSE) + 
  xlab("Topology Estimation Method") +
  ylab("Runtime (m)") +
  scale_y_log10() +
  scale_x_discrete(labels = c("cass_greedy" = "Cass-Greedy", "cass_hybrid"="Cass-Hybrid", "startlenni"="Startle-NNI", "scmail"="sc-MAIL", "TiDeTree" = "TiDeTree")) + 
  labs(x = "", y = "Runtime (m)", title = "Topology Est. Runtime (intMEMOIR-subset)") + 
  theme_classic() + theme(text = element_text(size=15)) 

df2$variable <- factor(df2$variable, levels = c("cass_greedy", "cass_hybrid", "startlenni", "scmail"))
p2 <- ggplot(df2,aes(x=variable,y=value/60)) +
  stat_summary(show.legend=FALSE) + 
  geom_boxplot(show.legend=FALSE) + 
  xlab("Topology Estimation Method") +
  ylab("Runtime (m)") +
  scale_y_log10() +
  scale_x_discrete(labels = c("cass_greedy" = "Cass-Greedy", "cass_hybrid"="Cass-Hybrid", "startlenni"="Startle-NNI", "scmail"="sc-MAIL", "TiDeTree" = "TiDeTree")) + 
  labs(x = "", y = "Runtime (m)", title = "Topology Est. Runtime (intMEMOIR-full)") + 
  theme_classic() + theme(text = element_text(size=15)) 

library(gridExtra)
stacked_plot <- grid.arrange(p1, p2, ncol = 1)
ggsave("intmemoir_runtime_comparison.pdf", stacked_plot, width = 6, height = 5)


setwd('/Users/gc3045/sc-mail-experiments/Real_biodata/intMEMOIR/runtime')

require(ggplot2)

d = read.table("merged_runtimes.txt",header=T)

# Melt the data frame into long format for ggplot
library(reshape2)
df <- melt(d, id.vars = "Sample")

head(df)

ggplot(df,aes(x=variable,y=value/60,color=variable)) +
  stat_summary(show.legend=FALSE) + 
  geom_boxplot(show.legend=FALSE) + 
  xlab("Topology Estimation Method") +
  ylab("Runtime (m)") +
  theme_classic() + theme(text = element_text(size=15)) + #, legend.title = element_blank(),legend.position = "bottom") + 
  scale_x_discrete(labels = c("1" = "TiDeTree", "2" = "sc-MAIL"))
ggsave("runtime_comparison.pdf", width=6, height=4)

ggplot(df, aes(x = variable, y = value/60, color = variable)) +
  stat_summary(show.legend = FALSE) + 
  geom_boxplot(show.legend = FALSE) + 
  xlab("Topology Estimation Method") +
  ylab("Runtime (m)") +
  theme_classic() +
  theme(text = element_text(size = 15)) +
  scale_x_discrete(labels = c("TiDeTree", "sc-MAIL"))
ggsave("intmemoir_runtime_comparison.pdf", width = 6, height = 4)

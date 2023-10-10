setwd("/Users/gc3045/problin_experiments/Real_biodata/intMEMOIR/topology")

require(ggplot2)
library('stringr')
library(reshape2)

d = read.table("intMemoir_results.txt", sep=",",header=T)
length(d$Sample)

#d[d$Sample == "s5c3",]
#d[d$Sample == "s9c3",]
#head(d[order(d$NumNodes, decreasing=TRUE),], 10)

tidetree_results = read.table("all_pubtrees_scores.txt", sep=",", header=T)
samples = unique(tidetree_results$sample)
d = d[d$Sample %in% samples,]
d
length(d$Sample)


tidetree_results
tidetree_results$rf <- as.numeric(tidetree_results$rf)
#tidetree_indep = tidetree_results[tidetree_results$method == "indep",]
tidetree_pub = tidetree_results[tidetree_results$method == "pub",]

# plot RF
df <- data.frame(d$Sample, d$NumNodes, as.numeric(d$Startle_RF), as.numeric(d$CassH_RF), as.numeric(d$Problin_RF), as.numeric(tidetree_pub$rf)) #, d$NumNodes)
colnames(df) <- c("Sample", "NumNodes", "Startle-NNI", "Cassiopeia", "Problin", "TiDeTree (Pub)")
#df <- na.omit(df)
dfm <- melt(df, id.vars=c("Sample", "NumNodes"))
head(dfm)
ggplot(dfm, aes(x=variable, y=value))  + 
  geom_boxplot() +
  stat_summary() + 
  #geom_line(stat='summary') + 
  ylab("RF Error") + 
  xlab("Methods") +
  theme_classic() + 
  theme(legend.position= "none")
ggsave("intmemoir_all_rfcmp.pdf", width=8, height=5)
#ggsave("intmemoir10_rfcmp.png", width=8, height=5)

mean(df$`TiDeTree (Pub)`)
mean(df$`Cass-Hybrid`)

df <- data.frame(d$Sample, d$Startle_NLLH, d$CassH_NLLH, d$Problin_NLLH)
colnames(df) <- c("Sample", "Startle", "Cassiopeia", "Problin")
df$min <- names(df)[which.min(apply(df,MARGIN=2,min))]
df$min

df <- data.frame(d$Sample, d$Startle_WPS, d$CassH_WPS, d$Problin_WPS)
df <- na.omit(df)
colnames(df) <- c("Sample", "Startle", "Cassiopeia", "Problin")
df$min <- names(df)[which.min(apply(df,MARGIN=2,min))]
df$min


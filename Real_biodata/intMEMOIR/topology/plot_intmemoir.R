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
#samples = unique(tidetree_results$sample)
#d = d[d$Sample %in% samples,]
#d
length(d$Sample)

colnames(tidetree_results) <- c("Sample", "Method", "TideTreePub_RF")
tidetree_results$Method <- NULL
#tidetree_results$Sample <- tidetree_results$sample
#tidetree_results$TiDeTree_RF <- tidetree_results$rf
all_df <- merge(d, tidetree_results, by="Sample")
head(all_df)

# head(d)
d <- all_df[order(all_df$NumNodes), ]
df <- data.frame(d$Sample, d$NumNodes, as.numeric(d$Startle_RF), as.numeric(d$CassH_RF), as.numeric(d$Problin_RF), as.numeric(d$TideTreePub_RF)) 
colnames(df) <- c("Sample", "NumNodes", "Startle-NNI", "Cassiopeia", "Problin", "TiDeTree (Pub)")
#df <- na.omit(df)
dfm <- melt(df, id.vars=c("Sample", "NumNodes"))
head(dfm)
p1 <- ggplot(dfm, aes(x=NumNodes, y=value, color=variable))  + 
  #geom_boxplot() +
  #geom_line() +
  geom_smooth(method = "loess", se = FALSE, span = 0.3) +
  stat_summary(alpha=0.5) +
  ylab("RF Error") + 
  xlab("Number of Cells") +
  labs(color="Method", title="intMEMOIR Topology RF Comparison") + 
  theme_classic() #+ 
  #theme(legend.position = c(0.9, 0.3), legend.justification = c(1, 1)) # Adjust the position  
#ggsave("intmemoir_all_rfcmp_across_numnodes.pdf", width=8, height=5)

# compare RF error, but a second plot on the bottom comparing the WPS or LLH
df <- data.frame(d$Sample, d$NumNodes, as.numeric(d$Startle_NLLH), as.numeric(d$CassH_NLLH), as.numeric(d$Problin_NLLH)) #, as.numeric(d$TideTreePub_RF)) 
colnames(df) <- c("Sample", "NumNodes", "Startle-NNI", "Cassiopeia", "Problin") #, "TiDeTree (Pub)")
dfm <- melt(df, id.vars=c("Sample", "NumNodes"))
head(dfm)
p2 <- ggplot(dfm, aes(x=NumNodes, y=value, color=variable))  + 
  #geom_boxplot() +
  #geom_line() +
  geom_smooth(method = "loess", se = FALSE, span = 0.3) +
  stat_summary(alpha=0.5) +
  ylab("NLLH") + 
  xlab("Number of Cells") +
  labs(color="Method", title="intMEMOIR Topology NLLH Comparison") + 
  theme_classic() #+ 
  #theme(legend.position = c(0.9, 0.3), legend.justification = c(1, 1)) # Adjust the position  

df <- data.frame(d$Sample, d$NumNodes, as.numeric(d$Startle_WPS), as.numeric(d$CassH_WPS), as.numeric(d$Problin_WPS)) #, as.numeric(d$TideTreePub_RF)) 
colnames(df) <- c("Sample", "NumNodes", "Startle-NNI", "Cassiopeia", "Problin") #, "TiDeTree (Pub)")
dfm <- melt(df, id.vars=c("Sample", "NumNodes"))
head(dfm)
p3 <- ggplot(dfm, aes(x=NumNodes, y=value, color=variable))  + 
  #geom_boxplot() +
  #geom_line() +
  geom_smooth(method = "loess", se = FALSE, span = 0.3) +
  stat_summary(alpha=0.5) +
  ylab("WPS") + 
  xlab("Number of Cells") +
  labs(color="Method", title="intMEMOIR Topology WPS Comparison") + 
  theme_classic() #+ 
  #theme(legend.position = c(0.9, 0.3), legend.justification = c(1, 1)) # Adjust the position  


# Arrange plots in a grid using gridExtra library
library(gridExtra)

# Arrange the plots in a grid
grid_plots <- grid.arrange(p1, p2, p3, nrow = 3)
grid_plots

# compare topology via RF distance between the different methods
d2 = read.table("/Users/gc3045/sc-mail-experiments/Real_biodata/intMEMOIR/topology/intMemoir_cmp_topology.txt", sep=",",header=T)
head(d2)
d2 <- d2[order(d2$NumNodes), ]
df <- data.frame(d2$Sample, d2$NumNodes, as.numeric(d2$Startle_RF_Problin), as.numeric(d2$CassH_RF_Problin), as.numeric(d2$TideTreePub_RF_Problin)) 
colnames(df) <- c("Sample", "NumNodes", "Startle-NNI", "Cassiopeia", "TiDeTree (Pub)")
#df <- na.omit(df)
tail(df)
dfm <- melt(df, id.vars=c("Sample", "NumNodes"))
head(dfm)
p4 <- ggplot(dfm, aes(x=NumNodes, y=value, color=variable))  + 
  #geom_boxplot() +
  #geom_line() +
  geom_smooth(method = "loess", se = FALSE, span = 0.3) +
  stat_summary(alpha=0.5) +
  ylab("RF Distance from sc-MAIL") + 
  xlab("Number of Cells") +
  labs(color="Method") +#, title="intMEMOIR Topology RF Comparison") + 
  theme_classic() 
grid_plots <- grid.arrange(p1, p4, nrow = 2)
ggsave("/Users/gc3045/sc-mail-experiments/Real_biodata/intMEMOIR/topology/intmemoir_all_rfcmp_across_numnodes.pdf", grid_plots, width=8, height=5)






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


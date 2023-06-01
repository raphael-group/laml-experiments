require(ggplot2)


# 3724_NT_All

d_MP = read.table("out_3724_NT_All/results_MP_brlen.txt") #,header=T)
colnames(d_MP) <- c("nodeID", "nodeDepth", "brlen")
d_MLP = read.table("out_3724_NT_All/results_MLP_brlen.txt") #,header=T)
colnames(d_MLP) <- c("nodeID", "nodeDepth", "brlen")
d_ML = read.table("out_3724_NT_All/results_ML_brlen.txt") #,header=T)
colnames(d_ML) <- c("nodeID", "nodeDepth", "brlen")

d_MP$group <- "MP" #Maximum Parsimony"
height <- max(d_MP$nodeDepth)
d_MP$brlen <- d_MP$brlen / height
d_MLP$group <- "MLP" #Maximum Likelihood Parsimony"
d_ML$group <- "ML" #Maximum Likelihood"

vizAll <- rbind(d_MP, d_MLP, d_ML)
#print(colnames(vizAll))
#print(vizAll$group)

p <- ggplot(vizAll, aes(y=brlen, x=nodeDepth, group=group, col=group, fill=group)) + 
  stat_summary() + geom_line(stat="summary") +
  theme_classic() + #scale_color_manual(values=c("#CC6666")) +
  ggtitle("All Branch Lengths (KP-Tracer: 3724_NT_All)") #+
  #theme(legend)

ggsave("out_3724_NT_All/all_brlens.pdf", p, device="pdf")


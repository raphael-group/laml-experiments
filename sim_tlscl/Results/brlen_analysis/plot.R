setwd("/Users/uym2/my_gits/problin_experiments/sim_tlscl/Results/brlen_analysis")

require(ggplot2)
library(ggpubr)
require(reshape2)

d = read.table("brlen_analysis_trueTopo.txt",header=T)

dm = melt(d,id.vars = c("model","prior","treeSize","rep","nodeName","trueBrlen"))
dm$variable = factor(dm$variable,levels=c("MPNormNmus","problinNormNmus","problinBrlen"),
                     labels=c("MP normalized #mutations","ML normalized #mutations","ML branch length"))

ggplot(dm,aes(x=trueBrlen/0.095,y=value,color=variable)) + 
  stat_summary_bin(bins=200,alpha=0.5,size=0.2) + 
  #geom_line(stat="summary_bin")+ 
  geom_smooth(method="lm",formula=y~x-1) + 
  stat_cor(label.x=0.1,) +
  stat_regline_equation(formula = y~x-1,label.x =2) + 
  #facet_wrap(~variable,scale="free") + 
  geom_abline(slope = 0.095,linetype=1) + xlab("True branch length (# generations)") +
  ylab("Pseudotime")+ theme_classic() + 
  theme(legend.title = element_blank(),legend.position = "bottom")
ggsave("brlen_analysis_trueTopo.pdf",width=6,height=4)

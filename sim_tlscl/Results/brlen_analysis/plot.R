setwd("/Users/uym2/my_gits/problin_experiments/sim_tlscl/Results/brlen_analysis")

require(ggplot2)
library(ggpubr)
require(reshape2)

d = read.table("brlen_analysis_trueTopo.txt",header=T)

dm = melt(d,id.vars = c("model","prior","treeSize","rep","nodeName","trueBrlen"))
dm$variable = factor(dm$variable,levels=c("MPNormNmus","problinNormNmus","problinBrlen","wMPNormNmus"),
                     labels=c("MP normalized #mutations","ML normalized #mutations","ML branch length","wMPNormNmus"))

ggplot(dm,aes(x=trueBrlen/0.095,y=value,color=variable)) + 
  stat_summary_bin(bins=50,alpha=1,size=0.2) + 
  stat_summary_bin(bins=50,geom="line") + 
  #geom_smooth(method="loess",formula=y~x-1,se=F) + 
  #geom_smooth() + 
  stat_cor(label.x=0.1) +
  stat_regline_equation(formula = y~x-1,label.x =2) + 
  #facet_wrap(~model,scale="free",nrow = 1) + 
  geom_abline(slope = 0.095,linetype=1) + xlab("True branch length (# generations)") +
  ylab("Pseudotime")+ theme_classic() + 
  theme(legend.title = element_blank(),legend.position = c(0.7,0.9))
  #theme(legend.title = element_blank(),legend.position = "bottom")
ggsave("brlen_analysis_trueTopo.pdf",width=6,height=4)


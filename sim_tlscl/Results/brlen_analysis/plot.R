setwd("/Users/uym2/my_gits/problin_experiments/sim_tlscl/Results/brlen_analysis")

require(ggplot2)
library(ggpubr)
require(reshape2)

d = read.table("brlen_analysis_trueTopo.txt",header=T)
dm = melt(d,id.vars = c("model","prior","treeSize","rep","nodeID","d2root","trueBrlen"))
dm$model = factor(dm$model,levels=c("s0d100","s25d75","s50d50","s75d25","s100d0"),
                  labels=c("h0d100","h25d75","h50d50","h75d25","h100d0"))
dm$variable = factor(dm$variable,levels=c("trueNmus","MPNMus","dML"),
                     labels=c("true #mutations","MP #mutations","ML estimate"))

ggplot(dm,aes(x=d2root/0.095,y=value/(trueBrlen/0.095),color=variable)) +
  #geom_point() +
  stat_summary_bin(size=0.1,bins=100)+ 
  stat_summary_bin(geom="line",bins=100)+ 
  geom_hline(yintercept = 0.095) + 
  geom_smooth() + 
  facet_wrap(~model) + xlab("Distance to root (#generations)") +
  ylab("Ratio to true branch time") +
  theme_classic() + theme(legend.title = element_blank(),legend.position = c(0.8,0.2))
ggsave("brlen_ratio_trueTopo.pdf",width=6,height=4)


ggplot(dm,aes(x=trueBrlen/0.095,y=value,color=variable)) + 
  stat_summary_bin(bins=50,alpha=1,size=0.2) + 
  stat_summary_bin(bins=50,geom="line") + 
  #geom_smooth(method="loess",formula=y~x-1,se=F) + 
  #geom_smooth() + 
  stat_cor(label.x=0.1) +
  stat_regline_equation(formula = y~x-1,label.x =2) + 
  #facet_wrap(~model,scale="free",nrow = 1) + 
  geom_abline(slope = 0.095,linetype=1) + xlab("True branch time (# generations)") +
  ylab("Pseudotime")+ theme_classic() + 
  #theme(legend.title = element_blank(),legend.position = c(0.7,0.9))
  theme(legend.title = element_blank(),legend.position = "bottom")
ggsave("brlen_analysis_trueTopo.pdf",width=6,height=4)

ggplot(d,aes(x=d2root,y=MPNMus/dML)) +
  geom_point() + 
  geom_smooth(method = "lm") + 
  scale_y_log10() + 
  facet_grid(rows = vars(model),cols = vars(prior),scale="free") + 
  theme_classic() 





# older analysis
d = read.table("brlen_analysis_trueTopo_old.txt",header=T)
dm = melt(d,id.vars = c("model","prior","treeSize","rep","nodeName","trueBrlen"))
dm$variable = factor(dm$variable,levels=c("MPNormNmus","problinNormNmus","problinBrlen","wMPNormNmus"),
                     labels=c("MP normalized #mutations","ML normalized #mutations","ML branch length","wMPNormNmus"))

ggplot(dm[dm$variable != "wMPNormNmus",],aes(x=trueBrlen/0.095,y=value,color=variable)) + 
  stat_summary_bin(bins=50,alpha=1,size=0.2) + 
  stat_summary_bin(bins=50,geom="line") + 
  #geom_smooth(method="loess",formula=y~x-1,se=F) + 
  #geom_smooth() + 
  stat_cor(label.x=0.1) +
  stat_regline_equation(formula = y~x-1,label.x =2) + 
  #facet_wrap(~model,scale="free",nrow = 1) + 
  geom_abline(slope = 0.095,linetype=1) + xlab("True branch length (# generations)") +
  ylab("Pseudotime")+ theme_classic() + 
  #theme(legend.title = element_blank(),legend.position = c(0.7,0.9))
  theme(legend.title = element_blank(),legend.position = "bottom")
ggsave("brlen_analysis_trueTopo.pdf",width=6,height=4)


setwd("/Users/uym2/Documents/Explore/kptracer_brlen_analysis")

require(ggplot2)

d = read.table("brlen_vs_expression.txt",header=T)

ggplot(d,aes(x=dT_ML,y=dT_MP/nSite)) + 
  geom_point(size=1,alpha=0.5) + 
  stat_smooth(method = "loess", formula = y ~ x-1,se=F) + 
  xlab("ML branch length") + ylab("MP #mutations per site") + 
  theme_classic() + facet_wrap(~sample,scale="free")
ggsave("dT_ML_vs_dT_MP.pdf",width=4,height=4)

require(reshape2)
dE = read.table("brlen_vs_expr_mutualInfo.txt",header=T)

dE_melt = melt(dE,id.vars = c("sample","dE_type"))
dE_melt$variable = factor(dE_melt$variable,labels=c("Topology distance","MP distance","ML distance"))

ggplot(dE_melt,aes(x=dE_type,y=value,group=variable,fill=variable)) + 
  geom_col(position = "dodge",color="black") + 
  facet_wrap(~sample,scale="free") + 
  xlab("Expression distance") +
  ylab("Mutual information") + 
  theme_classic() + theme(legend.position = "bottom",legend.title = element_blank())
ggsave("dT_vs_dE_mutualInfo.pdf",width=4,height=4)

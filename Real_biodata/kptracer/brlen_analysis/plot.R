setwd("/Users/gc3045/scmail_v1/sc-mail-experiments/Real_biodata/kptracer/brlen_analysis")

d = read.table("MP_ML_d2root.txt",header=T)

ggplot(d[d$sample %in% c("3432_NT_T1","3435_NT_T4","3520_NT_T1","3703_NT_T1","3703_NT_T2","3703_NT_T3"),],
       aes(x=d2root,y=dMP/nsites/dML)) + geom_point() + geom_smooth(method="lm") + 
        scale_y_log10() + 
        xlab("Distance to root") + ylab("log(MP/LAML)") + 
        #xlab("Distance to root (ML estimate)") + ylab("dMP/dML") + 
        facet_wrap(~sample,scale="free") + theme_classic()
ggsave("MP_ML_d2root.pdf",width=4,height=4)


require(ggplot2)

d = read.table("brlen_vs_expression.txt",header=T)

ggplot(d,aes(x=dT_ML,y=dT_MP/nSite)) + 
  geom_point(size=1,alpha=0.5) + 
  stat_smooth(method = "loess", formula = y ~ x-1,se=F) + 
  xlab("ML branch length") + ylab("MP normalized #mutations") + 
  theme_classic() + facet_wrap(~sample,scale="free")
ggsave("dT_ML_vs_dT_MP.pdf",width=4,height=4)

require(reshape2)
dE = read.table("brlen_vs_expr_mutualInfo.txt",header=T)

dE_melt = melt(dE,id.vars = c("sample","dE_type"))
dE_melt$variable = factor(dE_melt$variable,labels=c("Topology distance","MP distance","LAML"))

ggplot(dE_melt,aes(x=dE_type,y=value,group=variable,fill=variable)) + 
  geom_col(position = "dodge",color="black") + 
  facet_wrap(~sample,scale="free",nrow=2) + 
  xlab("Expression distance") +
  ylab("Mutual information") + 
  theme_classic() + theme(legend.position = "bottom",legend.title = element_blank())
ggsave("dT_vs_dE_mutualInfo.pdf",width=4,height=4)


ggplot(dE_melt[dE_melt$sample == "3432_NT_T1",],aes(x=dE_type,y=value,group=variable,fill=variable)) + 
  geom_col(position = "dodge",color="black") + 
  #facet_wrap(~sample,scale="free",nrow=2) + 
  scale_x_discrete(labels = c("pca" = "PCA", "scVI" = "scVI", "umap" = "UMAP")) + 
  xlab("Expression distance") +
  ylab("Mutual information") + 
  theme_classic() + theme(legend.position = "bottom",legend.title = element_blank())
ggsave("dT_vs_dE_mutualInfo_3432.pdf",width=4,height=4)

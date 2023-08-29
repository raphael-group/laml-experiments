setwd("/Users/uym2/my_gits/problin_experiments/sim_tlscl/Results/imputation")
require(ggplot2)

d = read.table("problin_impute_missing.txt",header=T)
d$model = factor(d$model,levels=c("s0d100","s25d75","s50d50","s75d25","s100d0"),labels=c("h0d100","h25d75","h50d50","h75d25","h100d0"))
d$type = factor(d$type,levels=c("trueTopoTrueParams","trueTopo","estTopo"),labels = c("True tree","True topology","Estimated topology"))

ggplot(d,aes(x=model,y=accuracy,fill=type)) + geom_boxplot() + 
  stat_summary(position = position_dodge2(width = 0.75)) + ylab("Accuracy") + 
  theme_classic() + theme(legend.title = element_blank(), legend.position = "bottom",axis.title.x = element_blank())
ggsave("missing_impute.pdf",width=4,height = 4)

round(mean(d[d$model=="s0d100",]$accuracy),2); round(sd(d[d$model=="s0d100",]$accuracy),3)
round(mean(d[d$model=="s25d75",]$accuracy),2); round(sd(d[d$model=="s25d75",]$accuracy),3)
round(mean(d[d$model=="s50d50",]$accuracy),2); round(sd(d[d$model=="s50d50",]$accuracy),3)
round(mean(d[d$model=="s75d25",]$accuracy),2); round(sd(d[d$model=="s75d25",]$accuracy),3)
round(mean(d[d$model=="s100d0",]$accuracy),2); round(sd(d[d$model=="s100d0",]$accuracy),3)

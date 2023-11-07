setwd("~/problin/migration_story")
library(ggplot2)
d = read.table("epoch_stats.csv", sep=",", header=T)

scale_factor = 6 / 2.47

ggplot(d, aes(x=epoch, y=branch_length *scale_factor, fill=epoch)) +
  geom_violin(trim=FALSE)

#library(plyr)
#mu <- ddply(d, "epoch", summarise, grp.mean=mean(branch_length))

#ggplot(d, aes(x=branch_length * scale_factor, color=epoch)) +
#  geom_histogram(fill="white", position="dodge")+
#  theme(legend.position="top") +
#  geom_vline(data=mu, aes(xintercept=grp.mean, color=epoch),
#             linetype="dashed")
d = read.table("epoch_leaf_stats.csv", sep=",", header=T)
ggplot(d, aes(x=epoch, y=branch_length *scale_factor, fill=epoch)) +
  geom_violin(trim=FALSE)

d = read.table("epoch_all_stats.csv", sep=",", header=T)

ggplot(d, aes(x=epoch, y=branch_length * scale_factor, fill=epoch)) +
  geom_boxplot() + #scale_fill_manual(values=c("#0F6515", "#FDA227", "#056DAE")) +
  stat_summary() + 
  #geom_line(stat='summary') + 
  ylab("Scaled Branch Length (months)") + 
  xlab("Epochs") +
  theme_classic() + 
  theme(legend.position= "none")
ggsave("epoch_branches.png", width=4, height = 4)

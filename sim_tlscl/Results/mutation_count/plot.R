setwd("/Users/uym2/my_gits/problin_experiments/sim_tlscl/Results/mutation_count")

require(ggplot2)

d = read.table("count_mutations.txt",header=T)

d$method = factor(d$method,levels = c("Cass-greedy","NJ","Startle","Problin"),labels=c("Cass-greedy","Neighbor-Joining","Startle-NNI","Problin"))

ggplot(d,aes(x=trueNmus,y=estNmus,color=method)) + 
  stat_summary(size=0.2,alpha=1) + 
  geom_line(stat="summary") + 
  #geom_smooth(size=1,method="lm",se = F) + 
  geom_abline(linetype=1) +
  xlab("True number of mutations") + ylab("Estimated number of mutations") + 
  theme_classic() + theme(legend.title = element_blank(), legend.position = "bottom")
ggsave("count_mutations.pdf",width=4,height=4)

ggplot(d,aes(x=method,y=estNmus-trueNmus,fill=method)) + geom_boxplot(outlier.size = 0.2) + 
  stat_summary() + ylab("estimated - true") + 
  geom_hline(yintercept = 0) + theme_classic() + 
  theme(legend.position="None",axis.title.x = element_blank())
ggsave("count_mutations_boxplot.pdf",width=4,height=4)

ggplot(d,aes(x=collision,y=abs(estNmus-trueNmus),color=method)) + 
  stat_summary_bin(binwidth = 0.1) +
  geom_line(stat="summary_bin",binwidth=0.1) + 
  geom_smooth() + 
  xlab("Collision probability") + ylab("Absolute error") +
  theme_classic() + theme(legend.title = element_blank(), legend.position = "None") +
  scale_x_continuous(breaks = c(0.1,0.3,0.5,0.7,0.9))
ggsave("collision_vs_error.pdf",width=4,height=4)

#########Correlation with collision
with(d[d$method == "Startle-NNI",],cor(collision,abs(trueNmus-estNmus)))
with(d[d$method == "Problin",],cor(collision,abs(trueNmus-estNmus)))
with(d[d$method == "Cass-greedy",],cor(collision,abs(trueNmus-estNmus)))
with(d[d$method == "Neighbor-Joining",],cor(collision,abs(trueNmus-estNmus)))

######### Mean absolute error
with(d[d$method == "Cass-greedy",],mean(abs(trueNmus-estNmus)))
with(d[d$method == "Startle-NNI",],mean(abs(trueNmus-estNmus)))
with(d[d$method == "Problin",],mean(abs(trueNmus-estNmus)))
with(d[d$method == "Neighbor-Joining",],mean(abs(trueNmus-estNmus)))

######### Root mean square error
with(d[d$method == "Cass-greedy",],sqrt(mean((trueNmus-estNmus)**2)))
with(d[d$method == "Startle-NNI",],sqrt(mean((trueNmus-estNmus)**2)))
with(d[d$method == "Problin",],sqrt(mean((trueNmus-estNmus)**2)))
with(d[d$method == "Neighbor-Joining",],sqrt(mean((trueNmus-estNmus)**2)))

######### Bias
with(d[d$method == "Cass-greedy",],mean(estNmus-trueNmus))
with(d[d$method == "Startle-NNI",],mean(estNmus-trueNmus))
with(d[d$method == "Problin",],mean(estNmus-trueNmus))
with(d[d$method == "Neighbor-Joining",],mean(estNmus-trueNmus))

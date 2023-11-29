setwd('/Users/gc3045/sc-mail-experiments/sim_tlscl/Results/runtime')

require(ggplot2)

d = read.table("topology_runtime_results.csv",header=T,sep=',')
d$TotalSeconds <- as.numeric(d$TotalSeconds)

d$method = factor(d$Method,levels=c("cassgreedy","scmail","startle"),labels = c("Cassiopeia-Greedy","sc-MAIL","Startle-NNI"))


head(d)

ggplot(d,aes(x=method,y=TotalSeconds/60,color=method)) +
  stat_summary() + 
  geom_boxplot() + 
  # geom_smooth() + 
  xlab("Topology Estimation Method") +
  ylab("Runtime (m)") +
  scale_color_discrete(guide = FALSE) +
  theme_classic() + theme(text = element_text(size=15)) #, legend.title = element_blank(),legend.position = "bottom") #+ 
  #scale_x_discrete(labels = c("1" = "Cassiopeia-Greedy", "2" = "sc-MAIL", "3" = "Startle-NNI"))
# ggsave("brlen_ratio_trueTopo.pdf",width=6,height=4)
ggsave("simtlscl_topology_runtime_comparison.pdf", width=6, height=4)


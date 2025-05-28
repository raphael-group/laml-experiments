setwd("/Users/gc3045/git/laml-experiments/sim_tlscl/Results/mutation_count")

require(ggplot2)

d = read.table("count_mutations.txt",header=T)

d$method = factor(d$method,levels = c("Cass-greedy","NJ","Startle","Problin"),labels=c("Cass-greedy","Neighbor-Joining","Startle-NNI","LAML"))

okabe_ito <- c(
  "#E69F00", "#56B4E9", "#009E73",
  "black", "#0072B2", "#D55E00", "#CC79A7"
)

ggplot(d, aes(x = trueNmus, y = estNmus, colour = method)) +
  stat_summary(size = 0.2, alpha = 1) +
  geom_line(stat = "summary") +
  geom_abline(linetype = 1) +
  xlab("True number of mutations") +
  ylab("Estimated number of mutations") +
  scale_colour_manual(values = okabe_ito[seq_along(unique(d$method))]) +
  guides(colour = guide_legend(nrow = 2, byrow = TRUE)) +
  theme_classic() +
  theme(
    legend.title    = element_blank(),
    legend.position = c(0.60, 0.22)
  )
# ggsave("count_mutations.pdf",width=5,height=5)
ggsave("count_mutations.cbf.pdf",width=5,height=5)

ggplot(d,aes(x=method,y=estNmus-trueNmus,fill=method)) + geom_boxplot(outlier.size = 0.2) + 
  stat_summary() + ylab("estimated - true") + 
  geom_hline(yintercept = 0) + theme_classic() + 
  theme(legend.position="None",axis.title.x = element_blank())
#ggsave("count_mutations_boxplot.pdf",width=4,height=4)

ggplot(d,
       aes(x = collision,
           y = abs(estNmus - trueNmus),
           colour = method)) +
  stat_summary_bin(binwidth = 0.1, size = 0.4) +              # binned means
  geom_line(stat = "summary_bin", binwidth = 0.1) +           # connect them
  geom_smooth(se = FALSE, size = 0.6) +                       # trend lines
  scale_colour_manual(values = okabe_ito[seq_along(unique(d$method))]) +
  scale_x_continuous(breaks = c(0.1, 0.3, 0.5, 0.7, 0.9)) +
  xlab("Collision probability") +
  ylab("Absolute error") +
  theme_classic() +
  theme(
    legend.title    = element_blank(),
    legend.position = "none"         # keep legend suppressed
  )
#ggsave("collision_vs_error.pdf",width=4,height=4)
ggsave("collision_vs_error.cbf.pdf",width=4,height=4)

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

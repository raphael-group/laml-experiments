setwd("/Users/gillianchu/raphael/repos/problin_scp/figure4")

require(ggplot2)
d = read.csv("exp3/experiment_time.proc.csv",header=T)
ggplot(d[d$Datatype == "nomissing",],aes(x=NumCells,Time)) + 
  stat_summary() + geom_smooth(method="lm") + theme_classic() + 
  theme() + ylab("Run time (minutes)") + xlab("# Cells")
ggsave("varyncells_time_wem_gs.pdf", width=4, height=4)

d = read.csv("exp3/experiment_numem.csv",header=T)
ggplot(d[d$Datatype == "nomissing",],aes(x=NumCells,NumEmIter)) + 
  stat_summary() + geom_line(stat="summary", color="blue") + theme_classic() + 
  theme() + ylab("# EM Iters") + xlab("# Cells")
ggsave("varyncells_nllh_wem.pdf", width=4, height=4)

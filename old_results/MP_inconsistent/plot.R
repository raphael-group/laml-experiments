setwd("/Users/uym2/my_gits/problin_experiments/MP_inconsistent")

require(ggplot2)

d = read.table("results.txt",header=T)
d$method = factor(d$method,levels=c("MP","ML_triplets","ML_fels"),
                  labels=c("Maximum Parsimony","Maximum Likelihood","ML_Fels"))

ggplot(d[d$method == "Maximum Parsimony",],aes(x=k,y=percent_correct*100)) + geom_line(color="red") + geom_point(color="red") +
  scale_x_log10() + theme_classic() + xlab("Number of sites") + ylab("Percent correct")
ggsave("MP_inconsistent.pdf",width=4,height=4)

ggplot(d[d$method != "ML_Fels",],aes(x=k,y=percent_correct*100,color=method)) + geom_line() + geom_point() +
  scale_x_log10() + theme_classic() + 
  theme(legend.title=element_blank(),legend.position = "bottom") + 
  xlab("Number of sites") + ylab("Percent correct")

ggsave("ML_consistent.pdf",width=4,height=4)

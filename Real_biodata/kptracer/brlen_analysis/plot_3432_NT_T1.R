#setwd("/Users/uym2/my_gits/problin_experiments/Real_biodata/kptracer/brlen_analysis")
setwd("/Users/gc3045/scmail_v1/sc-mail-experiments/Real_biodata/kptracer/brlen_analysis")
require(ggplot2)

d = read.table("3432_NT_T1_brlen.txt",header=T)

ggplot(d[d$d2root<1.5,],aes(x=d2root,y=dMP/29/dML)) + 
  geom_point() + geom_smooth(method="lm") + 
  scale_y_log10() + xlab("Distance to root") + ylab("log(MP/LAML)") + 
  #scale_y_log10() + xlab("distance to root (ML estimate)") + ylab("dMP/dML ratio") + 
  theme_classic()
ggsave("MP_ML_d2root_3432.pdf",width=4,height=4)

ggplot(d,aes(x=dML)) + geom_histogram(color="black")

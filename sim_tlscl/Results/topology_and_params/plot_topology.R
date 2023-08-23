# RF DISTANCE PLOT
library(extrafont)
font_import() 
loadfonts(device="pdf")
setwd("/Users/gc3045/problin_experiments/sim_tlscl/fig3")
library("stringr")                       # Load stringr package
library("ggplot2")
#install.packages("reshape")
library("reshape")
rfdist = read.table("collected_rf_stats.txt", sep=",",header=T)
head(rfdist)
rfdist['modelcondition'] <- str_split_fixed(rfdist$ModelCond, "p", 2)
#rfdist['modelcond'] <- str_split_fixed(rfdist['modelcondition'][,1], "p", 2)
colnames(rfdist)
#colnames(d_ultra) = c('modelcond', 'jobidx', 'ultra', 'noconstraint', 'modelcondition', 'prior_idx')
head(rfdist)

head(df)

rfdist['sProp'] <- ifelse(rfdist$modelcondition[,1] == "s0d100", 0,
                               ifelse(rfdist$modelcondition[,1] == "s25d75", 0.25, 
                                      ifelse(rfdist$modelcondition[,1] == "s50d50", 0.50, 
                                             ifelse(rfdist$modelcondition[,1] == "s75d25", 0.75, 
                                                    ifelse(rfdist$modelcondition[,1] == "s100d0", 1.00, 
                                                           NA)))))
rfdist$sProp
xx = unique(rfdist$sProp*100)
labels = unique(rfdist$modelcondition[,1])
labels
labels = c("h0d100", "h100d0", "h25d75", "h50d50", "h75d25")
rfdist=rfdist[,c(1,2,3,5,4,6,7)]
colnames(rfdist) = c('tcount', 'ModelCond', 'Cass-greedy', 'Startle-NNI', 'ProbLin', 'modelcondition', 'sProp')
df = melt(rfdist, id=c("tcount", "sProp", "modelcondition", "ModelCond"))

ggplot(df, aes(x=sProp/4, y=value, color=variable)) +
  stat_summary(size=0.2) + 
  geom_line(stat='summary') + 
  ylab("RF Error") + 
  xlab("Heritable Missing (%)") +
  annotate("text", x=xx/400 + 0.004, y=0.0, label=labels, size=8/.pt) + 
  theme_classic() + 
  theme(legend.position = c(0.25,0.25)) +
  theme(legend.title = element_blank()) +
  coord_cartesian(xlim=c(0,0.254), clip="off") +
  annotate("text", x=-0.026, y=0.7, label="(A)", size=7, family="Times New Roman")

ggsave("sim_tlscl_rfdist.pdf", width=4, height=4)


mean(rfdist$`Startle-NNI`[rfdist$modelcondition == 's0d100']) # 0.440225
mean(rfdist$`Startle-NNI`[rfdist$modelcondition == 's100d0']) # 0.3370662


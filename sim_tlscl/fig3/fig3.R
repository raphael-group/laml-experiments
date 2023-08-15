setwd("/Users/gc3045/problin_experiments/sim_tlscl/fig3")

require(ggplot2)
library('stringr')
library(reshape2)
library(ggtext)

d = read.table("problintopo_estparams_other_vs_true.txt", sep=",",header=T)
d['modelcondition'] <- str_c(d$true_nu, 'd', d$true_phi)

true_params = read.table("true_params.txt", sep=" ", header=F)
colnames(true_params) = c('modelcondition', 'true_phi_value', 'true_nu_value')

d = merge(d, true_params)
head(d)

write.csv(d, "problintopo_estparams_merged.txt")

d['true_LLH'] <- -d['true_llh']
d['startle_LLH'] <- -d['startle_NLLH']
d['cassg_LLH'] <- -d['cassg_NLLH']
d['truetopo_LLH'] <- -d['truetopo_NLLH']
d['problin_LLH'] <- -d['problin_NLLH']

df1 <- data.frame(d$modelcondition, d$cassg_phi, d$startle_phi, d$problin_phi, d$true_phi_value, d$rep)
colnames(df1) <- c("modelcondition", "Cassiopeia-\nGreedy","Startle", "Problin", "true","rep")
df1 <- melt(df1, c("modelcondition","rep"))
colnames(df1) <- c("modelcondition","rep", "Method", "phi")

df2 <- data.frame(d$modelcondition, d$cassg_nu, d$startle_nu, d$problin_nu, d$true_nu_value,d$rep)
colnames(df2) <- c("modelcondition", "Cassiopeia-\nGreedy", "Startle", "Problin", "true","rep")
df2 <- melt(df2, c("modelcondition","rep"))
colnames(df2) <- c("modelcondition","rep", "Method", "nu")

df1$nu = as.numeric(df2$nu)
df1$phi = as.numeric(df1$phi)

ggplot(df1[df1$Method != "true",], aes(x=phi, y=nu, color=Method,group=Method,shape=modelcondition, label="0.45")) + 
  geom_point(alpha=0.5,size=1) +
  # geom_text(x=0.25, y = 0, label="s0d100") + 
  scale_shape_manual(values = c(0, 2, 6, 9, 10)) +
  geom_point(data=df1[df1$Method == "true",],aes(x=phi,y=nu,group=Method,shape=modelcondition),color="black",size=3.5, fill="black") +
  xlab("Dropout Missing Rate") + 
  ylab("Heritable Missing Rate") +
  theme_classic() +
  theme(legend.position = c(0.88,0.7)) +
  theme(legend.title = element_blank()) 

xx = df1[df1$Method == "true",]
x_s = c(0.42, 0.045, 0.35, 0.235, 0.15) # unique(xx$phi)
y_s = c(0.015, 0.25, 0.08, 0.144, 0.2) # unique(xx$nu)
#labels = c("0.0056\n**0.0049**\n0.0052", "0.0199\n0.0162\n**0.0158**", "0.0326\n0.0217\n**0.0181**, '0.0617\n0.0385\n**0.026**', '0.0407\n0.0431\n**0.0160**')
labels = c('0.0407\n0.0431\n**0.0160**',
           "0.0056\n**0.0049**\n0.0052",
           '0.0617\n0.0385\n**0.0268**',
           "0.0326\n0.0217\n**0.0181**",
           "0.0199\n0.0162\n**0.0158**"
)
labels_cass = c('0.041', '0.006', '0.062', '0.033', '0.020')
labels_startle = c('0.043', '0.005', '0.039', '0.022', '0.016')
labels_problin = c('0.016', '0.005', '0.027', '0.018', '0.016')
#labels=c("a", "b", "c", "d", "e")
ggplot(df1[df1$Method != "true",], aes(x=nu, y=phi, color=Method,group=Method,shape=modelcondition, label="0.45")) + 
  geom_point(alpha=0.5,size=1) +
  # geom_text(x=0.25, y = 0, label="s0d100") + 
  scale_shape_manual(values = c(0, 2, 6, 9, 10)) +
  #annotate("text", x=x_s, y=y_s, label=labels, size=8/.pt) + 
  
  annotate("text", x=x_s + 0.005, y=y_s + 0.01, label=labels_cass, size=8/.pt) +
  #annotate("pointrange", x=x_s - 0.021, y=y_s + 0.01, ymin=0,ymax=0, color="pink", size=0.25) +
  # c(0, 2, 6, 9, 10)
  annotate("pointrange", x=0.420 - 0.021, y=0.015 + 0.01, ymin=0,ymax=0, color="pink", size=0.25, shape=10) +
  annotate("pointrange", x=0.350 - 0.021, y=0.080 + 0.01, ymin=0,ymax=0, color="pink", size=0.25, shape=10) +
  annotate("pointrange", x=0.235 - 0.021, y=0.144 + 0.01, ymin=0,ymax=0, color="pink", size=0.25, shape=10) +
  annotate("pointrange", x=0.150 - 0.021, y=0.200 + 0.01, ymin=0,ymax=0, color="pink", size=0.25, shape=10) +
  annotate("pointrange", x=0.045 - 0.021, y=0.250 + 0.01, ymin=0,ymax=0, color="pink", size=0.25, shape=10) +
  
  annotate("text", x=x_s + 0.005, y=y_s, label=labels_startle, size=8/.pt) +
  #annotate("pointrange", x=x_s - 0.021, y=y_s, ymin=0,ymax=0, color="lightgreen", size=0.25) +
  annotate("pointrange", x=0.420 - 0.021, y=0.015, ymin=0,ymax=0, color="lightgreen", size=0.25) +
  annotate("pointrange", x=0.045 - 0.021, y=0.250, ymin=0,ymax=0, color="lightgreen", size=0.25) +
  annotate("pointrange", x=0.350 - 0.021, y=0.080, ymin=0,ymax=0, color="lightgreen", size=0.25) +
  annotate("pointrange", x=0.235 - 0.021, y=0.144, ymin=0,ymax=0, color="lightgreen", size=0.25) +
  annotate("pointrange", x=0.150 - 0.021, y=0.200, ymin=0,ymax=0, color="lightgreen", size=0.25) +
  
  annotate("text", x=x_s + 0.005, y=y_s - 0.01, label=labels_problin, size=8/.pt, fontface=2) +
  #annotate("pointrange", x=x_s - 0.021, y=y_s - 0.01, ymin=0,ymax=0, color="lightblue", size=0.25) +
  annotate("pointrange", x=0.420 - 0.021, y=0.015 - 0.01, ymin=0,ymax=0, color="lightblue", size=0.25) +
  annotate("pointrange", x=0.045 - 0.021, y=0.250 - 0.01, ymin=0,ymax=0, color="lightblue", size=0.25) +
  annotate("pointrange", x=0.350 - 0.021, y=0.080 - 0.01, ymin=0,ymax=0, color="lightblue", size=0.25) +
  annotate("pointrange", x=0.235 - 0.021, y=0.144 - 0.01, ymin=0,ymax=0, color="lightblue", size=0.25) +
  annotate("pointrange", x=0.150 - 0.021, y=0.200 - 0.01, ymin=0,ymax=0, color="lightblue", size=0.25) +
  
  geom_point(data=df1[df1$Method == "true",],aes(x=nu,y=phi,group=Method,shape=modelcondition),color="black",size=3.5, fill="black") +
  xlab("Heritable Missing Rate") + 
  ylab("Dropout Missing Rate") +
  theme_classic() +
  guides(shape=guide_legend(nrow=3,order=1), color="none") +
  
  annotate("pointrange", x=0.31, y=0.2, ymin=0, ymax=0, color="pink", size=0.25) +
  annotate("pointrange", x=0.31, y=0.18, ymin=0, ymax=0, color="lightgreen", size=0.25) +
  annotate("pointrange", x=0.31, y=0.16, ymin=0, ymax=0, color="lightblue", size=0.25) +
  annotate("text", x=0.4, y=0.2, ymin=0, ymax=0, label="Cassiopeia-Greedy", size=8/.pt, fontface=1) +
  annotate("text", x=0.37, y=0.18, ymin=0, ymax=0, label="Startle-NNI", size=8/.pt, fontface=1) +
  annotate("text", x=0.36, y=0.16, ymin=0, ymax=0, label="ProbLin", size=8/.pt, fontface=1) +
  
  #guides(shape=guide_legend(nrow=3,order=1), color=guide_legend(nrow=3, order=2, label.hjust=1)) +
  #theme(legend.position = 'right') +
  #theme(legend.position="None") + 
  theme(legend.position = c(0.75, 0.85), legend.direction="vertical")  +
  #theme(legend.position=c(0.2, 0.4), legend.direction = "horizontal") + #c(0.88,0.7)) +
  theme(legend.title = element_blank()) +
  coord_cartesian(xlim=c(0,0.45), clip="off") +
  annotate("text", x=-0.05, y=0.28, label="(B)", clip="off", size=5)
  #guides(color = guide_legend(nrow = 2))

ggsave("sim_tlscl_estparams.pdf", width=4, height=4)

# RF DISTANCE PLOT

d_ultra = read.table("ultra_toposearch_result_comparison.txt", sep=",",header=T)
tail(d_ultra)
d_ultra['modelcondition'] <- str_split_fixed(d_ultra$modelcond, "p", 2)
colnames(d_ultra)
#colnames(d_ultra) = c('modelcond', 'jobidx', 'ultra', 'noconstraint', 'modelcondition', 'prior_idx')
head(d_ultra)

d_ultra_merged = merge(d_ultra, true_params)
tail(d_ultra_merged)

d$startle_LLH <- as.numeric(d$startle_LLH)
d$truetopo_LLH <- as.numeric(d$truetopo_LLH)
d[complete.cases(d), ]
df <- data.frame((100-d$true_phi)/100, d$cassg_rf, d$startle_rf, d$problin_rf)
#df <- data.frame((100-d$true_phi)/100, d$cassg_rf, d$startle_rf, d$problin_rf, d_ultra_merged$NoConstraint)
colnames(df) <- c("sProp", "Cassiopeia-Greedy", "Startle-NNI", "Problin")

#colnames(df) <- c("sProp", "Cassiopeia-Greedy", "Startle", "Problin", "Problin (No Ultrametric)")
df <- melt(df, "sProp")
colnames(df) <- c("sProp", "Method", "value")
head(df)

df['modelcondition'] <- ifelse(df$sProp == 0, "s0d100", 
                               ifelse(df$sProp == 0.25, "s25d75",
                                      ifelse(df$sProp == 0.50, "s50d50",
                                             ifelse(df$sProp == 0.75, "s75d25",
                                                    ifelse(df$sProp == 1.00, "s100d0",
                                                           NA)))))
df$modelcondition
xx = unique(df$sProp*100)
labels = unique(df$modelcondition)
#ggplot(df, aes(x=sProp*100, y=value, color=Method))  + stat_summary(size=0.2) + 
#  geom_line(stat='summary') + 
#  ylab("RF Error") + 
#  xlab("Heritable Missing (%)") +
#  annotate("text", x=xx, y=0.0, label=labels, size=8/.pt) + 
#  theme_classic() + 
#  theme(legend.position = c(0.25,0.25)) +
#  theme(legend.title = element_blank()) +
#  coord_cartesian(xlim=c(0,100), clip="off") +
#  annotate("text", x=-11, y=0.7, label="(A)", size=5)
#theme(legend.position= "none")
# theme(legend.position = "bottom", legend.title = element_blank())

ggplot(df, aes(x=sProp/4, y=value, color=Method))  + stat_summary(size=0.2) + 
  geom_line(stat='summary') + 
  ylab("RF Error") + 
  xlab("Heritable Missing (%)") +
  annotate("text", x=xx/400 + 0.004, y=0.0, label=labels, size=8/.pt) + 
  theme_classic() + 
  theme(legend.position = c(0.25,0.25)) +
  theme(legend.title = element_blank()) +
  coord_cartesian(xlim=c(0,0.254), clip="off") +
  annotate("text", x=-11, y=0.7, label="(A)", size=5)


ggsave("sim_tlscl_rfdist.pdf", width=4, height=4)
# as dropout decreases, so does startle rf distance from true tree


mean(df[df$Method == 'Problin' & df$modelcondition == 's0d100',]$value)
mean(df[df$Method == 'Problin' & df$modelcondition == 's100d0',]$value)

mean(df[df$Method == 'Startle-NNI' & df$modelcondition == 's0d100',]$value)
mean(df[df$Method == 'Startle-NNI' & df$modelcondition == 's100d0',]$value)







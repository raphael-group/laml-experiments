setwd("/Users/gc3045/problin_experiments/sim_tlscl/Results/topology_and_params")
library(extrafont)
font_import() 
loadfonts(device="pdf")


require(ggplot2)
library('stringr')
library(reshape2)
library(ggtext)

d = read.table("problintopo_estmissingparams.txt", sep=",",header=T)
d['modelcondition'] <- str_c(d$true_nu, 'd', d$true_phi)

true_params = read.table("true_params.txt", sep=" ", header=F)
colnames(true_params) = c('modelcondition', 'true_phi_value', 'true_nu_value')

d = merge(d, true_params)
head(d)

write.csv(d, "problintopo_estmissingparams_merged.txt")

df1 <- data.frame(d$modelcondition, d$cassg_phi, d$nj_phi, d$startle_phi, d$problin_phi, d$true_phi_value, d$rep)
colnames(df1) <- c("modelcondition", "Cassiopeia-\nGreedy", "Neighbor-Joining", "Startle-NNI", "Problin", "true","rep")
df1 <- melt(df1, c("modelcondition","rep"))
colnames(df1) <- c("modelcondition","rep", "Method", "phi")

df2 <- data.frame(d$modelcondition, d$cassg_nu, d$nj_nu, d$startle_nu, d$problin_nu, d$true_nu_value,d$rep)
colnames(df2) <- c("modelcondition", "Cassiopeia-\nGreedy", "Neighbor-Joining", "Startle-NNI", "Problin", "true","rep")
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
labels = c('0.0407\n0.0431\n**0.0160**',
           "0.0056\n**0.0049**\n0.0052",
           '0.0617\n0.0385\n**0.0268**',
           "0.0326\n0.0217\n**0.0181**",
           "0.0199\n0.0162\n**0.0158**"
)
labels_cass = c('0.042', '0.006', '0.053', '0.035', '0.021')
labels_startle = c('0.051', '0.005', '0.040', '0.021', '0.016')
labels_problin = c('0.016', '0.005', '0.027', '0.018', '0.016')
labels_nj = c('0.047', '0.005', '0.056', '0.025', '0.016')
#labels=c("a", "b", "c", "d", "e")
# (a = s100d0, b = s0d100, c = s75d25, d = s50d50, e = s25d75)

df1[df1 == "s0d100"] <- "h0d100"
df1[df1 == "s100d0"] <- "h100d0"
df1[df1 == "s25d75"] <- "h25d75"
df1[df1 == "s50d50"] <- "h50d50"

ggplot(df1[df1$Method != "true",], aes(x=nu, y=phi, color=Method,group=Method,shape=modelcondition, label="0.45")) + 
  geom_point(alpha=0.5,size=1) +
  # geom_text(x=0.25, y = 0, label="s0d100") + 
  scale_shape_manual(values = c(0, 2, 6, 9, 10)) +
  #annotate("text", x=x_s, y=y_s, label=labels, size=8/.pt) + 
  
  annotate("text", x=x_s + 0.005, y=y_s + 0.02, label=labels_cass, size=8/.pt) +
  #annotate("pointrange", x=x_s - 0.021, y=y_s + 0.01, ymin=0,ymax=0, color="pink", size=0.25) +
  # c(0, 2, 6, 9, 10)
  annotate("pointrange", x=0.420 - 0.021, y=0.015 + 0.02, ymin=0,ymax=0, color="pink", size=0.25, shape=10) +
  annotate("pointrange", x=0.350 - 0.021, y=0.080 + 0.02, ymin=0,ymax=0, color="pink", size=0.25, shape=10) +
  annotate("pointrange", x=0.235 - 0.021, y=0.144 + 0.02, ymin=0,ymax=0, color="pink", size=0.25, shape=10) +
  annotate("pointrange", x=0.150 - 0.021, y=0.200 + 0.02, ymin=0,ymax=0, color="pink", size=0.25, shape=10) +
  annotate("pointrange", x=0.045 - 0.021, y=0.250 + 0.02, ymin=0,ymax=0, color="pink", size=0.25, shape=10) +
  
  annotate("text", x=x_s + 0.005, y=y_s + 0.01, label=labels_nj, size=8/.pt) +
  #annotate("pointrange", x=x_s - 0.021, y=y_s + 0.01, ymin=0,ymax=0, color="pink", size=0.25) +
  # c(0, 2, 6, 9, 10)
  annotate("pointrange", x=0.420 - 0.021, y=0.015 + 0.01, ymin=0,ymax=0, color="lightgreen", size=0.25, shape=10) +
  annotate("pointrange", x=0.350 - 0.021, y=0.080 + 0.01, ymin=0,ymax=0, color="lightgreen", size=0.25, shape=10) +
  annotate("pointrange", x=0.235 - 0.021, y=0.144 + 0.01, ymin=0,ymax=0, color="lightgreen", size=0.25, shape=10) +
  annotate("pointrange", x=0.150 - 0.021, y=0.200 + 0.01, ymin=0,ymax=0, color="lightgreen", size=0.25, shape=10) +
  annotate("pointrange", x=0.045 - 0.021, y=0.250 + 0.01, ymin=0,ymax=0, color="lightgreen", size=0.25, shape=10) +
  
  annotate("text", x=x_s + 0.005, y=y_s, label=labels_startle, size=8/.pt) +
  #annotate("pointrange", x=x_s - 0.021, y=y_s, ymin=0,ymax=0, color="lightgreen", size=0.25) +
  annotate("pointrange", x=0.420 - 0.021, y=0.015, ymin=0,ymax=0, color="lightblue", size=0.25) +
  annotate("pointrange", x=0.045 - 0.021, y=0.250, ymin=0,ymax=0, color="lightblue", size=0.25) +
  annotate("pointrange", x=0.350 - 0.021, y=0.080, ymin=0,ymax=0, color="lightblue", size=0.25) +
  annotate("pointrange", x=0.235 - 0.021, y=0.144, ymin=0,ymax=0, color="lightblue", size=0.25) +
  annotate("pointrange", x=0.150 - 0.021, y=0.200, ymin=0,ymax=0, color="lightblue", size=0.25) +
  
  annotate("text", x=x_s + 0.005, y=y_s - 0.01, label=labels_problin, size=8/.pt, fontface=2) +
  #annotate("pointrange", x=x_s - 0.021, y=y_s - 0.01, ymin=0,ymax=0, color="lightblue", size=0.25) +
  annotate("pointrange", x=0.420 - 0.021, y=0.015 - 0.01, ymin=0,ymax=0, color="purple", size=0.25) +
  annotate("pointrange", x=0.045 - 0.021, y=0.250 - 0.01, ymin=0,ymax=0, color="purple", size=0.25) +
  annotate("pointrange", x=0.350 - 0.021, y=0.080 - 0.01, ymin=0,ymax=0, color="purple", size=0.25) +
  annotate("pointrange", x=0.235 - 0.021, y=0.144 - 0.01, ymin=0,ymax=0, color="purple", size=0.25) +
  annotate("pointrange", x=0.150 - 0.021, y=0.200 - 0.01, ymin=0,ymax=0, color="purple", size=0.25) +
  
  geom_point(data=df1[df1$Method == "true",],aes(x=nu,y=phi,group=Method,shape=modelcondition),color="black",size=3.5, fill="black") +
  xlab("Heritable Missing Rate") + 
  ylab("Dropout Missing Rate") +
  theme_classic() +
  guides(shape=guide_legend(nrow=3,order=1), color="none") +
  
  annotate("pointrange", x=0.31, y=0.22, ymin=0, ymax=0, color="pink", size=0.25) +
  annotate("pointrange", x=0.31, y=0.2, ymin=0, ymax=0, color="lightgreen", size=0.25) +
  annotate("pointrange", x=0.31, y=0.18, ymin=0, ymax=0, color="lightblue", size=0.25) +
  annotate("pointrange", x=0.31, y=0.16, ymin=0, ymax=0, color="purple", size=0.25) +
  
  annotate("text", x=0.38, y=0.22, ymin=0, ymax=0, label="Cass-greedy", size=8/.pt, fontface=1) +
  annotate("text", x=0.395, y=0.2, ymin=0, ymax=0, label="Neighbor-Joining", size=8/.pt, fontface=1) +
  annotate("text", x=0.374, y=0.18, ymin=0, ymax=0, label="Startle-NNI", size=8/.pt, fontface=1) +
  annotate("text", x=0.36, y=0.16, ymin=0, ymax=0, label="ProbLin", size=8/.pt, fontface=1) +

  #guides(shape=guide_legend(nrow=3,order=1), color=guide_legend(nrow=3, order=2, label.hjust=1)) +
  #theme(legend.position = 'right') +
  #theme(legend.position="None") + 
  theme(legend.position = c(0.75, 0.94), legend.direction="vertical")  +
  #theme(legend.position=c(0.2, 0.4), legend.direction = "horizontal") + #c(0.88,0.7)) +
  theme(legend.title = element_blank()) +
  coord_cartesian(xlim=c(0,0.45), clip="off") +
  annotate("text", x=-0.05, y=0.28, label="(B)", clip="off", family="Times New Roman", size=7)
#guides(color = guide_legend(nrow = 2))

ggsave("sim_tlscl_estmissingparams.pdf", width=4, height=4)

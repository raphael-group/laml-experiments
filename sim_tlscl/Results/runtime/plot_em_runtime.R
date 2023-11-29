setwd('/Users/gc3045/sc-mail-experiments/sim_tlscl/Results/runtime')

require(ggplot2)
library(dplyr)

d = read.table("em_runtime_breakdown.txt",header=T,sep=',')
d$estep <- as.numeric(d$estep)
d$mstep <- as.numeric(d$mstep)
d$llh <- as.numeric(d$llh)
d$size <- as.numeric(d$size)

head(d)

d$size <- log(d$size)
d$mstep <- log(d$mstep)
d$estep <- log(d$estep)

ggplot(d, aes(x = size * 30, color = flag)) +
  geom_point(aes(y = estep, shape = "E-step"), stat = "summary", size=2) + 
  geom_point(aes(y = mstep, shape = "M-step"), stat = "summary", size=2) + 
  #stat_summary(aes(y = estep), shape='E-step') + 
  #stat_summary(aes(y = mstep), shape='M-step') + 
  geom_smooth(data = subset(d, flag == "closed-form" & estep), aes(y = estep), method = "lm", se = FALSE) + 
  geom_smooth(data = subset(d, flag == "closed-form" & mstep), aes(y = mstep), method = "lm", se = FALSE) + 
  geom_smooth(data = subset(d, flag == "non-convex" & estep), aes(y = estep), method = "lm", se = FALSE) + 
  geom_smooth(data = subset(d, flag == "non-convex" & mstep), aes(y = mstep), method = "lm", se = FALSE) + 
  scale_color_manual(name = "Cases", values = c("blue", "purple"), labels = c("Convex (No Silencing)", "Non-convex (Silencing)")) +  
  #scale_linetype_manual(name = "Step", values = c("E-step" = "solid", "M-step" = "solid")) + 
  scale_shape_manual(name = "Step", values = c("E-step" = 15, "M-step" = 17)) +  # Define shapes and labels
  labs(x = "log(N*k)", y = "log runtime (s)", title = "EM Runtime Breakdown") + 
  guides(color = guide_legend(nrow = 2), shape = guide_legend(nrow = 2, override.aes = list(color = c("black", "black")))) + 
  theme_bw() +
  scale_x_continuous(expand = c(0.05, 0.1)) +
  theme(legend.position = "bottom") 
  

mean(d[d$flag == "closed-form",]$llh - d[d$flag == "non-convex",]$llh)
mean(d[d$flag == "closed-form",]$llh)
mean(d[d$flag == "non-convex",]$llh)

ggsave("simtlscl_em_runtime_comparison.pdf", width=6, height=4)

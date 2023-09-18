#setwd("/Users/gc3045/problin_experiments/sim_tlscl/Results/topology_and_params")
library(extrafont)
font_import() 
loadfonts(device="pdf")


require(ggplot2)
library('stringr')
library(reshape2)
library(ggtext)

d = read.table("partial_problintopo_estparams.txt", sep=",", header=T)
d['modelcondition'] <- str_c(d$true_nu, 'd', d$true_phi)

true_params = read.table("true_params.txt", sep=" ", header=F)
colnames(true_params) = c('modelcondition', 'true_phi_value', 'true_nu_value')

d = merge(d, true_params)
head(d)

rf_df = d[, c("modelcondition", "startle_rf", "cassg_rf", "cassilp_rf", "problin_rf", "nj_rf")]

head(rf_df)
# for RF check which method is lowest
rf_df$rf_min <- colnames(rf_df)[apply(rf_df, 1, which.min)]
rf_df$rf_min
table(rf_df$rf_min)

rf_df = d[, c("modelcondition", "startle_rf", "cassg_rf", "cassilp_rf", "problin_rf", "nj_rf")]

df2 <- melt(rf_df)
df2
df2$variable = factor(df2$variable,labels = c("Startle-NNI","Cass-greedy","Cass-ilp", "ProbLin", "Neighbor-Joining"))

plot0 <- ggplot(df2,aes(x=variable,y=value)) + geom_boxplot() + stat_summary() + 
  #facet_wrap(~modelcondition) + theme_classic() +
  xlab("Method") + ylab("RF") + 
  theme_classic() 
#geom_hline(yintercept=0, linetype="dashed", color="blue") + theme_classic()

# for WP check which method is lowest
wp_df = d[, c("startle_wp", "cassg_wp", "cassilp_wp", "problin_wp", "nj_wp")]

head(wp_df)
wp_df$wp_min <- colnames(wp_df)[apply(wp_df, 1, which.min)]
table(wp_df$wp_min)

# for LLH check which method is highest
wp_df = d[, c("startle_wp", "cassg_wp", "cassilp_wp", "problin_wp", "nj_wp")]

head(wp_df)
wp_df$wp_min <- colnames(wp_df)[apply(wp_df, 1, which.min)]
table(wp_df$wp_min)

# plot log odds normalized by the LLH of the true tree
#install.packages("tidyr")
library(reshape2)
library(tidyr)

head(d)
d$norm_cassilp_llh <- -d$cassilp_NLLH + d$true_llh
d$norm_startle_llh <- -d$startle_NLLH + d$true_llh
d$norm_cassg_llh <- -d$cassg_NLLH + d$true_llh
d$norm_problin_llh <- -d$problin_NLLH + d$true_llh
d$norm_nj_llh <- -d$nj_NLLH + d$true_llh
head(d)

llh_df = d[, c("modelcondition", "norm_startle_llh", "norm_cassg_llh", "norm_cassilp_llh", "norm_problin_llh", "norm_nj_llh")]

head(llh_df)
df2 <- melt(llh_df)
head(df2)

df2$variable = factor(df2$variable,labels = c("Startle-NNI","Cass-greedy","Cass-ilp", "ProbLin", "Neighbor-Joining"))

plot1 <- ggplot(df2,aes(x=variable,y=value)) + geom_boxplot() + stat_summary() + 
  #facet_wrap(~modelcondition) + theme_classic() +
  xlab("Method") + ylab("Likelihood Log Odds") + 
  geom_hline(yintercept=0, linetype="dashed", color="blue") + theme_classic()
#ggsave("sim_tlscl_logllo.pdf", width=8, height=5)
#ggsave("sim_tlscl_logllo.png", width=8, height=5)



# log odds normed by wMP 
head(d)

d$scaled_startle_wp <- d$startle_wp - d$truetopo_wp
d$scaled_cassg_wp <- d$cassg_wp - d$truetopo_wp
d$scaled_cassilp_wp <- d$cassilp_wp - d$truetopo_wp

d$scaled_problin_wp <- d$problin_wp - d$truetopo_wp
d$scaled_nj_wp <- d$nj_wp - d$truetopo_wp
wp_df = d[, c("modelcondition", "scaled_startle_wp", "scaled_cassg_wp", "scaled_cassilp_wp", "scaled_problin_wp", "scaled_nj_wp")]
head(wp_df)
df2 <- melt(wp_df)
head(df2)

df2$variable = factor(df2$variable,labels = c("Startle-NNI","Cass-greedy", "Cass-ilp", "ProbLin", "Neighbor-Joining"))
plot2 <- ggplot(df2,aes(x=variable,y=-value)) + geom_boxplot() + stat_summary() + 
  #facet_wrap(~modelcondition) + theme_classic() +
  xlab("Method") + 
  ylab("Log Weighted Parsimony Score Ratio (true topo - method)") + 
  geom_hline(yintercept=0, linetype="dashed", color="blue") + theme_classic()
#ggsave("sim_tlscl_logwps.pdf", width=8, height=5)
#ggsave("sim_tlscl_logwps.png", width=8, height=5)

# install.packages('gridExtra')
require(gridExtra)
pdf("sim_tlscl_cassilp.pdf", width=14, height=5)
grid.arrange(plot0, plot1, plot2, ncol=3)
dev.off()


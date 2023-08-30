setwd("/Users/gc3045/problin_experiments/sim_tlscl/Results/topology_and_params")
library(extrafont)
font_import() 
loadfonts(device="pdf")


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

rf_df = d[, c("startle_rf", "cassg_rf", "problin_rf", "nj_rf")]
head(rf_df)
# for RF check which method is lowest
rf_df$rf_min <- colnames(rf_df)[apply(rf_df, 1, which.min)]
rf_df$rf_min
table(rf_df$rf_min)

# for WP check which method is lowest
wp_df = d[, c("startle_wp", "cassg_wp", "problin_wp", "nj_wp")]
head(wp_df)
wp_df$wp_min <- colnames(wp_df)[apply(wp_df, 1, which.min)]
table(wp_df$wp_min)

# for LLH check which method is highest
wp_df = d[, c("startle_wp", "cassg_wp", "problin_wp", "nj_wp")]
head(wp_df)
wp_df$wp_min <- colnames(wp_df)[apply(wp_df, 1, which.min)]
table(wp_df$wp_min)

# plot log odds normalized by the LLH of the true tree
#install.packages("tidyr")
library(reshape2)
library(tidyr)

head(d)
d$norm_startle_llh <- -d$startle_NLLH + d$true_llh
d$norm_cassg_llh <- -d$cassg_NLLH + d$true_llh
d$norm_problin_llh <- -d$problin_NLLH + d$true_llh
d$norm_nj_llh <- -d$nj_NLLH + d$true_llh
head(d)

llh_df = d[, c("modelcondition", "norm_startle_llh", "norm_cassg_llh", "norm_problin_llh", "norm_nj_llh")]
head(llh_df)
df2 <- melt(llh_df)
head(df2)

df2$variable = factor(df2$variable,labels = c("Startle-NNI","Cass-greedy","ProbLin", "Neighbor-Joining"))
ggplot(df2,aes(x=variable,y=value)) + geom_boxplot() + stat_summary() + 
  #facet_wrap(~modelcondition) + theme_classic() +
  xlab("Method") + ylab("Likelihood Log Odds") + 
  geom_hline(yintercept=0, linetype="dashed", color="blue") + theme_classic()
  


# log odds normed by wMP 
head(d)

d$norm_startle_wp <- d$startle_wp - d$truetopo_wp
d$norm_cassg_wp <- d$cassg_wp - d$truetopo_wp
d$norm_problin_wp <- d$problin_wp - d$truetopo_wp
d$norm_nj_wp <- d$nj_wp - d$truetopo_wp
wp_df = d[, c("modelcondition", "norm_startle_wp", "norm_cassg_wp", "norm_problin_wp", "norm_nj_wp")]
head(wp_df)
df2 <- melt(wp_df)
head(df2)

df2$variable = factor(df2$variable,labels = c("Startle-NNI","Cass-greedy","ProbLin", "Neighbor-Joining"))
ggplot(df2,aes(x=variable,y=value)) + geom_boxplot() + stat_summary() + 
  facet_wrap(~modelcondition) + theme_classic() +
  xlab("Method") + 
  ylab("Log Weighted Parsimony Score Ratio (method - true topo)") + 
  geom_hline(yintercept=0, linetype="dashed", color="blue") + theme_classic()






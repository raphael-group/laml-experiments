setwd("/Users/uym2/my_gits/problin_experiments/sim_tlscl/Results/topology_and_params")
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




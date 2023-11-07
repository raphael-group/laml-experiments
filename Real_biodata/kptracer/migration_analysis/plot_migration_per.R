setwd("/Users/gc3045/problin/migration_story")
library(ggplot2)

#d = read.table("interval_transition_stats_step1.csv", sep=",", header=T)
#d = read.table("interval_transition_stats_step5.csv", sep=",", header=T)
d = read.table("interval_transition_stats_step1_scale001.csv", sep=",", header=T)
#d = read.table("interval_transition_stats.csv", sep=",", header=T)
#d = read.table("interval_transition_stats_step3.csv", sep=",", header=T)

options(repr.plot.width = 15, repr.plot.height =3) 

scale_factor = 6 / d$interval_start[length(d$interval_start)]
d$scaled_interval_start = d$interval_start * scale_factor
head(d$scaled_interval_start)
tail(d$scaled_interval_start)

#hex_codes1 <- hue_pal()(n1)                             # Identify hex codes
#hex_codes1                                              # Print hex codes to console
# "#F8766D" "#7CAE00" "#00BFC4" "#C77CFF"

#d[d$transition_type!= "n2n_transition_norm",]
ggplot(d, aes(x=scaled_interval_start, y=per_all_lineages, fill=transition_type)) + 
  theme_classic() + 
  guides(fill=guide_legend(nrow=1,byrow=TRUE,title="Event Types")) + 
  theme(legend.position = 'bottom', legend.direction = "horizontal", #panel.border = element_rect(size = NA, fill = NA),
        axis.ticks = element_line(size = 1), text = element_text(size=20)) + 
  #geom_vline(xintercept=2.7) + #geom_vline(xintercept=3.658) + #geom_vline(xintercept=2) +
  geom_vline(xintercept=2.25) + geom_vline(xintercept=1.75) +
  expand_limits(x = 0, y = 0) + scale_x_continuous(expand = c(0, 0)) + scale_y_continuous(expand = c(0, 0)) + 
  ylab("Proportion of Lineages") + 
  xlab("Scaled Time") +
  #scale_fill_manual(values=c("#C77CFF", "#F8766D", "#00BFC4"), labels=c('Metastasis to Metastasis',
  #                             'Reseeding',
  #                             'Metastasis')) + 
  coord_cartesian(clip = "off") +
  guides(fill=guide_legend(nrow=3,byrow=TRUE)) + 
  geom_area(alpha=0.6, size=1, color="black") 
  
                       
# update the 
ggsave("transition_type_pers.png", width=15, height = 4)

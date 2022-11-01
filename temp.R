

## Plot Decision Weights across both AM & PM sessions
```{r, echo = FALSE}

# Create placeholder variables and fill with respective data
condition    <- c("WR", "WR", "SR", "SR", "WR", "WR", "SR", "SR");
session      <- c(rep("AM", 4), rep("PM", 4));
information  <- c(rep(c("LogLLA", "LogBR"), 4));

coefficients <- c(0.30879,  0.77677,  0.2452,  0.65133,  0.29171,  0.72799,  0.23351,  0.77166);

se_lower     <- c(0.28761,  0.73181,  0.21407,  0.58405,  0.27113,  0.6843,  0.20264,  0.70358);
se_upper     <- c(0.32997,  0.82173,  0.27633,  0.71861,  0.31229,  0.77168,  0.26438,  0.83974);
ci_lower     <- c(0.2672815, 0.6886429, 0.1841902, 0.5194604, 0.25137681, 0.64235532, 0.17300985, 0.63821854);
ci_upper     <- c(0.350304, 0.864895588, 0.306202423, 0.783197672, 0.332046028, 0.813631264, 0.294015979, 0.905105997);

# Create tibble for Decision Weights
bds.temp.DW  <- tibble(condition, session, information, coefficients, se_lower, se_upper, ci_lower, ci_upper)

bds.temp.DW$condition   <- factor(bds.temp.DW$condition, levels = c("WR","SR"))
bds.temp.DW$session     <- factor(bds.temp.DW$session, levels = c("AM", "PM"))
bds.temp.DW$information <- factor(bds.temp.DW$information, levels = c("LogLLA", "LogBR"))

plot.bds.DW <- ggplot(data = bds.temp.AM.DW, aes( x = condition, y = coefficients , color =  information)) + 
  geom_point(size=  2.5) + 
  scale_y_continuous(limits = c(0.0,1)) +
  
  labs(title = "Decision Weights by Condition", x = "Condition", y = "Weight", color = "Information")+
  scale_color_manual(labels = c("Draw Outcome","Base Rate Odds"), values = c("blue", "red"))+
  
  geom_errorbar(aes(ymin = ci_lower, ymax = ci_upper), color = '#595959', width = 0.1)+ # Add error bars
  theme_bw(base_size = 14) + theme(aspect.ratio =  2, axis.title = element_text(face = "bold"))  

# Facet wrap plots
plot.bds.DW <- plot.bds.DW  + facet_wrap(~session, ncol = 2);


# Save as png with transparent background
ggsave( plot = plot.bds.DW,
        filename = "img/bds/bds_DW.png",
        bg = "transparent")

# Remove placeholder variables
rm(condition);rm(session);rm(information);rm(coefficients);rm(se_lower);rm(se_upper);rm(ci_lower);rm(ci_upper);rm(bds.temp.DW)

```



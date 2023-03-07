library(ggplot2)
library(readxl)
library(dplyr)

# Read data
old_df <- read_xlsx("data/2008_study_data/bayes_dataset.xlsx") %>% 
  mutate(TSD = factor(TSD, levels = c(0, 1), labels = c("WR", "TSD"))) %>%
  mutate(Subject2 = as.factor(Subject2))


# Prefix of 'jdm' = Dickinson & Drummond 2008 trial configurationd ata.
# Prefix of 'nsf' = Experiment 1
# Prefix of 'bds' = Experiment 2

# Plot boxplots of posteriors 
jdm_posteriors <- ggplot(data = old_df, aes(x = Subject2, y = BayesPosteriors)) +
  geom_boxplot(aes(fill = TSD)) +
  facet_wrap(~Subject2, scales = "free") +
  scale_y_continuous(limits = c(0, 1)) + 
  labs(
    title = "2008 JDM Paper: Bayesian Posteriors Boxplots, separated by Condition", 
    x = "Participant ID", y = "Posterior Probability", 
    fill = "Condition"
    ) 

nsf_posteriors <- ggplot(data = nsf.data.exNB, aes(x = factor(PtID), y = post_prob)) +
  geom_boxplot(aes(fill = Condition)) +
  facet_wrap(~PtID, scales = "free") + 
  scale_y_continuous(limits = c(0, 1))+
  labs(
    title = "NSF: Bayesian Posteriors Boxplots, separated by Condition",
    x = "Participant ID", y = "Posterior Probability", 
    fill = "Condition"
  )

bds_posteriors_AM <- ggplot(data = bds.data.WRSR.AM.exNB, aes(x = factor(PtID) , y = post_prob)) +
  geom_boxplot(aes(fill = Condition)) +
  facet_wrap(~PtID, scales = "free") +
  labs(
    title = "BDS: Bayesian Posteriors Boxplots, AM Session, separated by Condition",
    x = "Participant ID", y = "Posterior Probability", 
    fill = "Condition"
  )


bds_posteriors_PM <- ggplot(data = bds.data.WRSR.PM.exNB, aes(x = factor(PtID) , y = post_prob)) +
  geom_boxplot(aes(fill = Condition)) +
  facet_wrap(~PtID, scales = "free") +
  labs(
    title = "BDS: Bayesian Posteriors Boxplots, PM Session, separated by Condition",
    x = "Participant ID", y = "Posterior Probability", 
    fill = "Condition"
  )


# Save each plot 
ggsave(
  filename = "img/POSTERIORS_jdm_boxplot.png",
  plot = jdm_posteriors, 
  bg = "transparent"
)

ggsave(
  filename = "img/POSTERIORS_nsf_boxplot.png",
  plot = nsf_posteriors,
  bg = "transparent"
)



# Plot boxplots of likelihood


jdm_evidence <- ggplot(data = old_df, aes(x = Subject2, y = LogLLA)) +
  geom_boxplot(aes(fill = TSD)) +
  facet_wrap(~Subject2, scales = "free") +
  scale_y_continuous(limits = c(-6, 6)) + 
  labs(
    title = "2008 JDM Paper: Log Likelihood of LEFT Box (EVIDENCE) Boxplots, separated by Condition", 
    x = "Participant ID", y = "Posterior Probability", 
    fill = "Condition"
  ) 


nsf_evidence <- ggplot(data = nsf.data.exNB, aes(x = factor(PtID), y = LogLLA)) +
  geom_boxplot(aes(fill = Condition)) +
  facet_wrap(~PtID, scales = "free") + 
  scale_y_continuous(limits = c(-6, 6)) +
  labs(
    title = "NSF: Log Likelihood of LEFT box (EVIDENCE) Boxplots, separated by Condition",
    x = "Participant ID", y = "Posterior Probability", 
    fill = "Condition"
  )

# Save each plot 
ggsave(
  filename = "img/EVIDENCE_jdm_boxplot.png",
  plot = jdm_evidence, 
  bg = "transparent"
)

ggsave(
  filename = "img/EVIDENCE_nsf_boxplot.png",
  plot = nsf_evidence,
  bg = "transparent"
)

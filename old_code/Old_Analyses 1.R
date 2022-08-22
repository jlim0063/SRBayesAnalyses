
##install additional packages
install.packages ("aod", dependencies = TRUE)
install.packages("car",dependencies = TRUE)
install.packages("e1071",dependencies = TRUE)
install.packages ("afex", dependencies = TRUE)
install.packages("readxl")
install.packages("lmerTest")

# package for calculating Effect Sizes
install.packages ("piecewiseSEM")

## Load Packages
library(data.table)
library(reshape2)
library(ggplot2)
library(lme4)
library(dplyr)
library(aod)
library(tidyr)
library(car)
library(e1071)
library(visreg)
library(afex) 
library(readxl)
library(lmerTest)
library(piecewiseSEM)

bayes<-  read.csv("Bayes_data_6Sep.csv")
bayes <- as.data.table(bayes)
summary(bayes)
str(bayes)
## Missing Cases
sum(is.na(bayes$PtResp))

## Show rows with missing data
bayes[!complete.cases(bayes),]

## Subset with no missing PtResp
bayes.complete <-  na.omit(bayes)
summary(bayes.complete)
tally(group_by(bayes.complete, ID))

# ------------------------------------------------------------------------------------------#



## THE LOGIT MODEL (not mixed)

#remove rows with missing pt responses


bayes.logit2 <- glm(PtResp ~ 1 + LogLLA + LogBaserate + 
                       SR + CM + 
                       SR:LogLLA + SR:LogBaserate +
                       CM:LogLLA + CM:LogBaserate, 
                        family = binomial(),
                     data= bayes.complete)
summary(bayes.logit2)

# Chi-Square test of Coefficients for bayes.logit
l <- cbind (0, 0, 1, 0, 0, 0 ,-1, 0, 0)
wald.test(b = coef(bayes.logit2), Sigma = vcov(bayes.logit2), L = l)

# ------------------------------------------------------------------------------------------#



# Predict the probability (p) of selecting Left Box
probabilities <- predict(bayes.logit2, type = "response")
predicted.classes <- ifelse(probabilities > 0.5, "pos", "neg")
head(predicted.classes)

summary(bayes.complete.pred)

# Bind the logit and tidying the data for plot
bayes.complete.pred <- bayes.complete.pred %>%
  mutate(logit = log(probabilities/(1-probabilities))) %>%
  gather(key = "predictors", value = "predictor.value", -logit)

# ------------------------------------------------------------------------------------------#

## THE PROBIT MIXED MODEL

bayes.probit <- glmer(PtResp ~ 1 + LogLLA + LogBaserate + 
                        SR + CM + 
                        SR:LogLLA + SR:LogBaserate +
                        CM:LogLLA + CM:LogBaserate + 
                        (1 | ID), family = binomial(link= "probit"),
                      data= bayes)
summary (bayes.probit)



## THE LOGIT MIXED MODEL
bayes.logit <- glmer(PtResp ~ 1 + LogLLA + LogBaserate + 
                       SR + CM + 
                       SR:LogLLA + SR:LogBaserate +
                       CM:LogLLA + CM:LogBaserate + 
                       (1 | ID), family = binomial(),
                     data= bayes)
# ------------------------------------------------------------------------------------------#
## ASSUMPTION TESTING - NORMAL DISTRIBUTION OF RANDOM EFFECTS

## make a dataset of the random effects by UserID
bayes.random <- as.data.table(coef(bayes.probit)$ID)

## check whether the random effects are normally distributed
## note that these have mean 0
ggplot(bayes.random, aes(`(Intercept)`)) +
  geom_histogram()

## normality via QQ plot
ggplot(bayes.random, aes(sample = `(Intercept)`)) +
  stat_qq() + stat_qq_line()

## I HAVE ONE EXTREME OUTLIER ON THIS.

# ------------------------------------------------------------------------------------------#



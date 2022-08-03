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

options(scipen = 20)

#Read Data

data <-  read.csv("2 Bayes Summary - CompletedPts.csv" )

dataSRWR <- subset(data, ConditionOld ==1 | ConditionOld ==2)
summary(dataSRWR)


 
 
 
# Change variable type of LogLLA and LogBaserate
as.numeric(dataSRWR$LogLLA)
as.numeric(dataSRWR$LogBaserate)
is.numeric(dataSRWR$LogBaserate)

class(dataSRWR$LogLLA)
class(dataSRWR$LogBaserate)

# =====================================================================
# KSS Impact on Accuracy


#delete duplicates
dataKSS<- distinct(dataSRWR, PtID, Condition, SessionTime, StartKSS,.keep_all=TRUE)

length(unique(dataSRWR$PtID))

ggplot(dataKSS, aes(StartKSS))+ 
  geom_histogram(fill='white', colour='black', binwidth=1) +
  scale_x_continuous(breaks = seq(0,10, by =1))+
  stat_function(fun = dnorm, args = list(mean = mean(dataKSS$StartKSS), sd = sd(dataKSS$StartKSS)))+
  theme_bw()


shapiro.test(dataKSS$StartKSS)


#log transform
dataKSS$KSS_log <- log (dataKSS$StartKSS)


ggplot(dataKSS, aes(KSS_log))+ 
  geom_histogram(fill='white', colour='black', binwidth=0.1) +
  scale_x_continuous(breaks = seq(0,10, by=0.1))+
  stat_function(fun = dnorm, args = list(mean = mean(dataKSS$KSS_log), sd = sd(dataKSS$KSS_log)))+
  theme_bw()

shapiro.test(dataKSS$KSS_log)

#Does being sleep-restricted affect KSS score (at start of task)?
b_KSS <- lmer(StartKSS~ 1 + Condition + (1|PtID), data= dataKSS)
b_KSSlog <- lmer(KSS_log ~ 1 + Condition + (1|PtID), data= dataKSS)

summary(b_KSS)
summary(b_KSSlog)
# =====================================================================
# Does being Sleep-restricted affect accuracy on the Bayesian task?

b_acc <- glmer(IsCorrect ~ 1 + Condition+(1   | PtID ), family = binomial("logit"), data = dataSRWR)
summary(b_acc)

# =====================================================================
# Probit models to get Decision Weights of draw evidence and base rate odds

b1<- glmer(PtResp ~ 1 + LogLLA + LogBaserate + 
             Condition + Condition*LogLLA + 
             Condition*LogBaserate+ (1  | PtID), family = binomial("probit"),data= dataSRWR)
summary(b1)


## Confidence Intervals.
confint(b1, method="Wald",level = 0.95, oldNames="FALSE")

## Well-rested: comparison between decision weights of Likelihood ratio and Base rate odds
#ChiSq = 9.8021, p < .01
linearHypothesis(b1, c(" LogBaserate =  LogLLA"), rhs=NULL,
                 vcov.=NULL, singular.ok=FALSE, verbose=FALSE)

## Sleep-retricted: comparison between decision weights of Likelihood ratio and Base rate odds
#ChiSq = 32.407, p<.001

linearHypothesis(b1, c("LogBaserate:Condition + LogBaserate = LogLLA:Condition + LogLLA"), rhs=NULL,
                 vcov.=NULL, singular.ok=FALSE, verbose=FALSE)


##Create relative decision weights
fixef(b1)
Intercept<-   0.14618502
LogLLA<-   0.16970417
LogBaserate<- 0.20590978
Condition<-  -0.08604727
LogLLAxCondition<-   -0.03482979 + LogLLA
LogBaseratexCondition<-   0.02096245 + LogBaserate

print(LogLLAxCondition)
print(LogBaseratexCondition)

#Decision weight for WR
print((LogLLA - LogBaserate)/(LogLLA+LogBaserate))

#Decision weight for SR
print((LogLLAxCondition - LogBaseratexCondition)/(LogLLAxCondition+LogBaseratexCondition))


length(unique(dataSRWR$PtID))


#=====

SR <- subset(dataSRWR, Condition=="1")


length(unique(SR$PtID))

WR <- subset(dataSRWR, Condition=="0")
length(unique(WR$PtID))


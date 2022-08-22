## MODEL COMPARISONS for MIXED MODELS# #

# A probit mixed model with just intercept
b0 <- glmer (PtResp~ 1 + (1|ID), family = binomial("probit"), data = bayes)

# A probit mixed model with Log Likelihood and Log Base Rate
b1 <- glmer(PtResp ~ 1 + LogLLA + LogBaserate + 
              (1 | ID), family = binomial("probit"),
            data= bayes)

# A probit mixed model with Log Likelihood + Log Base Rate, and Sleep Conditions
b2<- glmer(PtResp ~ 1 + LogLLA + LogBaserate + 
                 SR + CM +
                 (1 | ID), family = binomial("probit"),
               data= bayes)





# A probit mixed model with Log Likelihood + Log Base Rate, and Sleep Conditions AND ALL THEIR INTERACTIONS

b_null <- glmer(PtResp ~ 1 +
                  (1  | ID), family = binomial("probit"),
                data= bayes)

b3<- glmer(PtResp ~ 1 + LogLLA + LogBaserate + 
               SR + CM + 
               SR:LogLLA + SR:LogBaserate +
               CM:LogLLA + CM:LogBaserate + 
               (1  | ID), family = binomial("probit"),
             data= bayes)


anova (b_null, b3)
rsquared(b3)

#Comparing difference in decision weights in Conditions

## WR : Chisq = 18.38, p <.001
linearHypothesis(b3, c(" LogBaserate =  LogLLA"), rhs=NULL,
                 vcov.=NULL, singular.ok=FALSE, verbose=FALSE)

## SR : Chisq 1.70, N.S.
linearHypothesis(b3, c("LogBaserate:SR + LogBaserate = LogLLA:SR + LogLLA"), rhs=NULL,
                 vcov.=NULL, singular.ok=FALSE, verbose=FALSE)

## CM : Chisq 0.30, N.S.
linearHypothesis(b3, c("LogBaserate:CM + LogBaserate = LogLLA:CM + LogLLA"), rhs=NULL,
                 vcov.=NULL, singular.ok=FALSE, verbose=FALSE)



## Model Comparisons
anova(b0, b1, b2, b3, test = "LRT")

## Call Summary
summary(b1)
summary(b2)
summary(b3)
summary(b4)




## Confidence Intervals.
confint(b3, method="Wald", oldNames="FALSE")

## Get ChiSquare statistics of SR, CM, and their interactions with LogBaserate and LogLikelihood
linearHypothesis(b3, ("(Intercept)= 0"))
linearHypothesis ( b3 , ("LogLLA = 0"))
linearHypothesis ( b3 , ("LogBaserate = 0"))
linearHypothesis ( b3 , ("SR = 0"))
linearHypothesis(b3, ("CM = 0"))
linearHypothesis ( b3 , ("LogLLA:SR  = 0"))
linearHypothesis ( b3 , ("LogBaserate:SR  = 0"))
linearHypothesis ( b3 , ("LogLLA:CM  = 0"))
linearHypothesis ( b3 , ("LogBaserate:CM  = 0"))

## Chi-Square Test of Coefficient Equality
# between
linearHypothesis(b3, c("LogLLA = LogBaserate"), test= "Chisq")

linearHypothesis (b3, matchCoefs(b3, ":"))

#-------------------------------------------------------------------------------------------

## DOES SLEEP CONDITION IMPACT ACCURACY OF BAYESIAN GUESSES? - SR does!

b_accnull <- glmer(IsCorrect ~ 1 + (1| ID ), family = binomial("logit"), data = bayes)
summary(b_accnull)

b_acc <- glmer(IsCorrect ~ 1 + SR + CM +(1   | ID ), family = binomial("logit"), data = bayes)
blups <- coef(b_acc)$ID[["(Intercept)"]]

summary(blups)

# Calculate default probability of accurate response on task using Blups.
as.numeric(blups)
mean(plogis(blups))

summary(b_acc)
anova(b_acc)
anova(b_accnull, b_acc)

linearHypothesis(b_acc, ("SR= 0"))

#test model
b_acctest <- glmer(IsCorrect ~ 1 + SR+CM + (1  | ID ), family = binomial("logit"), data = bayes)


# Probability of getting the task right WHILE WELL-RESTED - .76
1/(1+exp(-1.1656))

#Probability of getting the task right WHILE SLEEP RESTRICTED - .70
1/(1+exp (-(1.1656-.3151)))

#Probability of getting the task right WHILE CIRCADIAN MISALIGNED - .73
1/(1+exp (-(1.1656-.1519)))

## ODDS RATIO of GETTING THE TASK RIGHT 
## while WELL-RESTED  - 3.21
## while SLEEP RESTRICTED - 0.73
## while CIRCADIAN MISALIGNED - 0.86
exp(-0.1519)

exp(fixef(b_acc))

exp(confint(b_acc, method="Wald", level = .90, oldNames="FALSE"))
anova (b_acc)

anova(b3)
# ------------------------------------------------------------------------------------------#
## ASSUMPTION TESTING - NORMAL DISTRIBUTION OF RANDOM EFFECTS

## make a dataset of the random effects by UserID
bayes.random <- as.data.table(coef(b3)$ID)



## check whether the random effects are normally distributed
## note that these have mean 0
ggplot(bayes.random, aes(`(Intercept)`)) +
  geom_histogram()

## normality via QQ plot
ggplot(bayes.random, aes(sample = `(Intercept)`)) +
  stat_qq() + stat_qq_line()

shapiro.test(resid(b3))
## I HAVE ONE EXTREME OUTLIER ON THIS.

# ------------------------------------------------------------------------------------------#

###  ASSUMPTION TESTING

## Univariate Normality ... but all the variables seem "categorical" ... 
## Not sure if univariate normality is appropriate

# Univariate Plot of Guesses
hist_bayes_PtResp  <- ggplot(data = bayes, aes (x = PtResp))
hist_bayes_PtResp + geom_histogram()

# ------------------------------------------------------------------------------------------#
### NORMALITY OF OUTCOME

## make a dataset of the residuals and expected values
## to do this, we use the
## fitted() function for expected values
## resid() function for model residuals
## NOTE: these two functions work on linear regression models too
b.residuals <- data.table(
  Yhat = fitted(b3),
  Residuals = resid(b3))

## check for normality of the outcome
## by examining residuals
ggplot(b.residuals, aes(Residuals)) +
  geom_histogram()

### HOMOGENEITY OF VARIANCE

## check for homogeneity of variance assumption
ggplot(b.residuals, aes(Yhat, Residuals)) +
  geom_point(alpha = .2)



#----------------
## Test

## Visualize results
## main effects only
## different intercepts, same slope (parallel lines)
visreg(
  fit = b3,
  xvar = "LogLLA",
  by = "CM","SR",
  overlay = TRUE)


summary(b3)

anova (b3)






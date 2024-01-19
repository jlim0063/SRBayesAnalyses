# Load packages
require(simr)
require(lme4)
require(lmerTest)
require(partR2)
require(dplyr)
require(data.table)
# Use 4 cores
parallel::detectCores()
future::plan(future::multisession, workers = 4)


## These are post-hoc power analyses performed in response to a reviewer comment on our JOSR submission. 
## The comment in question relate to whether n.s. TSD effects reported in the manuscript are possibly due to power issues.
## Please skip forward to "Inspect power analyses" header if you do not wish to spend time running the simulations. 

# ================================================================================================================ 
 
## Change condition to dummy code
nsf.data.exNB[, ConditionSR := ifelse(Condition=="SR", 1, 0)]
nsf.data.exNB[, ConditionTSD := ifelse(Condition=="TSD", 1, 0)]

## Run random slope models to determine standard deviation of slopes.
## Some models do not converge, so fixed effects are not reliable. Purpose is only for gleaning what the random slope SD is. 
# 
# m.nsf.exNB2a <- glmer(PtResp ~ 1 + ConditionSR + ConditionTSD + LogBaserate + LogLLA + ConditionSR:LogBaserate + ConditionSR:LogLLA + ConditionTSD:LogBaserate + ConditionTSD:LogLLA + 
#                       (1 + ConditionTSD:LogLLA  |PtID),             
#                     family = binomial('probit'),
#                     nsf.data.exNB);
# 
# 
# 
# m.nsf.exNB2b <- glmer(PtResp ~ 1 + ConditionSR + ConditionTSD + LogBaserate + LogLLA + ConditionSR:LogBaserate + ConditionSR:LogLLA + ConditionTSD:LogBaserate + ConditionTSD:LogLLA + 
#                       (1 + ConditionTSD:LogBaserate |PtID),             
#                     family = binomial('probit'),
#                     nsf.data.exNB);

m.nsf.exNB2c <- glmer(PtResp ~ 1 + ConditionSR + ConditionTSD + LogBaserate + LogLLA + ConditionSR:LogBaserate + ConditionSR:LogLLA + ConditionTSD:LogBaserate + ConditionTSD:LogLLA + 
                      (1 +LogBaserate |PtID),             
                    family = binomial('probit'),
                    nsf.data.exNB);


m.nsf.exNB2d <- glmer(PtResp ~ 1 + ConditionTSD:LogBaserate + ConditionTSD:LogLLA +
                        (1 + ConditionTSD:LogLLA  |PtID),             
                      family = binomial('probit'),
                      nsf.data.exNB);

m.nsf.exNB2e <- glmer(PtResp ~ 1 +  ConditionTSD:LogBaserate + ConditionTSD:LogLLA +
                        (1 + ConditionTSD:LogBaserate  |PtID),             
                      family = binomial('probit'),
                      nsf.data.exNB);



summary(m.nsf.exNB2d)
summary(m.nsf.exNB2e)

## Create model object for simulation
sim_model <- m.nsf.exNB


# fixef(sim_model)["ConditionSR:LogLLA"]       <- (0.59111*.5) * -1
# fixef(sim_model)["ConditionSR:LogBaserate"]  <- (1.6638*.5) * -1
# 
#  
 
## Run power simulations
sim_model <- m.nsf.exNB
fixef(sim_model)["ConditionTSD:LogLLA"]      <- (0.3931*.5) * -1
numSims <- 50

TSD_LLA_pow <- powerSim(sim_model, test = fixed("ConditionTSD:LogLLA", "z"), nsim = numSims, seed = 1)

sim_model <- m.nsf.exNB
fixef(sim_model)["ConditionTSD:LogBaserate"] <- (1.30669*.5) * -1 
numSims <- 50

TSD_LBR_pow <- powerSim(sim_model, test = fixed("ConditionTSD:LogBaserate", "z"), nsim = numSims, seed = 1)
# SR_LLA_pow  <- powerSim(sim_model, test = fixed("ConditionSR:LogLLA", "z"), nsim = numSims)
# SR_LBR_pow  <- powerSim(sim_model, test = fixed("ConditionSR:LogBaserate", "z"), nsim = numSims)



# Inspect power analyses --------------------------------------------------
TSD_LLA_pow; 
TSD_LBR_pow


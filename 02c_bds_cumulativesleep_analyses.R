# Get vector of pts who have completed SR trials
bds.sr_pts = unique(bds.data[bds.data$Condition == "SR",]$PtID)

# Subset only SR participants' data
bds.data.SR.csl  <- bds.data.SR.AM2[bds.data.SR.AM2$PtID %in% bds.sr_pts, ]

# Create new dataframe for modelling decision weights on cumulative sleep lost.
bds.data.SR.csl2 <- distinct(bds.data.SR.csl, PtID, Condition, cumulativeSleepLost)
bds.data.SR.csl2$LBR_weight   <- NA
bds.data.SR.csl2$LLA_weight   <- NA
bds.data.SR.csl2$LBR_baseline <- NA
bds.data.SR.csl2$LLA_baseline <- NA
bds.data.SR.csl2$cumulativeSleepLost_h <- bds.data.SR.csl2$cumulativeSleepLost/60


# Loop through participants and calculate decision weights
for (pt in bds.sr_pts) {
  
  #SR model for each pt
  SR_model  <- glm(PtResp  ~ 1 + LogBaserate + LogLLA, data = bds.data.SR.csl[bds.data.SR.csl$PtID == pt & bds.data.SR.csl$Condition == 'SR', ] )
  SR_LogBR  <- coef(SR_model)['LogBaserate']
  SR_LogLLA <- coef(SR_model)['LogLLA']
  
  #WR model for each pt
  WR_model  <- glm(PtResp  ~ 1 + LogBaserate + LogLLA, data = bds.data.SR.csl[bds.data.SR.csl$PtID == pt & bds.data.SR.csl$Condition == 'WR', ] )
  WR_LogBR  <- coef(WR_model)['LogBaserate']
  WR_LogLLA <- coef(WR_model)['LogLLA']
  
  #Fill dataframe with weights
  bds.data.SR.csl2[bds.data.SR.csl2$PtID == pt & bds.data.SR.csl2$Condition == "SR", "LBR_weight"] <- SR_LogBR;
  bds.data.SR.csl2[bds.data.SR.csl2$PtID == pt & bds.data.SR.csl2$Condition == "SR", "LLA_weight"] <- SR_LogLLA;
  bds.data.SR.csl2[bds.data.SR.csl2$PtID == pt & bds.data.SR.csl2$Condition == "WR", "LBR_weight"] <- WR_LogBR;
  bds.data.SR.csl2[bds.data.SR.csl2$PtID == pt & bds.data.SR.csl2$Condition == "WR", "LLA_weight"] <- WR_LogLLA;
  bds.data.SR.csl2[bds.data.SR.csl2$PtID == pt & bds.data.SR.csl2$Condition == "SR", "LBR_baseline"] <- WR_LogBR;
  bds.data.SR.csl2[bds.data.SR.csl2$PtID == pt & bds.data.SR.csl2$Condition == "SR", "LLA_baseline"] <- WR_LogLLA;
  
}

# Build model of CSL predicting LBR/LLA weights, controlling for baseline weights
model.LBR_csl <- lm(LBR_weight ~ cumulativeSleepLost_h + LBR_baseline, data = bds.data.SR.csl2[bds.data.SR.csl2$Condition == 'SR',])
model.LLA_csl <- lm(LBR_weight ~ cumulativeSleepLost_h + LLA_baseline, data = bds.data.SR.csl2[bds.data.SR.csl2$Condition == 'SR',])

# Check collinearity
check_collinearity(model.LBR_csl)

# Check residuals
sim_output <- simulateResiduals(model.LBR_csl, plot = F); plotQQunif(sim_output); plotResiduals(sim_output)


# ----------------------------------------------------------------------------------
# The individual models predicting weights for each participants are problematic
# Residuals are not homogeneous, likely due to too few trials. 
# ----------------------------------------------------------------------------------
test <- glm(PtResp  ~ 1 + LogBaserate + LogLLA, data = bds.data.SR.csl[bds.data.SR.csl$PtID == 7 & bds.data.SR.csl$Condition == 'SR', ] )

## Show residual plots
sim_output <- simulateResiduals(test, plot = F); plotQQunif(sim_output); plotResiduals(sim_output)

# We also have a very restricted range of cumulative sleep lost data, where SD = 1.48h 
# Get mean & sd cumulative sleep lost
mean(na.omit(bds.data.SR.csl[bds.data.SR.csl$Condition=='SR',]$cumulativeSleepLost))/60
sd(na.omit(bds.data.SR.csl2$cumulativeSleepLost))/60
median(na.omit(bds.data.SR.csl2$cumulativeSleepLost))/60

       
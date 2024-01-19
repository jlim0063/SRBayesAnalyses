
# Correction from Reviewer Request - Drop Pt 9's WR data
m.test <- glmer(PtResp ~ 1 + Condition * LogBaserate + Condition * LogLLA + (1 |  PtID), 
                family = binomial("probit"), 
                data =nsf.data.exNB[!(PtID == 9 & Condition == "WR")])

# Req 1: NSF - Include only participants who completed both WR and SR/TSD--

nsf.pt_list.sleeploss  <- c(nsf.pt_list.SR, nsf.pt_list.TSD)
nsf.pt_list.w_complete <- nsf.pt_list.sleeploss [nsf.pt_list.sleeploss %in% unique(nsf.data.exNB[Condition=="WR", PtID])]

m.nsf.exNB.complete_pts <- glmer(PtResp ~ 1 + Condition * LogBaserate + Condition * LogLLA + (1 | PtID), 
                             family = binomial("probit"), 
                             data = nsf.data.exNB[PtID %in% nsf.pt_list.w_complete])
summary(m.nsf.exNB.complete_pts)

# Req 2: BDS - Include only participants who completed both WR and SR------

bds.pt_list.SR.AM <- bds.data.WRSR.AM.exNB[Condition == "SR", PtID] %>% unique()
bds.pt_list.SR.PM <- bds.data.WRSR.PM.exNB[Condition == "SR", PtID] %>% unique()

bds.pt_list.w_complete.AM <- bds.pt_list.SR.AM[bds.pt_list.SR.AM %in% unique(bds.data.WRSR.AM.exNB[Condition == "WR", PtID])]
bds.pt_list.w_complete.PM <- bds.pt_list.SR.PM[bds.pt_list.SR.PM %in% unique(bds.data.WRSR.PM.exNB[Condition == "WR", PtID])]

## These two models run into singularity issues.
m.bds.WRSR.AM.complete_pts <- glmer(PtResp ~ 1 + Condition * LogLLA + Condition * LogBaserate + (1 | PtID),
                                 family = binomial("probit"),
                                 data = bds.data.WRSR.AM.exNB[PtID %in% bds.pt_list.w_complete.AM])

m.bds.WRSR.PM.complete_pts <- glmer(PtResp ~ 1 + Condition * LogLLA + Condition * LogBaserate + (1 | PtID),
                                 family = binomial("probit"),
                                 data = bds.data.WRSR.PM.exNB[PtID %in% bds.pt_list.w_complete.PM])


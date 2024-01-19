require(data.table)
require(dplyr)
require(readxl)
require(here)

# NSF polysomnography -----------------------------------------------------

nsf.data.psg       <- as.data.table(read_excel(here('data', 'exp1_NSF_study_data', 'psg_data_nsf.xlsx')))

## Rewrite Subject_ID column to be inline with main behavioural data
nsf.data.psg$Subject_ID <- nsf.data.psg$Subject_ID %>% as.character()
nsf.data.psg[,PtID := substr(Subject_ID, 6, 7) %>% as.integer()]
nsf.data.psg[,Subject_ID := NULL]

## -Condition variable: 0=TSD; 1=SR
## - Night variable: 0=WR; 1=SR1; 2=SR2; 3=SR3; 4=SR4
nsf.data.psg[, assignedCondition := ifelse(condition == 1, "SR", "TSD")]
nsf.data.psg[, condition:=NULL]

nsf.data.psg[,condition := ifelse(
  Night %in% 1:4, "SR", "WR"
)]

## Filter out participants not in behavioural data
nsf.data.psg <- nsf.data.psg[PtID %in% nsf.pt_list]

## Find mean and SD TST for each condition. 
## No SD data for WR and TSD:
## - TSD: self-explanatory.
## - WR: There is only 1 WR night, because the first night in-lab was considered an adaptation night, 
##        so we did not use those data
nsf.psg.avg.tst <- nsf.data.psg[,.(mean(TST), sd(TST), mean(SE), sd(SE)), by = c('PtID', 'condition')]
names(nsf.psg.avg.tst)[names(nsf.psg.avg.tst) == c('V1', 'V2')] <- c("average_TST", "sd_TST")
names(nsf.psg.avg.tst)[names(nsf.psg.avg.tst) == c('V3', 'V4')] <- c("average_SE", "sd_SE")
nsf.psg.avg.tst[, average_TST_hrs := average_TST/60]

## Get mean SD statstics for NSF PSG data
nsf.psg.avg.tst[condition == "WR" , .(average_TST_hrs, average_SE)] %>% sjmisc::descr()
nsf.psg.avg.tst[condition == "SR" & PtID %in% nsf.pt_list.SR, .(average_TST_hrs, average_SE)] %>% sjmisc::descr()

## WR data for just SR assigned participants
nsf.psg.avg.tst[condition == "WR" & PtID %in% nsf.pt_list.SR, .(average_TST_hrs, average_SE)] %>% sjmisc::descr()
nsf.psg.avg.tst[condition == "WR" & PtID %in% nsf.pt_list.TSD, .(average_TST_hrs, average_SE)] %>% sjmisc::descr()



# NSF actigraphy ----------------------------------------------------------

nsf.data.actigraph <- as.data.table(read.csv(here('data', 'exp1_NSF_study_data', 'acti_data.csv')))

## Find valid participants from NSF
nsf.pt_list     <- nsf.data.exNB$PtID %>% unique() %>% sort()
nsf.pt_list.SR  <- nsf.data.SRpts$PtID %>% unique()
nsf.pt_list.TSD <- nsf.data.TSDpts$PtID %>% unique()

nsf.data.actigraph <- nsf.data.actigraph[ID %in% nsf.pt_list]
## Remove 7 and 8 WR data as they are erratic.
nsf.data.actigraph <- nsf.data.actigraph[!(ID %in% c(7, 8) & phase == "WR")]


## Get mean and sd total sleep times across participants during pre-WR (in hours)
nsf.data.acti.preWR <- nsf.data.actigraph[phase == "pre-WR"]
nsf.data.acti.preWR[, tst_mean_SE/60]   %>% sjmisc::descr()  
nsf.data.acti.preWR[ID %in% nsf.pt_list.SR, tst_mean_SE/60]   %>% sjmisc::descr() 
nsf.data.acti.preWR[ID %in% c(nsf.pt_list.TSD, 15), tst_mean_SE/60]   %>% sjmisc::descr() #Pt15 assigned TSD, but their TSD task data was invalid.
## Sleep efficiency
nsf.data.acti.preWR[, Sleep_Eff_mean]   %>% sjmisc::descr() 
nsf.data.acti.preWR[ID %in% nsf.pt_list.SR, Sleep_Eff_mean]   %>% sjmisc::descr() 
nsf.data.acti.preWR[ID %in% c(nsf.pt_list.TSD, 15), Sleep_Eff_mean]   %>% sjmisc::descr() 


## Get mean and sd total sleep times across participants during pre-SD (in hours)
nsf.data.acti.preSD <- nsf.data.actigraph[phase == "pre-SD"] 
nsf.data.acti.preSD[ID!=15, tst_mean_SE/60]   %>% sjmisc::descr() # dropping Pt15 since we don't use their TSD data 
nsf.data.acti.preSD[ID %in% nsf.pt_list.SR, tst_mean_SE/60]   %>% sjmisc::descr() 
nsf.data.acti.preSD[ID %in% nsf.pt_list.TSD, tst_mean_SE/60]   %>% sjmisc::descr() 
## Sleep efficiency
nsf.data.acti.preSD[ID!=15, Sleep_Eff_mean]   %>% sjmisc::descr() 
nsf.data.acti.preSD[ID %in% nsf.pt_list.SR, Sleep_Eff_mean]   %>% sjmisc::descr() 
nsf.data.acti.preSD[ID %in% nsf.pt_list.TSD, Sleep_Eff_mean]   %>% sjmisc::descr() 

## Get  mean and sd total sleep times across participants during WR (in hours)
nsf.data.acti.WR <- nsf.data.actigraph[phase == "WR"]
nsf.data.acti.WR[, tst_mean_SE/60]   %>% sjmisc::descr() 
nsf.data.acti.WR[ID %in% nsf.pt_list.SR, tst_mean_SE/60]   %>% sjmisc::descr() 
nsf.data.acti.WR[ID %in% nsf.pt_list.TSD, tst_mean_SE/60]   %>% sjmisc::descr() 
## Sleep efficiency
nsf.data.acti.WR[, Sleep_Eff_mean] %>% sjmisc::descr() 
nsf.data.acti.WR[ID %in% nsf.pt_list.SR, Sleep_Eff_mean]   %>% sjmisc::descr() 
nsf.data.acti.WR[ID %in% nsf.pt_list.TSD, Sleep_Eff_mean]   %>% sjmisc::descr() 

## Get  mean and sd total sleep times across participants during SR (in hours)
nsf.data.acti.SR <- nsf.data.actigraph[phase == "SD"]
nsf.data.acti.SR[, tst_mean_SE/60]   %>% sjmisc::descr() 
## Sleep efficiency
nsf.data.acti.SR[, Sleep_Eff_mean] %>% sjmisc::descr() 



## Get mean and SD of pre-SR sleep (hours) separately for SR participants
nsf.data.actigraph[ID %in% nsf.pt_list.SR & phase == "pre-WR", tst_mean_SE/60] %>% sjmisc::descr()
nsf.data.actigraph[ID %in% nsf.pt_list.SR & phase == "pre-SD", tst_mean_SE/60] %>% sjmisc::descr()


## Get mean and SD of pre-SD sleep (hours) separately for TSD and SR participants
nsf.data.actigraph[ID %in% nsf.pt_list.SR & phase == "pre-WR", tst_mean_SE/60] %>% sjmisc::descr()
nsf.data.actigraph[ID %in% nsf.pt_list.SR & phase == "pre-SD", tst_mean_SE/60] %>% sjmisc::descr()
nsf.data.actigraph[ID %in% nsf.pt_list.TSD & phase == "pre-WR", tst_mean_SE/60] %>% sjmisc::descr()
nsf.data.actigraph[ID %in% nsf.pt_list.TSD & phase == "pre-SD", tst_mean_SE/60] %>% sjmisc::descr()


# Get mean and SD of TST during WR lab stays
nsf.data.actigraph[phase == "WR", tst_mean_SE/60] %>% mean(na.rm = T)
nsf.data.actigraph[phase == "WR", tst_mean_SE/60] %>% sd(na.rm = T)
nsf.data.actigraph[phase == "WR", Sleep_Eff_mean] %>% mean(na.rm = T)
nsf.data.actigraph[phase == "WR", Sleep_Eff_mean] %>% sd(na.rm = T)

# Get mean and SD of TST during WR lab stays for SR-assigned participants
nsf.data.actigraph[phase == "WR" & ID %in% nsf.pt_list.SR, tst_mean_SE/60] %>% mean(na.rm = T)
nsf.data.actigraph[phase == "WR" & ID %in% nsf.pt_list.SR, tst_mean_SE/60] %>% sd(na.rm = T)
nsf.data.actigraph[phase == "WR" & ID %in% nsf.pt_list.SR, Sleep_Eff_mean] %>% mean(na.rm = T)
nsf.data.actigraph[phase == "WR" & ID %in% nsf.pt_list.SR, Sleep_Eff_mean] %>% sd(na.rm = T)

# Get mean and SD of TST during WR lab stays for TSD-assigned participants
nsf.data.actigraph[phase == "WR" & ID %in% c(nsf.pt_list.TSD, 15), tst_mean_SE/60] %>% mean(na.rm = T) #Pt15 assigned TSD, but their TSD task data was invalid.
nsf.data.actigraph[phase == "WR" & ID %in% c(nsf.pt_list.TSD, 15), tst_mean_SE/60] %>% sd(na.rm = T)
nsf.data.actigraph[phase == "WR" & ID %in% c(nsf.pt_list.TSD, 15), Sleep_Eff_mean] %>% mean(na.rm = T)
nsf.data.actigraph[phase == "WR" & ID %in% c(nsf.pt_list.TSD, 15), Sleep_Eff_mean] %>% sd(na.rm = T)


# Get mean and SD of TST during SR lab stays
nsf.data.actigraph[phase == "SD" & ID %in% nsf.pt_list.SR, tst_mean_SE/60] %>% mean(na.rm = T)
nsf.data.actigraph[phase == "SD" & ID %in% nsf.pt_list.SR, tst_mean_SE/60] %>% sd(na.rm = T)
nsf.data.actigraph[phase == "SD" & ID %in% nsf.pt_list.SR, Sleep_Eff_mean] %>% mean(na.rm = T)
nsf.data.actigraph[phase == "SD" & ID %in% nsf.pt_list.SR, Sleep_Eff_mean] %>% sd(na.rm = T)





# BDS polysomnography -----------------------------------------------------

bds.data.psg  <- as.data.table(read.csv(here('data', 'exp2_BDS_study_data', 'psg_data_bds.csv')))

## Fill in missing PtID values for BDS PSG data
for (row_x in 1:nrow(bds.data.psg)){
  if (bds.data.psg[row_x, "ParticipantID"] %>% as.character()!=""){
    pt_id <- bds.data.psg[row_x, "ParticipantID"] %>% as.character()
  } else {
    bds.data.psg[row_x, "ParticipantID"] <- pt_id
  }
}

  
## Recode participant id to integer values
bds.data.psg[,PtID := substr(ParticipantID, 2, 4) %>% as.integer()]  

## Drop CM conditions
bds.data.psg <- bds.data.psg[Condition!="CM"]

## Drop SR night 1, because these are baseline nights
bds.data.psg <- bds.data.psg[!(Condition=="SR" & Sleep.Period == 1)]

## Make list of BDS participants and filter out excluded pts
bds_pts <- bds.data.WRSR$PtID %>% unique() %>% as.character()


## Drop CM data
bds.data.psg <- bds.data.psg[!Condition == "CM"]
names(bds.data.psg)[names(bds.data.psg) == "X.SleepEfficiency"] <- "SE"

## Drop participants who aren't in the analysed data (i.e., ineligble)
bds.data.psg <- bds.data.psg[PtID %in% bds_pts]

## Get mean and SD statistics for BDS PSG data (Well-Rested Condition)
bds.data.psg.NC.avg <- bds.data.psg[Condition == "NC", .(mean(TST_Mins), sd(TST_Mins), mean(SE), sd(SE)), by = c("PtID", "Condition")]
names(bds.data.psg.NC.avg)[names(bds.data.psg.NC.avg) == c("V1", "V2")] <- c("mean_TST", "sd_TST")
names(bds.data.psg.NC.avg)[names(bds.data.psg.NC.avg) == c("V3", "V4")] <- c("mean_SE", "sd_SE")

bds.data.psg.NC.avg[Condition == "NC", .(mean(mean_TST), sd(mean_TST))]/60
bds.data.psg.NC.avg[Condition == "NC", .(mean(mean_SE), sd(mean_SE))]

## Get mean and SD statistics for BDS PSG data (Sleep Restriction Condition)
bds.data.psg.SR.avg <- bds.data.psg[Condition == "SR", .(mean(TST_Mins), sd(TST_Mins), mean(SE), sd(SE)), by = c("PtID", "Condition")]
names(bds.data.psg.SR.avg)[names(bds.data.psg.SR.avg) == c("V1", "V2")] <- c("mean_TST", "sd_TST")
names(bds.data.psg.SR.avg)[names(bds.data.psg.SR.avg) == c("V3", "V4")] <- c("mean_SE", "sd_SE")

bds.data.psg.SR.avg[Condition == "SR", .(mean(mean_TST), sd(mean_TST))]/60
bds.data.psg.SR.avg[Condition == "SR", .(mean(mean_SE), sd(mean_SE))]

  ## For only participants assigned to SR condition
  bds.data.psg.NC.avg[Condition == "NC" & PtID %in% bds.pt_list.SR.AM, .(mean(mean_TST), sd(mean_TST))]/60
  bds.data.psg.NC.avg[Condition == "NC" & PtID %in% bds.pt_list.SR.AM, .(mean(mean_SE), sd(mean_SE))]




# BDS actigraphy ----------------------------------------------------------

bds.data.acti <- as.data.table(read.csv(here::here("data", "exp2_BDS_study_data", "actigraphy.csv")))

## Remove "D" from ptID to match other bds datatables
bds.data.acti[, PtID:= as.integer(substr(PtID, 2, 4))]


## Write phase into bds.data.acti 
bds.data.acti[,phase:=as.character()]
for (pt_x in unique(bds.data.acti$PtID)){
    if (distinct(bds.data, PtID, NormalFirst)[PtID == pt_x, NormalFirst] == 1) {
      bds.data.acti[PtID == pt_x & week != 1, "phase"] <- "pre-SR"
      bds.data.acti[PtID == pt_x & week == 1, "phase"] <- "pre-WR"
    } else {
      bds.data.acti[PtID == pt_x & week == 1, "phase"] <- "pre-SR"
      bds.data.acti[PtID == pt_x & week != 1, "phase"] <- "pre-WR"
    }
}

## Change Pt 2's week 3 to "pre-CM"
bds.data.acti[PtID == 2 & week == 3, "phase"] <- "pre-CM"

## Change all CM pts' phase labelled "pre-SR" to "pre-CM"
bds.data.acti[!PtID %in% bds.pt_list.SR.AM & phase == "pre-SR", "phase"] <- "pre-CM"

## Get mean and SD TST across participants during pre-WR week (in hours)
bds.data.acti[phase == "pre-WR", TST_avg_hrs] %>% sjmisc::descr()
bds.data.acti[phase == "pre-WR", SE_avg]      %>% sjmisc::descr()

bds.data.acti[phase == "pre-SR", TST_avg_hrs] %>% sjmisc::descr()
bds.data.acti[phase == "pre-SR", SE_avg]      %>% sjmisc::descr()

## Get mean and SD statistics for participants who were assigned SR (in hours)
bds.data.acti[PtID %in% bds.pt_list.SR.AM & phase == "pre-WR", TST_avg_hrs] %>% sjmisc::descr()
bds.data.acti[PtID %in% bds.pt_list.SR.AM & phase == "pre-WR", SE_avg]      %>% sjmisc::descr()

# Sleep Restriction Impairs Integration of Multiple Information Sources in Probabilistic Decision-Making: Data Analyses

This repository contains the datasets and R working files used in the **{insert year}** paper, titled ***"Sleep Restriction Impairs Integration of Multiple Information Sources in Probabilistic Decision-Making"***, published in **{journal name}**. Here, we provide a brief overview of the analyses performed in this paper, as well as naming conventions used within the R project session. 

## **CONTENT**
1. [Performed Analyses](#1-performed-analyses)
    - 1.1 [Manipulation Checks](#11-manipulations-checks)
    - 1.2 [Trial Accuracy](#12-trial-accuracy)
    - 1.3 [Probit Modelling: Decision Weights](#13-probit-modelling-decision-weights)
2. [Naming conventions](#2-naming-conventions)
    - 2.1 [.R & .Rmd File-naming Conventions](#21-file-naming-conventions)
    - 2.2 [Dataframe-naming Conventions](#22-dataframe-naming-conventions)
    - 2.3 [Plot-naming Conventions](#23-plot-naming-conventions)
    - 2.4 [`lmer` & `glmer` Model-naming Conventions](#24-model-naming-conventions)
    - 2.5 [Specifiers](#25-specifiers)


---

The aim of the present paper was to investigate if Sleep Restriction (SR), had an effect on the ability of participants to integrate two distinct information sources on the Bayes Decisions Task, a probabilistic dual-choice decision-making task. Here, we lay out the set of analyses performed in each Experiment. 

### **Main scripts and data files**

The two files containing the codes for analyses reported in both papers are:
* Experiment 1: `scripts/01a_nsf_main.Rmd` 
* Experiment 2: `scripts/02a_bds_main.Rmd`

Datasets containing trial configuration and participant response data can be found within the respective `data_master.csv` files within each Experiment data sub-directory. OpenSesame files for the Bayes Decisions Task can be found in `materials` directory.

## 1. PERFORMED ANALYSES




### **1.1 Manipulations Checks**

The manipulation check serves to ensure that our manipulation of participants' sleep was strong enough to produce a noticeable effect. To achieve this, we used the Karolinska Sleepiness Scale as a measure of subjective sleepiness while participants were Well-Rested, and while they were under the effects of sleep loss.

The general equation for a manipulation check model is as follows:
$$ KSS = \alpha + \beta_1Condition + \epsilon $$
where:  
`KSS` = Scores on the Karolinska Sleepiness Scale  
`Condition` = Sleep Condition


The code included within each working file also shows the attempted data transformations. We decided to leave the KSS variables untransformed, as 1) this retained interpretability of KSS scores and 2) the data transformations did not alleviate skew/non-normality by much. 

In Experiment 1, as some participants were assgined to a Total Sleep Deprivation (TSD) condition, `Condition` has 3 levels, where the Well-Rested (WR) condition is used as the reference.

In Experiment 2, as there were two testing sessions (AM/PM), `SessionTime` was included in the model, as well as an interaction term between `SessionTime` and `Condition`. This allowed us to obtain further insight into whether there were any differences in subjective sleepiness between morning and evening testing sessions, within each `Condition`. 


### **1.2 Trial Accuracy**

Details of how we determined an accurate response for each trial are laid out in the paper's supplementary section. 

Briefly, the base logistic regression model is:

$$ IsCorrect = \alpha + \beta_1Condition + \beta_2Order + \epsilon $$

where:
* $IsCorrect$ is a dichotomous variable 1 if participant chose the "correct" response, and 0 otherwise
* $Condition$ represents the respective sleep conditions during which the trial was administered. This is a factored variable, where:
    * In Experiment 1, has 3 levels: WR, SR, TSD
    * In Experiment 2, has 2 levels: WR, SR
* $Order$ represents the $n^{th}$ time participant has been administered the Bayes Decisions Task.
    * In Experiment 1, there are 2 sessions.
    * In Experiment 2, because there are AM & PM sessions within each *Condition*, there are 4 sessions.

For Experiment 2, a $Session$ predictor and its interaction with $Condition$ were also added, to determine if trial accuracy differed between AM and PM sessions within each Condition. The interaction was not significant, and hence dropped from the results. 

### **1.3 Probit Modelling: Decision Weights**

Details of the probit model are included in the supplementary section. Briefly, the base model to determine the weights of each source of information contributing to the participants' response was: 

$$ Y_{it} = \alpha + \beta_1ln (\frac{P_L}{1-P_L}) + \beta_2lnLR(L)_t + \epsilon_{it}$$

where:
* $Y_{it}$ is a dichotomous variable denoting if participant $i$ chose the left box on trial $t$
* $ln (\frac{P_L}{1-P_L})$ represents the log Base Rate odds in favour of the left box on trial $t$
* $lnLR(L)_t$ represents the log likelihood in favour of the LEFT box (Evidence) on trial $t$
* Each $\beta$ represents weights placed on the corresponding information source during decision-making

For each experiment, we also included interactions of $Condition$ with each information term. This allows us to assess decision weight changes associated with SR or TSD.

All probit models were run using the `glmer` method from `lme4`. 

---

## 2. NAMING CONVENTIONS

The present paper reports results from two experiments. 

Experiment 1 was part of a wider study (acronym: NSF) supported by a grant from the National Science Foundation ([www.nsf.gov](www.nsf.gov); award #0729021 to Sean Drummond, David Dickinson). Experiment 2 was part of a wider study (acronym: BDS) that ran from 2018-2021, supported by a grant from the United States Office of Naval Research Global ([ONRG](https://www.nre.navy.mil/organization/onr-global/about-onr-global), award #N62909-17-1-2142 to SPAD/CA/DLD).

To distinguish between the two experiments, file names, as well as variable and model names within the R project had to be named accordingly. The naming conventions are as follows:
<br></br>

### **2.1 .R & .RMD FILE-NAMING CONVENTIONS**
.Rmd or .R files use the following naming template:
- `[numerator]_[studyAcronym]_[descrption]`

The numerator for any file involving analyses for Experiment 1 is `01`, and any for Experiment 2 is `02`.

To differentiate .R or .Rmd files corresponding to the same study, an alphabet identifier is also added after the numerator, starting from *a*. The name of every additional file uses the next letter in the alphabet sequence. E.g. `01a_nsf_main`; `01b_nsf_demographics`; etc. Files with prefix `01a` are always the "main" analysis file, where models investigating the primary aims of the study are embedded. 
<br></br>

### **2.2 DATAFRAME-NAMING CONVENTIONS**

For Experiment 1 (NSF study), all dataframe and tibble names are prefixed with `nsf.data`  
For Experiment 2 (BDS study), all dataframe and tibble names are prefixed with `bds.data`

All dataframe and tibble names adhere to the following format:  
`[prefix].[sleepCondition].[specifier1].[specifier2]...`   

For example, an Experiment 2 (BDS) dataframe containing ONLY sleep restriction (SR) trials from the morning session will be named `bds.data.SR.AM`. If a subset of `bds.data.SR.AM` was created to exclude e.g. "NoBrainer" trials, it can be named `bds.data.SR.AM.exNB` 

This would mean that the name of the master dataframe (from which subsets are derived) would simply involve the prefix. E.g., for Experiment 2: `bds.data`.  


### **2.3 PLOT-NAMING CONVENTIONS**

Plot objects use the following naming convention:  
`plot.[studyAcronym].[specifier1].[specifier2]...`  

The `plot` prefix denotes that the object is a plot objects, making it easily distinguishable from dataframe and tibble objects.
<br></br>

### **2.4 MODEL-NAMING CONVENTIONS**  
`lmer` and `glmer` models used in the analyses for the present study use the following naming convention:  
`m.[studyAcronym].[specifier1].[specifier2]...`

The `m` prefix denotes that the object is a model, making it easily distinguishable from dataframe and tibble objects. 

### **2.5 SPECIFIERS**

The following specifiers are common to analyses for both Experiments 1 and 2:  
* `KSS` - A manipulation check model, where subjective sleepiness scores are a function of sleep condition and other relevant variables.
* `ACC` - An accuracy check model, where participant choice of the more likely box is a function of sleep condition and other relevant 
variables
* `exNB` - Indicates the dataframe excludes *NoBrainer* trials (where Odds = 10/10 or 0/10)
* `DW` - Decision weights derived from probit model coefficients
* `WR`, `SR`, `TSD` (only for Exp. 1) and `CM` (only for Exp. 2) - Sleep condition specifiers  

---















   



# Sleep Restriction Impairs Integration of Multiple Information Sources in Probabilistic Decision-Making: Data Analyses

This repository contains the datasets and R working files used in the **{insert year}** paper, titled ***"Sleep Restriction Impairs Integration of Multiple Information Sources in Probabilistic Decision-Making"***, published in **{journal name}**. This README serves as a brief overview of the analyses performed in this paper, as well as naming conventions used within the R project session. 

## **CONTENT**
1. [Performed Analyses](#1-performed-analyses)
    - 1.1 [Manipulation Checks](#11-manipulations-checks)
    - 1.2 [Accuracy Checks](#12-accuracy-checks)
    - 1.3 [Probit Modelling: Decision Weights](#13-probit-modelling-decision-weights)
    - 1.4 [Standardised Relative Decision Weights](#14-standardised-relative-decision-weights)
2. [Naming conventions](#2-naming-conventions)
    - 2.1 [.R & .Rmd File-naming Conventions](#21-file-naming-conventions)
    - 2.2 [Dataframe-naming Conventions](#22-dataframe-naming-conventions)
    - 2.3 [Plot-naming Conventions](#23-plot-naming-conventions)
    - 2.4 [`lmer` & `glmer` Model-naming Conventions](#24-model-naming-conventions)
    - 2.5 [Specifiers](#25-specifiers)
3. [Glossary](#3-glossary)
    - 3.1 [File Names](#31-file-names)
    - 3.2 [Dataframe & Tibble Names](#32-dataframe--tibble-names)
    - 3.3 [Plot Names](#33-plot-names)
    - 3.4 [Model Names](#34-model-names)


---
## 1. Performed Analyses

### **1.1 Manipulations Checks**

### **1.2 Accuracy Checks**

### **1.3 Probit Modelling: Decision Weights**

### **1.4 Standardised Relative Decision Weights**
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

An alphabet identifier is also added after the numerator, starting from *a*. The name of every additional file uses the next letter in the alphabet sequence. E.g. `01a_nsf_main`; `01b_nsf_demographics`; etc. Files with prefix `01a` are always the "main" analysis file, where models investigating the primary aims of the study are embedded. 
<br></br>

### **2.2 DATAFRAME-NAMING CONVENTIONS**
For Experiment 1 (NSF study), all dataframe and tibble names are prefixed with `nsf.data`  
For Experiment 2 (BDS study), all dataframe and tibble names are prefixed with `bds.data`

All dataframe and tibble names adhere to the following format:  
`[prefix].[sleepCondition].[specifier1].[specifier2]...`   

For example, an Experiment 2 (BDS) dataframe containing ONLY sleep restriction (SR) trials from the morning session will be named `bds.data.SR.AM`. If a subset of `bds.data.SR.AM` was created to exclude e.g. "NoBrainer" trials, it can be named `bds.data.SR.AM.exNB` 

This would mean that the name of the master dataframe (from which subsets are derived) would simply involve the prefix. E.g., for Experiment 2: `bds.data`.  

#### **Temporary dataframes**

Temporary dataframes and tibbles serve as temporary containers for miscellaneous datasets (e.g. demographics). Instead of prefixes `nsf.data` or `bds.data`, these can be identified with the prefixes `nsf.temp` or `bds.temp`. 

Temporary dataframes and tibbles are almost always removed from the global environment at the end of the respective code blocks. Because they usually contain miscellaneous data that may not involve assignment to experimental conditions, the naming convention is as follows:  
`[prefix].[specifier1].[specifier2]...`
<br></br>

### **2.3 PLOT-NAMING CONVENTIONS**

Plot objects use the following naming convention:  
`plot.[studyAcronym][specifier1].[specifier2]...`  

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
* `RDW`  - Standardised Relative Decision Weights
* `WR`, `SR`, `TSD` (only for Exp. 1) and `CM` (only for Exp. 2) - Sleep condition specifiers  

---
## 3. GLOSSARY

### **3.1 FILE NAMES**
<br></br>

### **3.2 DATAFRAME & TIBBLE NAMES**
<br></br>

### **3.3 PLOT NAMES**
<br></br>

### **3.4 MODEL NAMES**
<br></br>


















   



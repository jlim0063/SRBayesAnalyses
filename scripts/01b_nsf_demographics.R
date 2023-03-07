# Final working dataframe is `nsf.data.b`
# Final model for probit regression on dataset ex. NoBrainers is `m.pool.b`


library(tibble)

# Build demographic only tibble from `nsf.data.b`
nsf.data.demographic <- as_tibble(nsf.data.b) 
nsf.data.demographic <- distinct(nsf.data.demographic, PtID, age, sex)

# Get table of female-male numbers
table(nsf.data.demographic$sex)



install.packages("rprime")

library(rprime)






#Read in Eprime text file
A<- read_eprime("RiskyGain9Aa_scan-001-214.txt")

#Extract and parse the log-frames from the file
B <- FrameList (A)

#Convert to data frame
DF <- to_data_frame(B)

#export as csv
write.csv(DF, "S:\\MNHS-SPP\\Circadia\\Projects\\Current projects\\Drummond_2018_ONRG_DecisionMaking\\Researchers\\Jeryl\\Lottery Choice Paper\\Converted CSV Data files\\RiskyGain9Aa-001-TSD-1-4.csv", row.names=TRUE)





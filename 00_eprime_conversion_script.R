# Install rprime package
#install.packages("rprime")

# R's equivalent of fstring, 'glue'
#install.packages('glue')


# Load rprime
library(rprime)
library(glue)
library(xlsx)


#Read in Eprime text file
filename <- ('Bayes19a_scan-001-123')

A <- read_eprime(glue("./data/NSF_study_data/raw_data/txt_files{filename}.txt"))

#Extract and parse the log-frames from the file
B <- FrameList (A)

#Convert to data frame
DF <- to_data_frame(B)


#export as csv
output_path <-  glue("./data/NSF_study_data/converted_data/{filename}.xlsx")

# Export file as xlsx
write.xlsx(DF, output_path)




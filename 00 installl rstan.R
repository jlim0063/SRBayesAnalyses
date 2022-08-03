# install rstan from repo

install.packages(c("StanHeaders","rstan"),type="source")

Sys.getenv("BINPREF")


writeLines('PATH="${RTOOLS42_HOME}\\usr\\bin;${PATH}"', con = "~/.Renviron")


Sys.which("make")

install.packages("jsonlite", type = "source")


file.path(Sys.getenv("HOME"), ".Rprofile")

# Install packages required for McElreath-Rethinking Statistics
install.packages(c("coda","mvtnorm","devtools","dagitty"))
install.packages("devtools", dependencies = TRUE)
library(devtools)

# Install cmdstanr
install.packages("cmdstanr", repos = c("https://mc-stan.org/r-packages/", getOption("repos")))

# Install Rethinking
devtools::install_github("rmcelreath/rethinking")

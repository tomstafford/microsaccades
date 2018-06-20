#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

# test if there is at least one argument: if not, return an error
if (length(args)==0) {
  stop("At least one argument must be supplied (input file).n", call.=FALSE)
}

# Thanks Nathalie!
# Passing arguments to an R script from command line
# http://tuxette.nathalievilla.org/?p=1696

#set up environment
source("MS_Toolbox_R/smoothdata.R")
source("MS_Toolbox_R/microsacc.R")
source("MS_Toolbox_R/vecvel.R")
source("MS_Toolbox_R/binsacc.R")

# Set parameters
SAMPLING = 500
MINDUR = 3
VFAC = 5


d <- read.csv(args[1],header=TRUE) #pull in data from file
#trialfile<-'DATA/0618post/0618post_trial3.csv'
#trialfile<-'DATA/0615pre/0615test_trial8.csv'
#d <- read.csv(trialfile,header=TRUE)
d$x1 <- as.numeric(d$x1)
d$x2 <- as.numeric(d$x2)
d$y1 <- as.numeric(d$y1)
d$y2 <- as.numeric(d$y2)

d <- as.matrix(d) 

# Select epoch from trial, transform to matrix
xl <- as.matrix(d[,1:2])
xr <- as.matrix(d[,3:4])

# Apply running average
xls <- smoothdata(xl)
xrs <- smoothdata(xr)

# Detection of microsaccades
msl <- microsacc(xl,VFAC,MINDUR,SAMPLING)
msr <- microsacc(xr,VFAC,MINDUR,SAMPLING)
sac <- binsacc(msl$table,msr$table)

# (Binocular) microsaccades
N <- sac$N[1]
bin <- sac$bin

print(paste(N))
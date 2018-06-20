#============================================================
# Function lagdist() -- Microsaccade Toolbox 0.9
# (R-language Version)
# Authors: Ralf Engbert, Petra Sinn, Konstantin Mergenthaler, 
# and Hans Trukenbrod
# Date: February 20th, 2014
#============================================================
#------------------------------------------------------------
# Time-lagged mean-square displacement estimator
# Engbert, R. & Kliegl, R. (2004) Microsaccades keep the eyes' 
# balance during fixation. Psychological Science, 15, 431-436.
#-------------------------------------------------------------

lagdist <- function(x) {
  N <- length(x[,1])
  maxlag <- round(N/4);
  x1 <- x
  x2 <- x
  r <- rep(0,maxlag)
  for ( lag in 1:maxlag ) {
    x1 <- x1[-1,]
    x2 <- x2[-length(x2[,1]),]
    d <-  x1 - x2
    r[lag] <- mean(d[,1]^2+d[,2]^2)
  }
  lag <- 1:maxlag
  rv <- t(rbind(lag,r))
  return(rv)
}

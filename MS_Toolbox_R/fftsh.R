#============================================================
# Function fftsh() -- Microsaccade Toolbox 0.9
# (R-language Version)
# Authors: Ralf Engbert, Petra Sinn, Konstantin Mergenthaler, 
# and Hans Trukenbrod
# Date: February 20th, 2014
#============================================================
#-------------------------------------------------
# Shift zero frequency to center
#-------------------------------------------------

fftsh <- function(x) {
  N <- length(x)
  n <- (N-1)/2
  xt <- c(x[(n+2):N],x[1:(n+1)])
  return(xt)
}
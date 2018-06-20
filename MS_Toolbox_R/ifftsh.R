#============================================================
# Function ifftsh() -- Microsaccade Toolbox 0.9
# (R-language Version)
# Authors: Ralf Engbert, Petra Sinn, Konstantin Mergenthaler, 
# and Hans Trukenbrod
# Date: February 20th, 2014
#============================================================
#-------------------------------------------------
# Inverse shift zero frequency to center
#-------------------------------------------------

ifftsh <- function(x) {
  N <- length(x)
  n <- (N-1)/2
  xt <- c(x[(n+1):N],x[1:n])
  return(xt)
}
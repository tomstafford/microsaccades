#============================================================
# Function surrogate() -- Microsaccade Toolbox 0.9
# (R-language Version)
# Authors: Ralf Engbert, Petra Sinn, Konstantin Mergenthaler, 
# and Hans Trukenbrod
# Date: February 20th, 2014
#============================================================
source("aaft.R")

surrogate <- function(x,SAMPLING=500) {
  x0 <- x[1,]
  v <- vecvel(x,SAMPLING=SAMPLING)
  vsx <- aaft(v[,1])/SAMPLING
  vsy <- aaft(v[,2])/SAMPLING
  vsx[1] <- vsx[1] + x0[1]
  vsy[1] <- vsy[1] + x0[2]
  xs <- cumsum(vsx)
  ys <- cumsum(vsy)
  xsur <- matrix(c(xs,ys),ncol=2,byrow=FALSE)
  return(xsur)
}

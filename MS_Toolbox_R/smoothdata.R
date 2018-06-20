#============================================================
# Function smoothdata() -- Microsaccade Toolbox 0.9
# (R-language Version)
# Authors: Ralf Engbert, Petra Sinn, Konstantin Mergenthaler, 
# and Hans Trukenbrod
# Date: February 20th, 2014
#============================================================
smoothdata <- function(x,TYPE=2) {
  x0 <- x[1,]
  v <- vecvel(x,SAMPLING=1,TYPE=TYPE)
  v[1,] <- v[1,] + x0
  xs <- matrix(c(cumsum(v[,1]),cumsum(v[,2])),ncol=2,byrow=FALSE)
}

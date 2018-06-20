#==============================================================
# Function boxcount() -- Microsaccade Toolbox 0.9
# (R-language Version)
# Authors: Ralf Engbert, Petra Sinn, Konstantin Mergenthaler, 
# and Hans Trukenbrod
# Date: February 20th, 2014
#==============================================================
#--------------------------------------------------------------
# Estimation of box-count measure for fixational eye movements
# Please cite: Engbert, R., & Mergenthaler, K. (2006). 
# Microsaccades are triggered by low retinal image slip. 
# Proceedings of the National Academy of Sciences of the United 
# States of America, 103, 7192-7197.
#--------------------------------------------------------------

boxcount <- function(xx,dx) {
  x <- xx[,1]
  y <- xx[,2]
  x_min <- min(x)
  y_min <- min(y)
  x_max <- max(x)
  y_max <- max(y)
  MX <- floor((x_max-x_min)/dx)+1
  MY <- floor((y_max-y_min)/dx)+1
  boxes <- matrix(rep(0,MX*MY),ncol=MY)
  M <- length(x)
  for  ( l in 1:M ) {
	i <- floor( (x[l]-x_min)/dx ) + 1
	j <- floor( (y[l]-y_min)/dx ) + 1
	boxes[i,j] <- boxes[i,j] + 1
  }
  d <- length(which(boxes>0))
  return(d)
}
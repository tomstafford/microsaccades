#============================================================
# Function aaft() -- Microsaccade Toolbox 0.9
# (R-language Version)
# Authors: Ralf Engbert, Petra Sinn, Konstantin Mergenthaler, 
# and Hans Trukenbrod
# Date: February 20th, 2014
#============================================================
#------------------------------------------------------------
# Amplitude-adjusted Fourier Transform (Theiler et al., 1992)
#------------------------------------------------------------
source("ftpr.R")

aaft <- function(x) {
  # adjust to uneven length
  N <- length(x)
  if ( floor(N/2)==N/2 ) {
    x <- x[1:(N-1)]
    N <- N-1
  }
  # AAFT algorithm
  # 1. Ranking
  h <- sort(x,index.return=TRUE)
  Sx <- h$x
  Rx <- h$ix
  # 2. Random Gaussian data
  g <- rnorm(N)
  # 3. Sort Gaussian data
  Sg <- sort(g)
  # 4. Rearrange Gaussian data
  y <- g
  y[Rx] = Sg
  # 5. Create phase-randomized surrogate
  y1 = ftpr(y)
  # 6. Ranked time series
  h <- sort(y1,index.return=TRUE)
  Ry1 <- h$ix
  # 7. AAFT surrogate time series
  xs <- x
  xs[Ry1] <- Sx;
  return(xs)
}
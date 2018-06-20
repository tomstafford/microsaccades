#============================================================
# Function ftpr() -- Microsaccade Toolbox 0.9
# (R-language Version)
# Authors: Ralf Engbert, Petra Sinn, Konstantin Mergenthaler, 
# and Hans Trukenbrod
# Date: February 20th, 2014
#============================================================
#------------------------------------------------------------
# Phase-randomized Fourier Transform (Theiler et al., 1992)
#------------------------------------------------------------
source("fftsh.R")
source("ifftsh.R")

ftpr <- function(x) {
  # adjust to uneven length
  N <- length(x)
  if ( floor(N/2)==N/2 ) {
    x <- x[1:(N-1)]
    N <- N-1
  }
  # subtraction of the mean
  x <- x-mean(x)
  # discrete fourier transform, shift zero frequency to center
  z0 <- fftsh(fft(x))
  # generate random vector of lenght (N-1)/2
  phi0 <- pi*(2*runif((N-1)/2)-1)
  # generate symmetrical random phase vector
  phi1 <- c(-phi0[((N-1)/2):1],0,phi0)
  # randomize the phase by the random phase vector 
  z1 <- z0*exp(1i*phi1)
  # inverse discrete fourier transform 
  xs <- fft(ifftsh(z1),inverse=TRUE)/N
  return(xs)
}

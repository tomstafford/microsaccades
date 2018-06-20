#============================================================
# Function binsacc() -- Microsaccade Toolbox 0.9
# (R-language Version)
# Authors: Ralf Engbert, Petra Sinn, Konstantin Mergenthaler, 
# and Hans Trukenbrod
# Date: February 20th, 2014
#============================================================
#  INPUT:
#  msl$table		monocular saccades left eye
#  msr$table		monocular saccades right eye  
#
#  OUTPUT:
#  sac$N[1:3]		      number of microsaccades (bin, monol, monor)
#  sac$bin[:,1:14]    binocular microsaccades (right eye/left eye)
#  sac$monol[:,1:7]   monocular microsaccades of the left eye
#  sac$monor[:,1:7]   monocular microsaccades of the right eye
#  Basic saccade parameters: (1) onset, (2) end, (3) peak velocity, 
#  (4) horizontal component, (5) vertical component, (6) horizontal 
#  amplitude, (7) vertical amplitude
#---------------------------------------------------------------------
binsacc <- function(sacl,sacr) {
  numr <- length(sacr[,1])
  numl <- length(sacl[,1])
  NB <- 0
  NR <- 0
  NL <- 0
  if ( numr*numl>0 )  {
    # Determine saccade clusters
    TR <- max(sacr[,2])
    TL <- max(sacl[,2])
    TB <- max(c(TL,TR))
    s <- rep(0,(TB+1))
    for  ( i in 1:dim(sacl)[1] ) {
      left <- sacl[i,1]:sacl[i,2]
      s[left] <- 1
    }
    for  ( i in 1:dim(sacr)[1] ) {
      right <- sacr[i,1]:sacr[i,2]
      s[right] <- 1
    }
    s[1] <- 0
    s[TB+1] <- 0
    
    # Find onsets and offsets of microsaccades
    onoff <- which(diff(s)!=0)
    m <- matrix(onoff,ncol=2,byrow=TRUE)
    N = dim(m)[1]
    
    # Determine binocular saccades
    bin <- NULL
    monol <- NULL
    monor <- NULL
    for ( i in 1:N ) {
      left  <- which( (m[i,1]<=sacl[,1]) & (sacl[,2]<=m[i,2]) )
      right <- which( (m[i,1]<=sacr[,1]) & (sacr[,2]<=m[i,2]) )
      # Binocular saccades
      if ( length(left)*length(right)>0 ) {
        ampr <- sqrt( (sacr[right,6])^2 + (sacr[right,7])^2 )
        ampl <- sqrt( (sacl[left,6])^2  + (sacl[left,7])^2 )
        # Determine largest event in each eye
        ir <- which.max(ampr)
        il <- which.max(ampl)
        NB <- NB + 1
        bin <- rbind(bin,c(sacl[left[il],],sacr[right[ir],]))
      } else {
        # Determine monocular saccades
        if ( length(left)==0 ) {
          NR <- NR + 1
          ampr <- sqrt( (sacr[right,6])^2 + (sacr[right,7])^2 )
          ir <- which.max(ampr)
          monor <- rbind(monor,sacr[right[ir],])
        }    
        if ( length(right)==0 ) {
          NL <- NL + 1
          ampl <- sqrt( (sacl[left,6])^2  + (sacl[left,7])^2 )
          il <- which.max(ampl)
          monol <- rbind(monol,sacl[left[il],])
        }
      }
    }  
  } else {
    # Special case of exclusively monocular saccades
    if ( numr==0 ) {
      bin <- NULL
      monor <- NULL
      monol <- sacl
    }
    if ( numl==0 ) {
      bin <- NULL
      monol <- NULL
      monor <- sacr
    }
  }
  sac <- list(N=c(NB,NL,NR),bin=bin,monol=monol,monor=monor)
  return(sac)
}
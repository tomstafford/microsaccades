#============================================================
# Function sacpar() -- Microsaccade Toolbox 0.9
# (R-language Version)
# Authors: Ralf Engbert, Petra Sinn, Konstantin Mergenthaler, 
# and Hans Trukenbrod
# Date: February 20th, 2014
#============================================================
#  INPUT: binocular saccade tables from FUNCTION binsacc.m
#  $sac[,1:14]   binocular microsaccades 
#
#  OUTPUT:
#  sac[,1:9]     parameters combined from left and right eye data
#  Basic saccade parameters: (1) onset, (2) end, (3) duration, 
#  (4) delay between eyes, (5) peak velocity, (6) distance, 
#  (7) orientation related to distance vector, (8) amplitude, 
#  (9) orientation related to amplitude vector
#------------------------------------------------------------------
sacpar <- function(sac) {
  M <- sac$N[1]
  if (M<1){sacs<-c() }
  else{  
    # 1. Onset
    a <- cbind(sac$bin[,1],sac$bin[,8])
    a_min <- c(rep(0,M))
    for (t in 1:length(a[,1])){
      a_min[t] <- min(a[t,])}
    a <- a_min
    
    # 2. Offset
    b <- cbind(sac$bin[,2],sac$bin[,9])
    b_min <-  c(rep(0,M))
    for (t in 1:length(b[,1])){
      b_min[t] <- min(b[t,])}
    b <- b_min
    
    # 3. Duration
    DR <- sac$bin[,2]-sac$bin[,1]+1
    DL <- sac$bin[,9]-sac$bin[,8]+1
    D <- (DR+DL)/2
    
    # 4. Delay between eyes
    delay <- b-a+1
    
    # 5. Peak velocity
    vpeak <- (sac$bin[,3]+sac$bin[,10])/2
    
    # 6. Saccade distance
    dist <- (sqrt(sac$bin[,4]^2+sac$bin[,5]^2)+sqrt(sac$bin[,11]^2+sac$bin[,12]^2))/2
    angle1 <- atan2((sac$bin[,5]+sac$bin[,12])/2,(sac$bin[,4]+sac$bin[,11])/2)
    
    # 7. Saccade amplitude
    ampl <- (sqrt(sac$bin[,6]^2+sac$bin[,7]^2)+sqrt(sac$bin[,13]^2+sac$bin[,14]^2))/2
    angle2 <- atan2((sac$bin[,7]+sac$bin[,14])/2,(sac$bin[,6]+sac$bin[,13])/2)
    
    sacs <- matrix(rep(0,M*9),ncol=9) 
    sacs[,1] <- a
    sacs[,2] <- b
    sacs[,3] <- D
    sacs[,4] <- delay
    sacs[,5] <- vpeak
    sacs[,6] <- dist
    sacs[,7] <- angle1
    sacs[,8] <- ampl
    sacs[,9] <- angle2  
  } 
  return(sacs)
}


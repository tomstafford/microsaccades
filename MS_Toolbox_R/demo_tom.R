#============================================================
# Demo file for the Microsaccade Toolbox
# (R-language Version 0.9)
# Authors: Ralf Engbert, Petra Sinn, Konstantin Mergenthaler, 
# and Hans A. Trukenbrod
# Date: February 20th, 2014
#============================================================
rm(list=ls())
setwd(".")
source("vecvel.R")
source("microsacc.R")
source("binsacc.R")
source("smoothdata.R")
source("surrogate.R")
source("lagdist.R")
source("boxcount.R")
source("sacpar.R")
par(ask = TRUE)

#------------------------------
# 1. Detection of microsaccades 
#------------------------------
# Set parameters
SAMPLING = 500
MINDUR = 3
VFAC = 5

# Read raw data (ASCII; subject 01, trial 005)
d1 <- read.table("data/f01.005.dat")
d <- read.csv("../singletrial.csv")

# Select epoch from trial, transform to matrix
xl <- as.matrix(d[,2:3])
xr <- as.matrix(d[,4:5])

# Apply running average
xls <- smoothdata(xl)
xrs <- smoothdata(xr)

# Detection of microsaccades
msl <- microsacc(xl,VFAC,MINDUR,SAMPLING)
msr <- microsacc(xr,VFAC,MINDUR,SAMPLING)
sac <- binsacc(msl$table,msr$table)

# (Binocular) microsaccades
N <- sac$N[1]
bin <- sac$bin

# Plot trajectory
par(mfrow=c(1,2))
plot(xls[,1],xls[,2],type='l',asp=1,
     xlab=expression(x[l]),ylab=expression(y[l]),
     main="Position")
for ( s in 1:N ) {
  j <- bin[s,1]:bin[s,2] 
  lines(xls[j,1],xls[j,2],type='l',col='red',lwd=3)
}
points(xls[bin[,2],1],xls[bin[,2],2],col='red')

# Plot trajectory in 2D velocity space
vls <- vecvel(xl,SAMPLING)
plot(vls[,1],vls[,2],type='l',asp=1,
     xlab=expression(v[x]),ylab=expression(v[y]),
     main="Velocity")
for ( s in 1:N ) {
  j <- bin[s,1]:bin[s,2] 
  lines(vls[j,1],vls[j,2],type='l',col='red',lwd=3)
}
phi <- seq(from=0,to=2*pi,length.out=300)
cx <- msl$radius[1]*cos(phi)
cy <- msl$radius[2]*sin(phi)
lines(cx,cy,lty=2)


#------------------------------------------
# 2. Plot main sequence for microsaccades
#------------------------------------------
par(mfrow=c(1,1))
# Set parameters
SAMPLING = 500
MINDUR = 3
VFAC = 5.5
ctab = c('red','blue','green','cyan','magenta')

N <- 0
for ( vp in 1:5 ) {
  for ( trial in 1:5 ) {
    
    # Read raw data (ASCII)
    filename <- sprintf("data/f%02i.%03i.dat",vp,trial)
    d <- read.table(filename)
    
    # Select epoch from trial, transform to matrix
    xl <- as.matrix(d[,2:3])
    xr <- as.matrix(d[,4:5])
    
    # Detection of microsaccades
    msl <- microsacc(xl,VFAC,MINDUR,SAMPLING)
    msr <- microsacc(xr,VFAC,MINDUR,SAMPLING)
    sac <- binsacc(msl$table,msr$table)
    tab <- sacpar(sac)
    N <- N + dim(tab)[1]
    if ( vp*trial==1 ) 
      plot(tab[,8],tab[,5],'p',cex=0.5,log='xy',col=ctab[1],
           xlab='Amplitude [deg]',ylab='Peak velocity [deg/s]',
           xlim=c(0.02,2),ylim=c(5,200))
    else 
      points(tab[,8],tab[,5],'p',cex=0.5,col=ctab[vp])
  }
}


#------------------------------------
# 3. Generation of surrogate data
#------------------------------------
# Read raw data (ASCII; subject 01, trial 005)
d <- read.table("data/f01.005.dat")
# Select epoch from trial, transform to matrix
idx <- 3001:4500
xl <- as.matrix(d[idx,2:3])
xr <- as.matrix(d[idx,4:5])
# Generation of surrogates
xls <- smoothdata(xl)
xlsur <- surrogate(xls)

# Plot original and surrogate trajectories
par(mfrow=c(1,2))
plot(xls[,1],xls[,2],type='l',main="Original data",xlab="x",ylab="y")
plot(xlsur[,1],xlsur[,2],type='l',col='red',main="AAFT surrogates",xlab="x",ylab="y")

# Plot acf of original trajectory and surrogate tracetory
vls <- vecvel(xls)
a1 <- acf(vls[,1],plot=FALSE)
par(mfrow=c(1,1))
plot(a1,type='l',main="Autocorrelation function")
for ( s in 1:20 )  {
  xlsur <- surrogate(xls)
  vlsur <- vecvel(xlsur,TYPE=2)
  a2 <- acf(vlsur[,1],plot=FALSE)
  lines(a2$lag,a2$acf,type='l',col='red')
}
lines(a1$lag,a1$acf,type='l',col='black')


#-------------------------------------------------
# 4. Surrogate analysis for different thresholds
#-------------------------------------------------
# range of detection thresholds
vfac = seq(from=3,to=8,by=0.5)

# subjects and trials
vp <- 1
ntrials <- 5

# read raw data
num = length(vfac)
mstab <- matrix(rep(0,3*num),ncol=3)
for ( v in 1:vp ) {
  for ( f in 1:ntrials ) {
    cat("... processing: vp =",v,", trial =",f,"\n")
    filename <- paste("data/f0",v,".00",f,".dat",sep="")
    d <- read.table(filename)
    # select epoch, transform to matrix
    xl <- as.matrix(d[,2:3])
    xr <- as.matrix(d[,4:5])
    dur <- dim(xr)[1]/SAMPLING
    for ( i in 1:num) {
      # detect microsaccades
      msl <- microsacc(xl,VFAC=vfac[i])
      msr <- microsacc(xr,VFAC=vfac[i])
      sac <- binsacc(msl$table,msr$table)
      N <- sac$N[1]/dur
      # computation of surrogate data
      xsl <- surrogate(xl)
      xsr <- surrogate(xr)
      msl <- microsacc(xsl,VFAC=vfac[i])
      msr <- microsacc(xsr,VFAC=vfac[i])
      sac <- binsacc(msl$table,msr$table)
      Nsur <- sac$N[1]/dur
      mstab[i,1] <- vfac[i]
      mstab[i,2:3] <- mstab[i,2:3] + c(N,Nsur)
    }
  }
}
mstab[,2:3] <- mstab[,2:3]/(vp*ntrials)

# Plot surrogate analysis
par(mfrow=c(1,1))
plot(mstab[,1],mstab[,2],type='b',ylim=c(0,3),
     xlab=expression("Threshold multiplier  "*lambda),
     ylab="Rate [1/s]",
     main="Surrogate analysis")
lines(mstab[,1],mstab[,3],type='b',col='red')
lines(mstab[,1],mstab[,2]-mstab[,3],type='b',col='blue')
legend(6,3,c('original data','surrogates','difference'),
       lty=c(1,1,1),pch=c(1,1,1),col=c('black','red','blue'))


#-------------------------------------------------
# 5. Random walk analysis
#-------------------------------------------------
d <- read.table("data/f03.002.dat")
xl <- as.matrix(d[,2:3])
xr <- as.matrix(d[,4:5])

# Perform lagged distance analysis 
rvl <- lagdist(xl)
vl <- diff(xl)

# Perform random shuffling
vls <- cbind(sample(vl[,1]),sample(vl[,2]))
rxls <- cbind(cumsum(vls[,1]),cumsum(vls[,2]))
rvls <- lagdist(rxls)

# Plot results
par(mfrow=c(1,1))
plot(rvl,type='l',main="Random walk analysis",
     xlab="lag",ylab="D(lag)",log='xy')
lines(rvls,type='l',col='red')


#-------------------------------------------------
# 6. Box-count analysis
#-------------------------------------------------
dx <- 0.01
dt <- 100
msl <-  microsacc(xls)

# Calculate box-count for drift epochs
xx <- xls[(msl$table[1,1]-dt):(msl$table[1,1]-1),]
boxes <- boxcount(xx,dx)

# Plot results
par(mfrow=c(1,1))
plot(xx[,1],xx[,2],type='l',main="Box-count",xlab="x[deg]",ylab="y[deg]")
x_min <- min(xx[,1])
y_min <- min(xx[,2])
M <- length(xx[,1])
for  ( l in 1:M ) {
  i <- floor( (xx[l,1]-x_min)/dx ) + 1
  j <- floor( (xx[l,2]-y_min)/dx ) + 1
  a <- x_min+i*dx
  b <- y_min+j*dx
  lines(c(a-dx,a),c(b,b),type='l',col='green')
  lines(c(a-dx,a),c(b-dx,b-dx),type='l',col='green')
  lines(c(a-dx,a-dx),c(b-dx,b),type='l',col='green')
  lines(c(a,a),c(b-dx,b),type='l',col='green')
}

# EOF



## getData function ---------------------------------------------
## Extracts the area data for a particular compound/transition
## and all the samples from targetlynx. Outputs a vector (areaVec) with 
## the areas for all of the samples, where the numbers in the vector
## are named with the sample they correspond to.

## data is the targetlynx data for all the samples but only one compound/transition
## nSamples is the number of Samples in the data
getData <- function(data, nSamples,param){     
     Vec <- rep(NA,nSamples)
     names(Vec) <- data[,"Name"]
     for(i in 1:nSamples){
          Vec[i] <- data[i,param]
     }
     Vec
}

## getRT function ---------------------------------------
## same as getAreas but for RTs

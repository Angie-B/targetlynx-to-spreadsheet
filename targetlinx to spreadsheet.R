## This program imports as CSV that has the raw targetlinx output
## and converts it to a more friendly format of a series of 2D spreadsheets
## with compounds/transitions as columns and samples as rows.

## Set up -----------------------------------------------
## THESE ARE THE THINGS YOU MIGHT WANT TO CHANGE:

## set the working directory - make sure it has a csv with your data in it
## you should set the name of the data you want converted as "file"
## you also should make sure the working directory has the getAreas.R 
## function in it.
## The other things that you might want to change are at the very bottom,
## the output filenames, which just defaults to
## "Areas", "RTs" and "Height_Area"

setwd("C:/Users/Angela/Documents/2014 Summer lab work/target linx output modifying program")
source("getAreas.R")
filename <- "targetlinx_output.csv"

## Reading in the targetlinx data --------------------------------------
unmodified <- read.csv(filename ,header=FALSE, comment.char="", as.is=TRUE)
names(unmodified) <- unmodified[7,]

## Determine the number of samples --------------------------------
unmodified[,2] <- as.numeric(unmodified[,2])
rowCount <- 1
nSamples <- 0
lastRow <- NA
for(i in 1:length(unmodified[,2])){
     if(is.na(lastRow)) {
          thisRow <- unmodified[rowCount,2]
          rowCount <- rowCount + 1
          lastRow <- thisRow
     } else {
          nSamples <- nSamples + 1
          thisRow <- unmodified[rowCount,2]
          if (is.na(thisRow)) break
          lastRow <- thisRow
          rowCount <- rowCount + 1
     }
}

## Get the data for all compounds ------------------------------------
## initiate our search for compounds at row 1
row <- 1
## initiate our compound names list and our matrix of areas
names <- c()
areaMatrix <- c()
RTMatrix <- c()
ratioMatrix <- c()
## search through the unmodified output for compounds
while(row < nrow(unmodified)) {
     ## If we find a compound do this:
     if (substr(unmodified[row,1],start=1,stop=8) == "Compound") {
          ## EXTRACT THE AREA DATA FOR THAT COMPOUND
          data <- unmodified[(row+3):(row+nSamples+2),1:ncol(unmodified)]
          areas <- getData(data, nSamples,"Area")
          RTs <- getData(data, nSamples, "RT")
          ratio <- getData(data, nSamples, "Height/Area")
          
          ## Update the compound names list 
          name <- unmodified[row,1]
          names <- c(names,name)
 
          ## Save that compound's data as a new row in the matrix 
          areaMatrix <- cbind(areaMatrix, areas)
          RTMatrix <- cbind(RTMatrix, RTs)
          ratioMatrix <- cbind(ratioMatrix, ratio)
          
          ## Now keep looking for other compounds
          row <- row + nSamples + 2
     } else {
          ## If we don't find a compound, keep looking in the next row
          row <- row+1
     }
}

#Set the row column names of the matrix to be the names of the samples
colnames(areaMatrix) <- names
colnames(RTMatrix) <- names
colnames(ratioMatrix) <- names

## Write the areas spreadsheet to a csv ---------------------------
write.csv(areaMatrix, file = "Areas.csv")
write.csv(RTMatrix, file = "RTs.csv")
write.csv(ratioMatrix, file = "Height_Area.csv")


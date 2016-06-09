rm(list = ls())
dirname = getSrcDirectory(function(x) {x})
setwd(dirname)
library(forecast)
library(deepnet)
library(RSNNS)
source("databaseconnection.R")

open = 1
close = 2
high = 3
low = 4

typelist = c(open, close, high, low)
minuteslist = c(1)
blocklist = c(60,80,100,120)
omega = 1
mi = 0.2
pteste = 0.3
rangelist = c(1000)
ntests = 10

nrows = length(typelist)*length(minuteslist)*length(blocklist)*length(rangelist)*ntests
ncols = 1+1+1+1+1+2
resultsResume = matrix(0,nrow=nrows,ncol=ncols)
colnames(resultsResume) = c("Test","Type","Range","Minutes","Block","RMSE",
                            "MAE")

iterator = 1
totalErrorsMeans = matrix(0,nrow=nrows/ntests,ncol=2)
errorIterator = 1
for(type in typelist){
  typestring = switch(type,
                      open = "Open",
                      close = "Close",
                      high = "High",
                      low = "Low")
  for(block in blocklist){
    hiddenlayers = c(block/2,block/2)
    for(minutes in minuteslist){
      for(range in rangelist){
        errorsMeans = rep(0,2)
        for(test in 1:ntests){
          title = paste("Test ",test,", ",typestring," Data, Range ",range,", Minutes ",minutes,", Block ",block,sep="")
          details = list(col=c(2,1),main=title)
          source("forecast.R")
          errors = accuracy(forecastvalues,targets)
          if(test==1){
            errorsMeans = as.vector(errors[2:3])
          }else{
            errorsMeans = rbind(errorsMeans,as.vector(errors[2:3]))
          }
          auxfilename=paste(getwd(),"/Results/",title,".png",sep="")
          png(filename=auxfilename)
          ts.plot(forecastvalues,targets,gpars=details)
          dev.off()
          resultsResume[iterator,1] = test
          resultsResume[iterator,2] = type
          resultsResume[iterator,3] = range
          resultsResume[iterator,4] = minutes
          resultsResume[iterator,5] = block
          resultsResume[iterator,6:7] = errors[2:3]
          iterator=iterator+1
        }
        cat(title,"\n")
        errorsMeans = colMeans(errorsMeans)
        print(errorsMeans)
        totalErrorsMeans[errorIterator,] = errorsMeans
        errorIterator = errorIterator+1
      }
    }
  }
}
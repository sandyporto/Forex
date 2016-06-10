rm(list = ls())
dirname = getSrcDirectory(function(x) {x})
setwd(dirname)
library(forecast)
library(deepnet)
library(RSNNS)
source("databaseconnection.R")
dirimages = paste(getwd(),"/Results/*",sep="")
unlink(dirimages)

open = 1
close = 2
high = 3
low = 4

variacaonula = c(0,0.001)
variacaomormal = c(0.001,0.003)
variacaomedia = c(0.003,0.1)
variacaoalta = c(0.1,+Inf)


typelist = c(open, close, high, low)
minuteslist = c(1,5,15,30,60)
blocklist = c(20,60,100,140)
omega = 1
mi = 0.2
pteste = 0.05
rangelist = c(500,1000,2000)
ntests = 10

nrows = length(typelist)*length(minuteslist)*length(blocklist)*length(rangelist)
ncols = 1+1+1+1+2
resultsResume = matrix(0,nrow=nrows,ncol=ncols)
colnames(resultsResume) = c("Type","Range","Minutes","Block","RMSE",
                            "MAE")

iterator = 1
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
        title = paste(typestring," Data, Range ",range,", Minutes ",minutes,", Block ",block,sep="")
        details = list(col=c(2,1),main=title)
        for(test in 1:ntests){
          source("forecast.R")
          errors = accuracy(forecastvalues,targets)
          if(test==1){
            errorsMeans = as.vector(errors[2:3])
          }else{
            errorsMeans = rbind(errorsMeans,as.vector(errors[2:3]))
          }
          auxfilename=paste(getwd(),"/Results/",title,", ",toString(test),".png",sep="")
          png(filename=auxfilename)
          ts.plot(forecastvalues,targets,gpars=details)
          dev.off()
          
        }
        cat(title,"\n")
        errorsMeans = colMeans(errorsMeans)
        print(errorsMeans)
        resultsResume[iterator,1] = type
        resultsResume[iterator,2] = range
        resultsResume[iterator,3] = minutes
        resultsResume[iterator,4] = block
        resultsResume[iterator,5:6] = errorsMeans
        iterator=iterator+1
      }
    }
  }
}
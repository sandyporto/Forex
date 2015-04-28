library(RSNNS)
library(graphics)

pasta <- "C:\\Users\\Sandy Porto\\Desktop\\LiveMesh\\Mestrado\\Mineração de Dados\\Projeto Disciplina\\"

open = 1
names(open) <- "Open"
close = 2
names(close) <- "Close"
high = 3
names(high) <- "High"
low = 4
names(low) <- "Low"


erro <- function(x1,x2){
  return((x1-x2)^2)
}



lendoDados <- function(minutos,tipo,intervalo){
  nomefile = paste(pasta,"bd",toString(minutos),".csv",sep="")
  
  dados = read.csv(nomefile,header=F,sep=";")
  
  if (intervalo == -1){
    intervalo = nrow(dados)
  }
  
  resposta = as.ts(rev(dados[1:intervalo,tipo]))
  
  return (resposta)
  
}

sampled <- function(t,intervalo){
  n = length(t)
  linhas = n-(intervalo)
  
  s = matrix(rep(0,linhas*(intervalo+1)),linhas)
  
  for (i in 1:linhas){
    s[i,] = t[i:(i+intervalo)]
  }
  return(s)
}

ci <- function(t,w,mi){
  if (t < w){
    return (0)
  }else{
    r = choose(t,w)*((1-mi)^(w+1))*(mi^(t-w))
    return (r)
  }
}

gammaMemory <- function(dados,w,mi){
  linhas = nrow(dados)
  colunas = ncol(dados)-1
  for (i in 1:linhas){
    for (j in 1:colunas){
      dados[i,j] = dados[i,j]*ci(colunas-j+1,w,mi)
    }
  }
  return (dados)
}

# library(RODBC)
# 
# banco = "MySQL MT5"
# login = "mt5"
# senha = "mt5mt5mt5"
# 
# ch = odbcConnect(banco,login,senha)
# 
# query = "select * from doleta"
# 
# dados = sqlQuery(ch,query)
# 
# print(dados[nrow(dados)*0.1,])
# 
# 
# 
# 
# odbcClose(ch)

loadData <- function(minutos = 1, dir = "/DadosColetados/"){
  filename = paste(getwd(),dir,"bd",toString(minutos),".csv",sep="")
  data = read.csv(filename,header=F,sep=";",dec=".")
  return(data)
}

make.ts <- function(data,tipo,range=nrow(data)){
  return(as.ts(rev(data[1:range,tipo])))
}

sample.ts <- function(ts,block){
  sizets = length(ts)
  nlines = sizets-block
  s.ts = matrix(nrow = nlines, ncol = block+1)
  for(i in 1:nlines){
    s.ts[i,] = ts[i:(i+block)]
  }
  s.ts = s.ts[sample.int(nrow(s.ts)),]
  return(s.ts)
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





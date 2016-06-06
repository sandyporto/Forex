pasta = getwd()
setwd(pasta)
library(RODBC)

banco = "MySQL MT5"
login = "mt5"
senha = "mt5mt5mt5"

ch = odbcConnect(banco,login,senha)

query = "select * from doleta"

dados = sqlQuery(ch,query)

print(dados[nrow(dados)*0.1,])




odbcClose(ch)
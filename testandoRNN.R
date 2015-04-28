# #Parametros
# intervalo = 500
# minutos = 60
# janelas = 10
# escondidos = 10
# pteste = 0.3
# rede = "Jordan"
# iteracoes = 1000
# tipo = open
# gamma = T
# omega = 3
# mi = 0.6
# 
# #Chamando a função
# source('C:/Users/Sandy Porto/Desktop/LiveMesh/Mestrado/Mineração de Dados/Projeto Disciplina/RNN.R')
#                   

observacoesLista = c(1000,2000)
minutosLista = c(1,5,15,30,60)
janelasLista = c(20)
neuroniosLista = c(12)
pteste = 0.3
redeLista = c("Elman")
iteracoes = 1000
tipoLista = c(open,close,high,low)
gammaLista = c(T)
omegaLista = c(1)
miLista = c(0.2)
testes = 10


erroMedio = c()
for (obs in 1:length(observacoesLista)){
  for (min in 1:length(minutosLista)){
    for (t in 1:length(tipoLista)){
      intervalo = observacoesLista[obs]
      minutos = minutosLista[min]
      janelas = janelasLista[1]
      escondidos = neuroniosLista[1]
      pteste = 0.3
      rede = redeLista[1]
      iteracoes = 1000
      tipo = tipoLista[t]
      gamma = gammaLista[1]
      omega = omegaLista[1]
      mi = miLista[1]
      
      resultados = matrix(rep(0,testes*pteste*intervalo),testes)
      
      
      for (teste in 1:testes){
        source('C:/Users/Sandy Porto/Desktop/LiveMesh/Mestrado/Mineração de Dados/Projeto Disciplina/RNN.R')
        resultados[teste,1:length(dadosPreditos)] = dadosPreditos
      }
      
      resultadosMedios = erros = rep(0,length(dadosPreditos))
      for (ir in 1:length(resultadosMedios)){
        resultadosMedios[ir] = mean(resultados[,ir])
        erros[ir] = erro(resultadosMedios[ir],dadosTestados[ir])
      }
      
      erroMedio = c(erroMedio,mean(erros))
      
      titulo = paste(names(tipo), " Data, ",intervalo," Observações, ",minutos," Minutos",sep="")
      detalhes = list(col=c("blue","red"),main=titulo,xlab="Tempo",ylab="Preço")
      
      nomearq = paste(pasta,"imagensResultados\\","Int",intervalo,",Min",minutos,",Janelas",janelas,
                      ",N",escondidos,",Rede",rede,",Tipo",names(tipo),
                      ",G",gamma,",Omega",omega,",mi",mi,",Teste",teste,".jpeg",sep="")
      jpeg(filename = nomearq)
      ts.plot(as.ts(dadosTestados),as.ts(resultadosMedios[1:length(dadosTestados)]),gpars=detalhes)
      dev.off()
      
    }
  }
}


# 
# 
# for (int in 1:length(intervaloLista)){
#   for (min in 1:length(minutosLista)){
#     for (jan in 1:length(janelasLista)){
#       for (r in 1:length(redeLista)){
#         for (t in 1:length(tipoLista)){
#           for (g in 1:length(gammaLista)){
#             intervalo = intervaloLista[int]
#             minutos = minutosLista[min]
#             janelas = janelasLista[jan]
#             pteste = 0.3
#             rede = redeLista[r]
#             iteracoes = 10000
#             tipo = tipoLista[t]
#             gamma = gammaLista[g]
#             if (gamma == T){
#               for (m in 1:length(miLista)){
#                 for (o in 1:length(omegaLista)){
#                   for (neu in 1:length(neuroniosLista)){
#                     for (teste in 1:testes){
#                       escondidos = neuroniosLista[neu]
#                       omega = omegaLista[o]
#                       mi = miLista[m]
#                       #Chamando a função
#                       source('C:/Users/Sandy Porto/Desktop/LiveMesh/Mestrado/Mineração de Dados/Projeto Disciplina/RNN.R')
#                     }
#                   }
#                   
#                 } 
#               }
#             }else{
#               for (teste in 1:testes){
#                 #Chamando a função
#                 source('C:/Users/Sandy Porto/Desktop/LiveMesh/Mestrado/Mineração de Dados/Projeto Disciplina/RNN.R')
#               }
#             }
#             
#           }
#         }
#         txt = paste("Int",intervalo,",Min",minutos,",Janelas",janelas,
#                     ",N",escondidos,",Rede",rede,",Tipo",names(tipo),
#                     ",G",gamma,",Omega",omega,",mi",mi,",Teste",teste,sep="")
#         print(txt,quote=F)
#       }
#     }
#   }
# }
# 

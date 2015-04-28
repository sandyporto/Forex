
dados <- lendoDados(minutos,tipo,intervalo)

dados <- sampled(dados,janelas)


dadosNorm <- normalizeData(dados,type="norm")

if (gamma){
  dadosNorm <- gammaMemory(dadosNorm,omega,mi)
}

dadosRede <- splitForTrainingAndTest(dadosNorm[,1:janelas],dadosNorm[,janelas+1],ratio = pteste)

if (rede=="Elman"){
  model <- elman(dadosRede$inputsTrain,dadosRede$targetsTrain,size=escondidos,maxit = iteracoes,
                 inputsTest = dadosRede$inputsTest,targetsTest=dadosRede$targetsTest)
}else{
  if (rede == "Jordan"){
    model <- jordan(dadosRede$inputsTrain,dadosRede$targetsTrain,size=escondidos,maxit = iteracoes,
                   inputsTest = dadosRede$inputsTest,targetsTest=dadosRede$targetsTest) 
  }
}

dadosTestados <- denormalizeData(dadosRede$targetsTest,getNormParameters(dadosNorm))
dadosPreditos <- denormalizeData(model$fittedTestValues,getNormParameters(dadosNorm))


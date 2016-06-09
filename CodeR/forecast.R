



data = loadData(minutes)
ts = make.ts(data,type,range)
data = sample.ts(ts,block)

dataNorm = normalizeData(data,type="norm")
dataNormGM = gammaMemory(dataNorm,omega,mi)

dataSplit = splitForTrainingAndTest(dataNormGM[,1:block],dataNormGM[,block+1],ratio=pteste)

dnn = dbn.dnn.train(x = dataSplit$inputsTrain,
                    y = dataSplit$targetsTrain,
                    hidden = hiddenlayers,
                    hidden_dropout = 0.5)

predict = nn.predict(dnn,dataSplit$inputsTest)

targets = as.ts(denormalizeData(dataSplit$targetsTest,getNormParameters(dataNorm)))
forecastvalues = as.ts(denormalizeData(predict,getNormParameters(dataNorm)))

# targets = as.ts(dataSplit$targetsTest)
# forecastvalues = as.ts(predict)






data = loadData(minutes)
ts = make.ts(data,type,range)
data = sample.ts(ts,block)

dataNorm = normalizeData(data, type="norm")


dataSplit = splitForTrainingAndTest(dataNorm[,1:block],dataNorm[,block+1],ratio=pteste)

dataSplit$inputsTrain = gammaMemory(dataSplit$inputsTrain,omega,mi)
auxrandom = sample.int(nrow(dataSplit$inputsTrain))
dataSplit$inputsTrain = dataSplit$inputsTrain[auxrandom,]
dataSplit$targetsTrain = dataSplit$targetsTrain[auxrandom]

dnn = dbn.dnn.train(x = dataSplit$inputsTrain,
                    y = dataSplit$targetsTrain,
                    hidden = hiddenlayers,
                    hidden_dropout = 0.5)

dataSplit$inputsTest = gammaMemory(dataSplit$inputsTest,omega,mi)

predict = nn.predict(dnn,dataSplit$inputsTest)

targets = denormalizeData(dataSplit$targetsTest,getNormParameters(dataNorm))
targets = as.ts(targets)
forecastvalues = denormalizeData(predict,getNormParameters(dataNorm))
forecastvalues = as.ts(forecastvalues)

# targets = as.ts(dataSplit$targetsTest)
# forecastvalues = as.ts(predict)


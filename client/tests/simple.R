library("ParamHelpers")
devtools::load_all()

data = data.frame(x = c(5,10), y = c(20,30))
par.set = makeNumericParamSet(len = 2)

obj = mboServiceConnect("http://localhost:5000")  
mboServiceSetConfigKey(obj, par.set = par.set)
mboServiceUpload(obj, data)

point = mboServicePropose(obj)
print(point)

mboServiceDisconnect(obj)

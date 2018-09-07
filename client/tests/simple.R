library("ParamHelpers")
devtools::load_all()

data = data.frame(x1 = c(1,1,0,0), x2 = c(1,0,1,0), y = c(0,0,1,1))
par.set = makeNumericParamSet(len = 2, lower = c(0,0), upper = c(1,1))

obj = mboServiceConnect("http://localhost:5000")  
mboServiceSetConfigKey(obj, par.set = par.set)
mboServiceUpload(obj, data)

point = mboServicePropose(obj)
print(point)

mboServiceDisconnect(obj)

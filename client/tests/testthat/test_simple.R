library("ParamHelpers")
library("testthat")

data = data.frame(x1 = c(1,1,0,0), x2 = c(1,0,1,0), y = c(0,0,1,1))
par.set = makeNumericParamSet(len = 2, lower = c(0,0), upper = c(1,1))

# connect to service
obj = mboServiceConnect("http://rombie.de:5000")    # <- This is our debugging server.
#obj = mboServiceConnect("http://localhost:5000")   # <- This is your local server.

# upload parameter set
mboServiceSetConfigKey(obj, par.set = par.set, crit = "ei")

# upload data
mboServiceUpload(obj, data)

# request point proposal
point = mboServicePropose(obj)
print(point)

expect_length(point, 2)

# "eval" the proposed point
y = 0
r = append(point, y)
r = data.frame(r)
names(r) = names(data)

# upload new data
mboServiceUpload(obj, r)

# request new point
point = mboServicePropose(obj)
print(point)

expect_length(point, 2)

mboServiceDisconnect(obj)

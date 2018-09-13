library("ParamHelpers")
library("testthat")

test_func = function(x) {
  sum((x - c(4,4))^2)
}

n_size = 10
par.set = makeNumericParamSet(len = 2, lower = c(-5,-5), upper = c(5,5))
data = generateDesign(n = n_size, par.set)
Y = apply(data, 1, test_func)
data = data.frame(data, y = Y)

# connect to service
#obj = mboServiceConnect("http://rombie.de:5000")    # <- This is our debugging server.
obj = mboServiceConnect("http://localhost:5000")   # <- This is your local server.

# upload parameter set
mboServiceSetConfigKey(obj, par.set = par.set, crit = "ei")

# upload data
mboServiceUpload(obj, data)

while (min(data$y) > 1e-7) {
  # request point proposal
  point = simplify2array(mboServicePropose(obj))
  print(point)
  
  expect_length(point, 2)
  
  # "eval" the proposed point
  y = test_func(point)
  r = append(point, y)
  names(r) = names(data)
  
  # upload new data
  mboServiceUpload(obj, r)
  
  data = rbind(data, r)
  
  #plot(data[1:2], type="p")
}

mboServiceDisconnect(obj)

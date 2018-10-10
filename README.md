# mlrMBO as a Webservice

This project is split into two parts: the server and the client.

The server is the actual project.
It contains [`mlrMBO`](https://github.com/mlr-org/mlrMBO), the "highly configurable R toolbox for model-based / Bayesian optimization of black-box functions."

The client contains a REST client and some abstractions to make your life easier.
But you can access the server with any REST client in any language you like, since the data exchange is done in JSON.

## How it works

Our server serves a REST-API which can be used to interact with mlrMBO.
You upload your data and our machine learning algoriths will calculate an interesting point for you.
You can interact with the server by using either our R client or any other client that can communicate with an REST-API.

## Example: Our R client

```r
library("ParamHelpers")

# A simple test function with its optimum at (4, 4)
test_func = function(x) {
  sum((x - c(4,4))^2)
}

# Create a parameter set using ParamHelpers which contains two variables from -5 to 5
size_of_initial_design = 10
par.set = makeNumericParamSet(len = 2, lower = c(-5,-5), upper = c(5,5))

# Generate a random initial design
data = generateDesign(n = size_of_initial_design, par.set)

# Run our test function on the initial design
Y = apply(data, 1, test_func)
data = data.frame(data, y = Y)

# Connect to service
obj = mboServiceConnect("https://rombie.de:5001")    # <- This is our open, free-to-use server.

# Upload parameter set, use "expected improvement" as infill criterium
mboServiceSetConfigKey(obj, par.set = par.set, crit = "ei")

# Upload data
mboServiceUpload(obj, data)

# Request point proposal
point = mboServicePropose(obj)
print(point)

mboServiceDisconnect(obj)
```
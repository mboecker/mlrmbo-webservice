# mlrMBO as a Webservice

Model-based optimization (also called Bayesian optimization) can be useful for many people, including commercial and research operations.
If you're trying to solve a black-box optimization problem and the evalutation of a single experiment is expensive, MBO can be used.
To give you the most interesting experiment configuration, MBO fits a surrogate model to your already evaluated data and, based on that, proposes a new configuration you should try.

The state-of-the-art solution for MBO in R is [`mlrMBO`](https://github.com/mlr-org/mlrMBO).
But not everyone wants to install a R-environment, the packages needed for mlrMBO, and so on.
We try to give the benefits of mlrMBO to everyone by providing a REST-API backed by mlrMBO.

## Project Structure

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
par.set = makeNumericParamSet(len = 2, lower = c(-5,-5), upper = c(5,5))

# Generate a random initial design
# These are just points pseudo-randomly distributed in the search space
size_of_initial_design = 10
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

# We now try the proposed point in `point`

mboServiceDisconnect(obj)
```

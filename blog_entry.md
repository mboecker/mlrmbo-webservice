Optimization is often needed in many operating fields, both for commercial and research purposes.
Model-Based Optimization (also called Bayesian optimization) is most useful for solving a black-box optimization problem where a single experiment (typically called "evaluation") is expensive (in respect to e.g. money, cost or runtime).
Model-Based Optimization (MBO) fits a model to your already evaluated data and, based on that, proposes a new experiment configuration (a point somewhere in the search space), that is currently the most promising.

# A new approach: MBO as a Webservice

We already showed off [mlrMBO](link-to-mlrmbo-blogpost), a framework for MBO in R using the [mlr](link to mlr package or blogpost) package, but the installation of R, mlrMBO and all of its dependencies might by a hurdle for some users.
We try to give the benefits of mlrMBO to everyone by providing a [REST-API](https://en.wikipedia.org/wiki/Representational_state_transfer) backed by mlrMBO.
REST is using [JSON](https://en.wikipedia.org/wiki/JSON) (a text-based data encoding supported by almost every programming language) to communicate over HTTP.
Our project is split into two parts: A server application and a client package.

* The server is able to receive data and perform the model-fitting and point proposing.
* The client is only responsible for sending/receiving the data.

This allows us to create client libraries in [every programming language which supports REST](link to a list of REST clients in a lot of languages) (for example [Python](https://www.python.org) or [Julia](https://julialang.org)), but still use our state-of-the-art mbo package on the backend.
By doing the optimization on the server-side, we eliminated the need for big packages on the client-side.

# Example Usage

In this next section we will show off the use of our client library to perform simple Model-Based Optimization.
We will minimuze an example-function whose optimum is obviously at (-4, -4).

```r
# A simple test function with its optimum at (4, 4)
test_func = function(x) {
  sum((x - c(4,4))^2)
}
```

We will furthermore use the ParamHelpers package to generate an initial design for MBO.

```r
library("ParamHelpers")
# Create a parameter set using ParamHelpers.
# It contains two variables from -5 to 5.
par.set = makeNumericParamSet(len = 2, lower = c(-5,-5), upper = c(5,5))

# Generate a random initial design.
# These points are pseudo-randomly distributed in the search space.
size_of_initial_design = 10
data = generateDesign(n = size_of_initial_design, par.set)
```

In order to use MBO, we need to have a set of evaluated points.
Since we assume to know nothing about the structure of our black-box function, we evaluate a set of randomly scattered points.

```r
# Run our test function on the initial design.
Y = apply(data, 1, test_func)
data = data.frame(data, y = Y)
```

In the next step, we need to connect to the server-side.
This will initiate a session which will allow us to upload data and receive point proposals.

```r
# Connect to service.
obj = mboServiceConnect("https://rombie.de:5001")
```

We need to tell the server what the parameter space is.
It is als possible to set some other options available in the mlrMBO package, like the infill criterium.
For this example, we chose to use "expected improvement" as our infill criterium.
We also upload the data we have already evaluated (our initial design).

```r
# Set configuration of mlrMBO for this session.
mboServiceSetConfigKey(obj, par.set = par.set, crit = "ei")
# Upload data.
mboServiceUpload(obj, data)
```

The next step is to actually perform MBO.
This will run a model-fitting on the server side, optimization of the infill criterium and return the found point.

```r
# Request point proposal
point = mboServicePropose(obj)
print(point)
```

We can then evaluate this point and upload it to the server in order to extend the model.
Subsequent calls to propose will then return the most interesting point based on the updated model.
When the optimization process reached a user-set limit (for example time or evaluation count limit) or you are otherwise finished with your optimization, you can disconnect from the server.
This will delete all your data from the server side.

```r
# Disconnect from server.
mboServiceDisconnect(obj)
```

As you can see, the client-side usage of our project does not depend on mlr or mlrMBO.
We did however use ParamHelpers to simplify our handling of parameters and parameter space.
This is optional though, as other programming languages we want to support do not have an equivalent package.
The parameter set is transmitted using JSON and can therefore be encoded by every supported programming language.
You can find more examples of our R client in [our GitHub-repository](https://github.com/mboecker/mlrmbo-webservice/tree/master/client) as well as [documentation of the server-side API](https://github.com/mboecker/mlrmbo-webservice/blob/master/server/API_DOCS.md), in case you want to connect to it using another programming language.

# Running your own server

You may think that this project is a great fit for your needs, but you have privacy concerns due to transmission of your data over the internet, as well as temporarily storing your data on third-party servers.
Although we guarantee to delete your data after a timeout or when you close your session, you may be interested in running your own backend.

Running your own server is simple, since it's enclosed in a [Docker](https://www.docker.com) image.
This means that deploying your own mlrMBO webservice is easy because it's already bundled with the necessary software needed for it to run.
You can find more information about setting up your own server in [our GitHub-repository](https://github.com/mboecker/mlrmbo-webservice/tree/master/server).

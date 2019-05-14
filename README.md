# mlrMBO as a Webservice

Optimization is often needed in many operating fields, both for commercial and research purposes.
Model-Based Optimization (also called Bayesian optimization) is most useful for solving a [black-box](https://en.wikipedia.org/wiki/Black_box) optimization problem where a single experiment (typically called "evaluation") is expensive (in respect to e.g. money, cost or runtime), see [1].
To give you the most interesting experiment setting, MBO fits a model to your already evaluated data and, based on that, proposes a new configuration to try.

The state-of-the-art solution for MBO in R is [`mlrMBO`](https://github.com/mlr-org/mlrMBO), but not everyone wants to install an R-environment, the packages needed for mlrMBO, and so on.
We try to give the benefits of mlrMBO to everyone by providing a [REST](https://en.wikipedia.org/wiki/Representational_state_transfer)-API backed by mlrMBO.
REST is using [JSON](https://en.wikipedia.org/wiki/JSON) (a text-based data encoding supported by almost every programming language) to communicate over HTTP.
This allows us to support every programming language on the client side (like [Python](https://www.python.org/) or [Julia](https://julialang.org/)) and also to use the secure HTTPS protocol for data transfer.

1. Jones, Donald R., Matthias Schonlau, and William J. Welch. "Efficient global optimization of expensive black-box functions." Journal of Global optimization 13.4 (1998): 455-492.

## Project Structure

This project is split into two parts: the server and the client.

The server is the actual project.
It contains mlrMBO, the "highly configurable R toolbox for model-based / Bayesian optimization of black-box functions."

The client contains a REST client and some abstractions to make your life easier.
However, you can access the server with any REST client in any language you like, since the data exchange is done in JSON.

## Usage

Our server serves a REST-API which can be used to interact with mlrMBO.
First, you upload your data and then our machine learning algorithms will calculate an interesting point for you.
You can interact with the server by using either our R client or any other client that can communicate with a REST-API.
The API is documented [here](server/API_DOCS.md).

# Our reference client

This client provides a high-level interface to the mlrMBO-Server provided in this repo. Without installing machine learning packages or other software (except of this package), you can benefit from mlrMBO!

You can install the R package with devtools.
We also provide a server.
```r
devtools::install_github("mboecker/mlrmbo-webservice/client")
mboServiceConnect("https://rombie.de:5001")
```

## Example usage

Although you can use the server with any programming language on the client side, we currently only supply an R client.

```r
library("ParamHelpers")

# A simple test function with its optimum at (4, 4)
test_func = function(x) {
  sum((x - c(4,4))^2)
}

# Create a parameter set using ParamHelpers.
# It contains two variables from -5 to 5
par.set = makeNumericParamSet(len = 2,
                              lower = c(-5,-5),
                              upper = c(5,5))

# Generate a random initial design
# These points are pseudo-randomly distributed in the search space
size_of_initial_design = 10
data = generateDesign(n = size_of_initial_design, par.set)

# Run our test function on the initial design
Y = apply(data, 1, test_func)
data = data.frame(data, y = Y)

# Connect to service
# This is our open, free-to-use server
obj = mboServiceConnect("https://rombie.de:5001")

# Upload parameter set
# Use "expected improvement" as infill criterium
mboServiceSetConfigKey(obj, par.set = par.set, crit = "ei")

# Upload data
mboServiceUpload(obj, data)

# Request point proposal
point = mboServicePropose(obj)
print(point)

mboServiceDisconnect(obj)
```

# mlrMBO-Webservice Server

We provide mlrMBO as a Webservice.
This server wraps the R package `mlrMBO` along with some software management software written in Python in order to handle multiple users simultanously.
We expose a REST-API, which is documented in the file [server/API_DOCS.md](server/API_DOCS.md).
You can use any REST client to access the API, but we also implemented an easy to use R package to go along with it.

## Do I have to run my own server?
Since we want you to have the best user experience, we are currently running an open, free-for-all server at `https://rombie.de:5001`.
You may use that as much as you wish.
If you're having performance problems, consider running your own server.
How to do that is documented in the next section of this README.

## How do I run my own server?
The `image` folder contains a Docker image with everything you need.
You can run the `rebuild-server.sh` script which will create a docker image that you can upload to a server or run locally.
It exposes port 5000, which will serve our `mlrMBO` API.
After building the image, it will be saved under the name "mlrmbo-webservice-testserver:$USER", where $USER is your active username.
You can then run an instance of this image by using the "start-new-container.sh" script.
After shutting down the container, you can restart this instance with the "start-existing-container.sh" script.
These scripts are just wrappers for the "docker build", "docker run" and "docker start" commands, so if you're already familiar with those you can use them as well.

# May I use this? (License)
We provide both the server application as well as the reference client library as Open Source under the MIT license.
This basically means you can use both the server and the client in open source and commercial projects.

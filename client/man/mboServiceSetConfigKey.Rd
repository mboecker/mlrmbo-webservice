% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mboServiceSetConfigKey.R
\name{mboServiceSetConfigKey}
\alias{mboServiceSetConfigKey}
\title{Change the mlrMBO settings used for your point proposal.}
\usage{
mboServiceSetConfigKey(obj, minimize = NULL, noisy = NULL,
  propose.points = NULL, opt.restarts = NULL,
  opt.focussearch.maxit = NULL, opt.focussearch.points = NULL,
  par.set = NULL)
}
\arguments{
\item{obj}{The handle object created by mboServiceConnect.}

\item{...}{The other parameters are mlrMBO parameters which can be set to be used by the service.}
}
\description{
Change the mlrMBO settings used for your point proposal.
}

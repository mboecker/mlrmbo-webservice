library("httr")

#' Change the mlrMBO settings used for your point proposal.
#' 
#' @param obj The handle object created by mboServiceConnect.
#' @param ... The other parameters are mlrMBO parameters which can be set to be used by the service.
#'
#' @export
mboServiceSetConfigKey = function(obj, minimize = NULL, noisy = NULL, propose.points = NULL, opt.restarts = NULL, opt.focussearch.maxit = NULL, opt.focussearch.points = NULL, par.set = NULL, crit = NULL) {
  if(!is.null(minimize)) {
    if(is.logical(minimize)) {
      mboServiceSetConfigKeyRaw(obj, "minimize", minimize)
    } else {
      # FIXME
      stop("wrong type")
    }
  }
  
  if(!is.null(noisy)) {
    if(is.logical(noisy)) {
      mboServiceSetConfigKeyRaw(obj, "noisy", noisy)
    } else {
      # FIXME
      stop("wrong type")
    }
  }
  
  if(!is.null(propose.points)) {
    if(is.numeric(propose.points)) {
      mboServiceSetConfigKeyRaw(obj, "propose.points", propose.points)
    } else {
      # FIXME
      stop("wrong type")
    }
  }
  
  if(!is.null(opt.restarts)) {
    if(is.numeric(opt.restarts)) {
      mboServiceSetConfigKeyRaw(obj, "opt.restarts", opt.restarts)
    } else {
      # FIXME
      stop("wrong type")
    }
  }
  
  if(!is.null(opt.focussearch.maxit)) {
    if(is.numeric(opt.focussearch.maxit)) {
      mboServiceSetConfigKeyRaw(obj, "opt.focussearch.maxit", opt.focussearch.maxit)
    } else {
      # FIXME
      stop("wrong type")
    }
  }
  
  if(!is.null(opt.focussearch.points)) {
    if(is.numeric(opt.focussearch.points)) {
      mboServiceSetConfigKeyRaw(obj, "opt.focussearch.points", opt.focussearch.points)
    } else {
      # FIXME
      stop("wrong type")
    }
  }
  
  if(!is.null(par.set)) {
    # TODO check type of par.set
    as_json = parSetToJSON(par.set)
    mboServiceSetConfigKeyRaw(obj, "par.set", as_json)
  }
  
  if(!is.null(crit)) {
    # TODO check type and value of crit
    mboServiceSetConfigKeyRaw(obj, "crit", crit)
  }
}
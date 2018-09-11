library("rjson")
library("mlrMBO")
library("stringi")

source("helpers.R")
source("json.R")

return_error = function(msg) {
    cat(paste0("r_error: ", msg, "\n"))
    quit()
}

readData = function(session.id) {
  # Read mlrMBO configuration
  config = fromJSON(file = sprintf("data_dir/%s/config.json", session.id))

  # Read JSON data from file
  con = file(sprintf("data_dir/%s/data.json", session.id), "r")

  all_data = data.frame()
  
  # Read all lines
  while (TRUE) {
    # Read one line
    line = readLines(con, n = 1)

    # End of file?
    if (length(line) == 0) {
      break
    }

    # Decode JSON
    data = fromJSON(line)
    data = data.frame(data)

    # Add data to mlrMBO model
    all_data = rbind(all_data, data)
  }

  # Close file
  close(con)
  
  if(is.null(config$par.set)) {
      return_error("set par.set please")
  }

  ctrl = makeMBOControl(propose.points = config$propose.points)
  
  if(config$crit == "ei") {
      crit = makeMBOInfillCritEI()
  } else if(config$crit == "cb") {
      crit = makeMBOInfillCritCB()
  } else {
      return_error("set valid crit please")
  }
  
  ctrl = setMBOControlInfill(control = ctrl, crit = crit, opt = config$opt, opt.restarts = config$opt.restarts, opt.focussearch.maxit = config$opt.focussearch.maxit, opt.focussearch.points = config$opt.focussearch.points)
  par.set = JSONtoParSet(config$par.set)
  opt.state = initSMBO(control = ctrl, par.set = par.set, design = all_data, learner = config$learner, minimize = config$minimize, noisy = config$noisy)
  
  # Return mlrMBO object
  return(opt.state)
}

propose = function(session.id) {
  opt.state = readData(session.id)

  # Return X data of proposed point
  p = proposePoints(opt.state)$prop.points
  return(p)
}

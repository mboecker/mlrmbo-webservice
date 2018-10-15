library("jsonlite")
library("mlrMBO")
library("stringi")

source("helpers.R")
source("json.R")

return_error = function(msg) {
    cat(paste0("r_error: ", msg, "\n"))
    quit()
}

readData = function(session.id) {
  all_data = data.frame()

  # Get Vec of all files 
    con = file(sprintf("data_dir/%s/data_*.json", session.id), "r")

  for (each_file in files) {
    # FIXME
    # Read JSON data from file
    con = file(each_file, "r")
    
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
    
    # Delete file
    # TODO
  }

  return(all_data)
}

readFirstModel = function(session.id) {
  # Disable config-key-setting by creating file config.lock
  # TODO
  
  # Read config keys
  config = read_json(sprintf("data_dir/%s/config.json", session.id))
  
  # Read all data
  Xy = readData(session.id)
  
  # Fit initial model and return it
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

readAndUpdateModel = function(session.id) {
  # Read existing model
  # TODO
  
  # Read additional data
  Xy = readData(session.id)
  
  # Update model
  # FIXME
  updateSMBO(opt.state, x = Xy[-y], y = Xy[y])
  
  return(opt.state)
}

propose = function(session.id) {
  # Check if model exists:
  opt.state = readFirstModel(session.id)
  opt.state = readAndUpdateModel(session.id)

  # Return X data of proposed point
  p = proposePoints(opt.state)$prop.points
  
  # Emit as JSON
  # TODO: permit multiple propose.points
  p = simplify2array(p)
  paste0("[", paste0(p, collapse = ","), "]")
}

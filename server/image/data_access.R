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

    filename = sprintf("data_dir/%s/data.json", session.id)
    
    # Get Vec of all files 
    con = file(filename, "r")

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
        
        for(parname in names(data)) {
            if(is.integer(data[[parname]])) {
                # Fix "REAL() can only be applied to a 'numeric', not a 'integer'"
                data[[parname]] = as.numeric(data[[parname]])
            }
        }
        
        # Add data to mlrMBO model
        all_data = rbind(all_data, data)
    }
    
    # Close file
    close(con)
    
    file.remove(filename)

    return(all_data)
}

readFirstModel = function(session.id) {
  # Read config keys
  config = read_json(sprintf("data_dir/%s/config.json", session.id))
  
  # Read all data
  Xy = readData(session.id)
  
  # Fit initial model and return it
  if(is.null(config$par.set)) {
      return_error("set par.set please")
  }

  if (!is.null(config$learner)) {
    learner = simplify2array(config$learner)
  } else {
    learner = NULL
  }
  
  ctrl = makeMBOControl(propose.points = simplify2array(config$propose.points))
  
  if(config$crit == "ei") {
      crit = makeMBOInfillCritEI()
  } else if(config$crit == "cb") {
      crit = makeMBOInfillCritCB()
  } else {
      return_error("set valid crit please")
  }
  
  ctrl = setMBOControlInfill(control = ctrl, crit = crit, opt = simplify2array(config$opt), opt.restarts = simplify2array(config$opt.restarts), opt.focussearch.maxit = simplify2array(config$opt.focussearch.maxit), opt.focussearch.points = simplify2array(config$opt.focussearch.points))
  par.set = JSONtoParSet(config$par.set)
  opt.state = initSMBO(control = ctrl, par.set = par.set, design = Xy, learner = learner, minimize = simplify2array(config$minimize), noisy = simplify2array(config$noisy))
  
  # Return mlrMBO object
  return(opt.state)
}

readAndUpdateModel = function(session.id) {
  model_filename = sprintf("data_dir/%s/model.rds", session.id)
  
  if (file.exists(model_filename)) {
      # Read existing model
      opt.state = readRDS(model_filename)
      
      # Read additional data
      Xy = readData(session.id)
      
      if (dim(Xy)[1] > 0) {
          # Update model
          updateSMBO(opt.state, x = subset(Xy, select=-c(y)), y = as.list(Xy$y))
      }
  } else {
      opt.state = readFirstModel(session.id)
  }
  
  # Save current model
  saveRDS(opt.state, model_filename)
  
  return(opt.state)
}

propose = function(session.id) {
  # Check if model exists:
  opt.state = readAndUpdateModel(session.id)

  # Return X data of proposed point
  p = proposePoints(opt.state)$prop.points
  
  # Emit as JSON
  p = simplify2array(p)
  p = as.character(toJSON(p))

  p
}

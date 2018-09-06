library(rjson)
library(mlrMBO)

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

  ctrl = makeMBOControl()
  initSMBO(config$par.set, design = all_data, learner = config$learner, minimize = config$minimize, noisy = config$noisy)
  
  # Return mlrMBO object
  return(ctrl)
}

propose = function(session.id) {
  mlr.obj = readData(session.id)

  # Return X data of proposed point
  # TODO: p = predict(mlr.obj)
  p = c(0.5, 1, 2)

  return(p)
}

library(jsonlite)
library(mlrMBO)

readData = function(session.id) {
  # Read mlrMBO configuration
  mlr.obj = readRDS(sprintf("data_dir/%s/config.rds"))
  
  # Read JSON data from file
  con = file(sprintf("data_dir/%s/data.json", session.id), "r")
  
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
    
    # Add data to mlrMBO model
    # TODO: append(mlr.obj, data)
  }
  
  # Close file
  close(con)
  
  # Return mlrMBO object
  return(mlr.obj)
}

propose = function(session.id) {
  mlr.obj = readData(session.id)
  
  # Return X data of proposed point
  # TODO: p = predict(mlr.obj)
  p = c(0.5, 1, 2)
  
  return(p)
}
source("data_access.R")

# Read command line argument
args = commandArgs(trailingOnly=TRUE)
if (length(args) == 0) {
  stop("Missing <session.id>")
}

# First argument is the session id.
session.id = args[1]

# Read data and propose new point.
p = propose(session.id)

# Print result back to server.
cat("[", paste0(p, collapse=", "), "]\n")

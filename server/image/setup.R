# Read command line argument
args = commandArgs(trailingOnly=TRUE)
if (length(args) == 0) {
  stop("Missing <session.id>")
}

# First argument is the session id.
session.id = args[1]

filename = sprintf("data_dir/%s/config.json", session.id)

write("{}", filename)
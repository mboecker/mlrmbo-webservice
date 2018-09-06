library(rjson)

# Read command line argument
args = commandArgs(trailingOnly=TRUE)
if (length(args) == 0) {
  stop("Missing <session.id>")
}

# First argument is the session id.
session.id = args[1]

filename = sprintf("data_dir/%s/config.json", session.id)

standard = list(noisy = F, minimize = T, crit = "CB", opt = "focussearch", opt.restarts = 3, opt.focussearch.maxit = 5, opt.focussearch.points = 1000, propose.points = 1)
standard = toJSON(standard)
write(standard, filename)
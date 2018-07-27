library(mlrMBO)

# Read command line argument
args = commandArgs(trailingOnly=TRUE)
if (length(args) == 0) {
  stop("Missing <session.id>")
}

# First argument is the session id.
session.id = args[1]

mbo.obj = makeMBOControl()
mbo.obj = setMBOControlInfill(mbo.obj, crit = crit.ei)

print(session.id)

filename = sprintf("data_dir/%s/config.rds", session.id)

print(filename)

saveRDS(mbo.obj, file = filename)

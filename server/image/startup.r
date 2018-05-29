library("plumber")

p = plumber::plumb("api.r")
p$run(host='0.0.0.0', port=8000)
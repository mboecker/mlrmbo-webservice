devtools::load_all()
obj = mboServiceConnect("http://localhost:5000")
point = mboServicePropose(obj)
print(point)
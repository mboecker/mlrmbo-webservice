connect = function(address) {
  connection = list()
  obj = list(
    connection = connection,
    address = address
  )
  class(obj) = append(class(obj), "mlrMBOWebHandle")
  return(obj)
}

disconnect = function(obj) {
  
}
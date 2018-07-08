#!/bin/bash
docker rm $USER-mlrmbo-testserver
docker run -it -p 5000:5000 --name=$USER-mlrmbo-testserver mlrmbo-webservice-testserver:$USER

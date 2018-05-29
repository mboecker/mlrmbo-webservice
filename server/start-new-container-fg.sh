#!/bin/bash
docker rm $USER-mlrmbo-testserver
docker run -it -p 8000:8000 --name=$USER-mlrmbo-testserver mlrmbo-webservice-testserver:$USER

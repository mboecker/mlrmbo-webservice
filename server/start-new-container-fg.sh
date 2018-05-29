#!/bin/bash
docker rm $USER-mlrmbo-testserver
docker run -it --name=$USER-mlrmbo-testserver mlrmbo-webservice-testserver:$USER

#!/bin/bash --
# check if nexus volume exists
if [ ! -d "./nexus-volume" ]; 
then
  mkdir "nexus-volume"
else
  echo "nexus volume already exists"
fi

# set correct permissions for nexus volume
if [[ $(stat -c "%a" ./nexus-volume) == "777" ]]; 
then
    echo "nexus-volume permissions are set correctly"
else
    sudo chmod 777 "nexus-volume"
fi

# Run nginx and nexus containers
docker-compose up -d
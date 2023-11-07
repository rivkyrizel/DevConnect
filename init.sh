#!/bin/bash

# Prompt the user to select a version
echo "Which version of the application would you like to run?"
read -p "Enter the version:" version


# Define variables for image and container names
image_name="django"
container_name="my-django-app"
volume_url="sqlite_db"


# Build the Docker image using the Dockerfile
docker build -t $image_name:$version .

# Run the Docker container in the background and map port 8000 to a port on the host
docker run -d -p 8000:8000 --name $container_name -v $volume_url:/app/db.sqlite3 $image_name:$version
#!/bin/bash

# Prompt the user to select a version
echo "Which version of the application would you like to run?"
read -p "Enter the version:" VERSION


# Define variables for image and container names
IMAGE_NAME="django"
CONTEINER_NAME="my-django-app"
VOLUME_URL="C:\1\db.sqlite3"
ARTIFACT_URL="me-west1-docker.pkg.dev/devconnect-final-project/rivky-rizel-artifacts/dev_connect"
IMAGE_TAG=${IMAGE_NAME}:${VERSION}



# Build the Docker image using the Dockerfile
docker build -t $IMAGE_NAME:$VERSION .

docker tag ${IMAGE_TAG} ${ARTIFACT_URL}:${VERSION}

# Run the Docker container in the background and map port 8000 to a port on the host
docker run -d -p 8000:8000 --name $CONTEINER_NAME -v $VOLUME_URL:/app/db.sqlite3 $IMAGE_NAME:$VERSION

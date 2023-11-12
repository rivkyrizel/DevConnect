#!/bin/bash

# Prompt the user to select a version
echo "Which version of the application would you like to run?"
read -p "Enter the version:" VERSION


IMAGE_NAME="django"
IMAGE_TAG=${IMAGE_NAME}:${VERSION}
ARTIFACT_URL="me-west1-docker.pkg.dev/devconnect-final-project/rivky-rizel-artifacts/dev_connect"

gcloud auth configure-docker me-west1-docker.pkg.dev
docker tag ${IMAGE_TAG} ${ARTIFACT_URL}:${VERSION}
docker push ${ARTIFACT_URL}:${VERSION}


# docker tag django:0.0.2 me-west1-docker.pkg.dev/devconnect-final-project/rivky-rizel-artifacts/dev_connect:0.0.2
# docker push me-west1-docker.pkg.dev/devconnect-final-project/rivky-rizel-artifacts/dev_connect:0.0.2
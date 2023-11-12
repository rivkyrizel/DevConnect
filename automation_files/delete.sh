#!/bin/bash

container_name="my-django-app"

# Stop and remove the running Docker container
docker stop $container_name
docker rm $container_name

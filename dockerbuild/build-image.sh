#!/bin/bash -eux

DOCKERHUB_USERNAME=ncbi
IMAGE=edirect

docker build -t $DOCKERHUB_USERNAME/$IMAGE .

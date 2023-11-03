#!/bin/bash

export SPARK_VERSION=${SPARK_VERSION:-"3.5.0"}
export SPARK_HOME=${SPARK_HOME:-"/opt/spark"}
export DOCKER_HUB_USER=${DOCKER_HUB_USER:-"rangareddy1988"}
export DOCKER_IMAGE_NAME=${DOCKER_IMAGE_NAME:-"spark-history-server"}
export LATEST_TAG_NAME="latest"

export SHS_DOCKER_IMAGE_NAME_LATEST="${DOCKER_HUB_USER}/${DOCKER_IMAGE_NAME}:${LATEST_TAG_NAME}"
export SHS_DOCKER_IMAGE_NAME_SPARK="${DOCKER_HUB_USER}/${DOCKER_IMAGE_NAME}:${SPARK_VERSION}"

echo "Building the Docker <${DOCKER_IMAGE_NAME}> image using Spark <${SPARK_VERSION}> version"

if [[ $(uname -m) == "arm64" ]] && [[ "$1" == "run" || "$1" == "build" ]]; then
	export DOCKER_DEFAULT_PLATFORM=linux/amd64
	#--platform=linux/amd64,linux/arm64,windows/amd64,darwin/amd64 \
fi

# Building the Docker image
docker build \
	-t ${SHS_DOCKER_IMAGE_NAME_LATEST} \
	-t ${SHS_DOCKER_IMAGE_NAME_SPARK} \
	--build-arg spark_version=${SPARK_VERSION} \
	--build-arg spark_home=${SPARK_HOME} \
	-f Dockerfile . #--load --progress=plain --no-cache

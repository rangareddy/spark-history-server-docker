#!/bin/bash

export SPARK_HOME=${SPARK_HOME:-"/opt/spark"}
export SPARK_VERSION=${SPARK_VERSION:-"3.5.0"}
export DOCKER_HUB_USER=${DOCKER_HUB_USER:-"rangareddy1988"}
export DOCKER_IMAGE_NAME=${DOCKER_IMAGE_NAME:-"spark-history-server"}

bash build.sh

if [ $? -ne 0 ]; then
   echo "Docker build is failed. Please check the logs"
   exit 1
fi

docker login
docker push ${DOCKER_HUB_USER}/${DOCKER_IMAGE_NAME}
docker push ${DOCKER_HUB_USER}/${DOCKER_IMAGE_NAME}:${SPARK_VERSION}
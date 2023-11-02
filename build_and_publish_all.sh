#!/bin/bash

# Define Spark2 versions to test
export SPARK2_VERSIONS=("2.3.0" "2.3.1" "2.3.2" "2.3.3" "2.3.4" "2.4.0" "2.4.1" "2.4.2" "2.4.3" "2.4.4" "2.4.5" "2.4.6" "2.4.7" "2.4.8")

# Define Spark3 versions to test
export SPARK3_VERSIONS=("3.0.0" "3.0.1" "3.0.2" "3.0.3" "3.1.1" "3.1.2" "3.1.3" "3.2.0" "3.2.1" "3.2.2" "3.2.3" "3.3.0" "3.3.1" "3.3.2" "3.4.0" "3.4.1" "3.5.0")

# Define Spark versions to test
export SPARK_VERSIONS=("${SPARK2_VERSIONS[@]}" "${SPARK3_VERSIONS[@]}")

export DOCKER_HUB_USER=${DOCKER_HUB_USER:-"rangareddy1988"}
export DOCKER_IMAGE_NAME=${DOCKER_IMAGE_NAME:-"spark-history-server"}
export SPARK_HOME=${SPARK_HOME:-"/opt/spark"}

for SPARK_VERSION in "${SPARK_VERSIONS[@]}"; do
    echo "Building the Spark <$SPARK_VERSION> version SHS docker image"
    export SPARK_VERSION=${SPARK_VERSION:-"3.5.0"}
    build_and_publish.sh
done



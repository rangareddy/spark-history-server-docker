#!/bin/bash

export SOFTWARE="spark"
export SPARK_HOME=${SPARK_HOME:-"/opt/spark"}
export SPARK_VERSION=${SPARK_VERSION:-"3.5.0"}
export SPARK_CONF=${SPARK_CONF:-"/etc/spark/conf"}
export SPARK_3_3=3.3.0

mkdir -p ${SPARK_HOME} && mkdir -p $SPARK_CONF

IFS=. v1_array=($SPARK_3_3) v2_array=($SPARK_VERSION)
v1=$((v1_array[0] * 100 + v1_array[1] * 10 + v1_array[2]))
v2=$((v2_array[0] * 100 + v2_array[1] * 10 + v2_array[2]))

ver_diff=$((v2 - v1))

if [[ $ver_diff -ge 0 ]] && [[ $SPARK_VERSION == [3-9].[3-9]* ]]; then
    HADOOP_MIN_VERSION="3"
elif [[ $SPARK_VERSION == 3.[0-2]* ]]; then
    HADOOP_MIN_VERSION="3.2"
else
    HADOOP_MIN_VERSION="2.7"
fi

export TAR_FILE=$SOFTWARE-${SPARK_VERSION}-bin-hadoop${HADOOP_MIN_VERSION}.tgz
export DOWNLOAD_URL=https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/$TAR_FILE
export DOWNLOAD_URL_ARCHIVE=https://www.apache.org/dyn/closer.lua/spark/spark-${SPARK_VERSION}/$TAR_FILE

bash /opt/download_util.sh "$SOFTWARE" "${SPARK_HOME}" "$DOWNLOAD_URL" "$DOWNLOAD_URL_ARCHIVE"

if [ $? -ne 0 ]; then
    echo "Spark is not downloaded. Please check the urls are correct or not"
    exit 1
fi

mv /opt/spark-defaults.conf $SPARK_HOME/conf/
ln -sf $SPARK_HOME/conf/* $SPARK_CONF
echo "Successfully installed ${SOFTWARE^}"

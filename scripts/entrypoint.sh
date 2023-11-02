#!/bin/bash

export SPARK_HOME=${SPARK_HOME:-/opt/spark}
export SPARK_LOG_DIR=${SPARK_LOG_DIR:-/var/log/spark}

mkdir -p $SPARK_LOG_DIR
mkdir -p $SPARK_HISTORY_FS_LOG_DIRECTORY

sed -i "s;SPARK_EVENTLOG_ENABLED;${SPARK_EVENTLOG_ENABLED};" ${SPARK_HOME}/conf/spark-defaults.conf
sed -i "s;SPARK_HISTORY_FS_LOG_DIRECTORY;${SPARK_HISTORY_FS_LOG_DIRECTORY};" ${SPARK_HOME}/conf/spark-defaults.conf
sed -i "s/SPARK_HISTORY_STORE_MAXDISKUSAGE/${SPARK_HISTORY_STORE_MAXDISKUSAGE}/" ${SPARK_HOME}/conf/spark-defaults.conf
sed -i "s/SPARK_HISTORY_UI_PORT/${SPARK_HISTORY_UI_PORT}/" ${SPARK_HOME}/conf/spark-defaults.conf
sed -i "s/SPARK_HISTORY_FS_CLEANER_ENABLED/${SPARK_HISTORY_FS_CLEANER_ENABLED}/" ${SPARK_HOME}/conf/spark-defaults.conf
sed -i "s/SPARK_HISTORY_FS_CLEANER_INTERVAL/${SPARK_HISTORY_FS_CLEANER_INTERVAL}/" ${SPARK_HOME}/conf/spark-defaults.conf
sed -i "s/SPARK_HISTORY_FS_CLEANER_MAXAGE/${SPARK_HISTORY_FS_CLEANER_MAXAGE}/" ${SPARK_HOME}/conf/spark-defaults.conf
sed -i "s/SPARK_HISTORY_FS_UPDATE_INTERVAL/${SPARK_HISTORY_FS_UPDATE_INTERVAL}/" ${SPARK_HOME}/conf/spark-defaults.conf
sed -i "s/SPARK_HISTORY_RETAINEDAPPLICATIONS/${SPARK_HISTORY_RETAINEDAPPLICATIONS}/" ${SPARK_HOME}/conf/spark-defaults.conf
sed -i "s/SPARK_HISTORY_UI_MAXAPPLICATIONS/${SPARK_HISTORY_UI_MAXAPPLICATIONS}/" ${SPARK_HOME}/conf/spark-defaults.conf

cp $SPARK_HOME/conf/spark-env.sh.template $SPARK_HOME/conf/spark-env.sh
echo "SPARK_DAEMON_MEMORY=${SPARK_DAEMON_MEMORY}" >>$SPARK_HOME/conf/spark-env.sh

export HEAP_DUMP_PATH=$SPARK_LOG_DIR/HistoryHeapDump_$SPARK_HISTORY_UI_PORT
export LOG_GC_PATH=$SPARK_LOG_DIR/SparkHistoryServer_GC_$SPARK_HISTORY_UI_PORT.log

export SPARK_HISTORY_OPTS="${SPARK_HISTORY_OPTS} -XX:+IgnoreUnrecognizedVMOptions -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=$HEAP_DUMP_PATH -XX:+PrintGCDetails -XX:+PrintGCTimeStamps -Xloggc:$LOG_GC_PATH"

# Start the Spark History Server
start_history_server() {
    echo "Starting Spark History Server"
    bash ${SPARK_HOME}/sbin/start-history-server.sh >>"${SPARK_LOG_DIR}/spark-history_$SPARK_HISTORY_UI_PORT.log" 2>&1
}

# Set the number of attempts
MAX_ATTEMPTS=5

# Wait time between attempts in seconds
WAIT_TIME=5

# Start the Spark History Server with multiple attempts
for i in $(seq 1 $MAX_ATTEMPTS); do
    start_history_server
    sleep $WAIT_TIME
    JPS_SERVICE_COUNT=$(jps | egrep -w 'HistoryServer' | grep -v egrep | grep -v jps | wc -l)
    if [ $JPS_SERVICE_COUNT -eq 1 ]; then
        echo "Spark History Server started successfully."
        break
    fi
    echo "The Spark History Server failed to start. Attempt $i of $MAX_ATTEMPTS"
    if [ $i -eq $MAX_ATTEMPTS ]; then
        echo "Spark History Server service is not started. Please check the logs for errors."
        cat ${SPARK_LOG_DIR}/spark-history_$SPARK_HISTORY_UI_PORT.log
        exit 1
    fi
done

while true; do sleep 1000; done

FROM openjdk:11-jdk

MAINTAINER "Ranga Reddy" <rangareddy.avula@gmail.com>
LABEL image=spark-history-server

ARG spark_version=${spark_version:-"3.3.2"} \
	spark_home=${spark_home:-"/opt/spark"}

ENV SPARK_HOME=${spark_home:-"/opt/spark"} \
	SPARK_VERSION=${spark_version:-"3.3.2"} \
    SPARK_CONF=${SPARK_CONF:-"/etc/spark/conf"} \
    SPARK_HISTORY_UI_PORT=${SPARK_HISTORY_UI_PORT:-"18080"}  \
    SPARK_EVENTLOG_ENABLED=${SPARK_EVENTLOG_ENABLED:-"true"} \
    SPARK_EVENT_LOG_DIR=${SPARK_EVENT_LOG_DIR:-"/tmp/spark-events"} \
    SPARK_DAEMON_MEMORY=${SPARK_DAEMON_MEMORY:-"10g"} \
    SPARK_HISTORY_FS_LOG_DIRECTORY=${SPARK_HISTORY_FS_LOG_DIRECTORY:-"/tmp/spark-events"} \
    SPARK_HISTORY_FS_CLEANER_ENABLED=${SPARK_HISTORY_FS_CLEANER_ENABLED:-"true"} \ 
    SPARK_HISTORY_STORE_MAXDISKUSAGE=${SPARK_HISTORY_STORE_MAXDISKUSAGE:-"100g"} \ 
    SPARK_HISTORY_FS_CLEANER_INTERVAL=${SPARK_HISTORY_FS_CLEANER_INTERVAL:-"8h"} \  
    SPARK_HISTORY_FS_CLEANER_MAXAGE=${SPARK_HISTORY_FS_CLEANER_MAXAGE:-"5d"} \
    SPARK_HISTORY_FS_UPDATE_INTERVAL=${SPARK_HISTORY_FS_UPDATE_INTERVAL:-"10s"} \  
    SPARK_HISTORY_RETAINEDAPPLICATIONS=${SPARK_HISTORY_RETAINEDAPPLICATIONS:-"100"} \ 
    SPARK_HISTORY_UI_MAXAPPLICATIONS=${SPARK_HISTORY_UI_MAXAPPLICATIONS:-"500"} 

ENV DEBIAN_FRONTEND noninteractive

# Install Ubuntu dependencies
RUN apt-get update && \
	apt-get install -y --no-install-recommends \
      netcat \
      curl \
      vim \
      wget \
      software-properties-common \
      ssh && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY scripts /opt
COPY conf /opt
RUN chmod 755 /opt/*.sh
RUN bash /opt/install_spark.sh
ENV PATH=$SPARK_HOME/bin:$SPARK_HOME/sbin:$PATH

ENTRYPOINT ["/opt/entrypoint.sh"]
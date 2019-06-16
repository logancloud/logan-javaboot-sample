FROM centos:7.4.1708
MAINTAINER Linzhaoming <teleyic@gmail.com>

ARG JAVA_VERSION=1.8.0
ENV JAVA_HOME /usr/lib/jvm/java
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

LABEL org.opennms.java.version="openjdk-${JAVA_VERSION}"

RUN yum -y --setopt=tsflags=nodocs update && \
    yum -y install java-${JAVA_VERSION}-openjdk-devel unzip nmap iproute net-tools && \
    yum -y clean all && \
    rm -rf /var/cache/yum

RUN adduser -U logan -u 1000 \
    && mkdir -p /home/logan/local \
    && chown -R logan:logan /home/logan \
    && mkdir -p /opt/data \
    && chown -R logan:logan /opt/data

# Docker for java bug: https://github.com/docker/docker/issues/15020
ENV MALLOC_ARENA_MAX="4"

ENV APP_OPTS=""

ENV JMX_OPTS="-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.local.only=false -Djava.rmi.server.hostname=127.0.0.1 -Dcom.sun.management.jmxremote.rmi.port=1099 -Dcom.sun.management.jmxremote.port=1099"

ENV GCLOG_OPTS="-Xloggc:/tmp/logan-gc.log -XX:+PrintGCDateStamps -XX:+PrintGCDetails -XX:+UseGCLogFileRotation -XX:NumberOfGCLogFiles=10 -XX:GCLogFileSize=10M"

ENV JAVA_OPTS="-Xmx1024m -Xms512m -XX:NewRatio=1 -XX:+UseConcMarkSweepGC -XX:CMSInitiatingOccupancyFraction=75 \
-XX:+UseCMSInitiatingOccupancyOnly -XX:ReservedCodeCacheSize=128M -XX:ParallelGCThreads=2 \
-XX:+ExplicitGCInvokesConcurrent -Duser.timezone=Asia/Shanghai"


COPY target/logan-javaboot-sample-*.jar /home/logan/local/logan-javaboot-sample.jar

ENTRYPOINT [ "sh", "-c", "java $APP_OPTS $JMX_OPTS $JAVA_OPTS $GCLOG_OPTS -Djava.security.egd=file:/dev/./urandom -jar logan-javaboot-sample.jar" ]

WORKDIR /home/logan/local

USER logan
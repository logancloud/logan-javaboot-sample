#!/usr/bin/env bash
mvn -DskipTests clean package
docker build . -t logancloud/logan-javaboot-sample:latest
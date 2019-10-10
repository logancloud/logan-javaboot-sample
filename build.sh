#!/usr/bin/env bash

mvn clean package
docker build . -t logancloud/logan-javaboot-sample:latest



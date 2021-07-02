#!/bin/bash
# Install other packages
sudo apt-get update && sudo apt-get install apt-transport-https ca-certificates gnupg default-jdk maven git -y
# Auth
sudo gcloud auth activate-service-account hw14-86@principal-rope-318517.iam.gserviceaccount.com --key-file=/home/test/credentials.json --project=principal-rope-318517
# Build app
mkdir /opt/boxfuse 
mkdir -p /opt/tomcat/latest/webapps/
git clone https://github.com/boxfuse/boxfuse-sample-java-war-hello.git /opt/boxfuse/
mvn -f /opt/boxfuse/pom.xml package
cp /opt/boxfuse/target/hello-1.0.war /opt/tomcat/latest/webapps/
# Copy apps to basket
gsutil rsync -r /opt/tomcat/latest/webapps/ gs://hw14-data/
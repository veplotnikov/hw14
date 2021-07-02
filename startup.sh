#!/bin/bash
# Install gcloud and other packages
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
sudo apt-get update && sudo apt-get install apt-transport-https ca-certificates gnupg default-jdk maven git -y
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
sudo apt-get update && sudo apt-get install google-cloud-sdk -y
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
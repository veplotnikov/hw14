#!/bin/bash
adduser test --disabled-password --gecos GECOS
mkdir /home/test/.ssh
echo ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDMgPZW7wQKRl9R86ArCnO3cbgfAMQNYjrxvtpGENXRSJtHjVG1ZEM8UdL8WoLnVF8ID9gbd4FQpAvWTE5uSTqusu0CX+T5BmR9YvVd6hxdteuCzKiURhP58Z+2KG6SGBIi13K4p7x2fMmaGbGaqEfQBL+3y77lHqLYnreL89Ef2pnF7+SKmu3763lfT1RS9wd+8y8LPXOVrOT2EwGunlqcxSYPSWkgvZVr4/EetJqtffYtD1JY0j9e66YwRn1fG61D8p8Lgj4aR26oT3fzvBncc4StZk4csyLxuJMHkFzwyZf3/oTxF7edoDiLias08Rrzj/NsQkMkLzjEpYWS8yoBPLvA3AfwIJtGOUIaRZVBjIgTfytt8ltA/Dgs0+F2WRvKWPeyNRPNHswfGguOwoYQsEmnBT3fXw/ggensD1SAt3t/kcvrnplfnhyJs1/2V8PPOPmVLUuuX2MBnVNG3ThkgsHQk69IvCsWfwoaAs8/3mTWq0rePIP8nR5J9Qc5iyM= test@instance-1 > /home/test/.ssh/authorized_keys
# Install gcloud and other packages
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
sudo apt-get update && apt-get install apt-transport-https ca-certificates gnupg default-jdk maven git -y
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
sudo apt-get update && sudo apt-get install google-cloud-sdk -y
# Auth
gcloud auth activate-service-account hw14-86@principal-rope-318517.iam.gserviceaccount.com --key-file=/home/test/credentials.json --project=principal-rope-318517
# Build app
mkdir /opt/boxfuse 
mkdir -p /opt/tomcat/latest/webapps/
git clone https://github.com/boxfuse/boxfuse-sample-java-war-hello.git /opt/boxfuse/
mvn -f /opt/boxfuse/pom.xml package
cp /opt/boxfuse/target/hello-1.0.war /opt/tomcat/latest/webapps/
# Copy apps to basket
gsutil rsync -r /opt/tomcat/latest/webapps/ gs://hw14-data/
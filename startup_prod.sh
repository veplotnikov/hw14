#!/bin/bash
sudo apt-get update && sudo apt-get install tomcat9 -y
sudo gcloud auth activate-service-account hw14-86@principal-rope-318517.iam.gserviceaccount.com --key-file=/home/test/credentials.json --project=principal-rope-318517
gsutil rsync -r  gs://hw14-data/ /var/lib/tomcat9/webapps/
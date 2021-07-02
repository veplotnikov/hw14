#!/bin/bash
sudo gcloud auth activate-service-account hw14-86@principal-rope-318517.iam.gserviceaccount.com --key-file=/home/test/credentials.json --project=principal-rope-318517
sudo apt install tomcat9
gsutil rsync -r  gs://hw14-data/ /opt/
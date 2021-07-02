#!/bin/bash
#adduser test --disabled-password --gecos GECOS
#mkdir /home/test/.ssh
ssh-keys = "test:${file("/home/test/.ssh/id_rsa.pub")}"
echo hi > /test.txt
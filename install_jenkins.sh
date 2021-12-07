#!/bin/bash
sudo yum update –y
sudo amazon-linux-extras install epel -y
sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo yum upgrade
sudo yum install jenkins java-1.8.0-openjdk-devel -y
sudo yum install nfs-utils -y
sudo /etc/init.d/jenkins status
sudo systemctl daemon-reload
sudo /etc/init.d/jenkins start
sudo /etc/init.d/jenkins status

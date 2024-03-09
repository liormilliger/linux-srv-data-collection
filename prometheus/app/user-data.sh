#!/bin/bash

# Updating system with packages
apt update

# Installing dependencies
apt install docker -y
apt install docker.io -y
apt install docker-compose -y
usermod -aG docker ubuntu
apt install awscli -y
apt install git -y

# Creating and permitting monitoring.log
mkdir /home/ubuntu/systemlogs
touch /home/ubuntu/systemlogs/monitoring.log
chmod 666 /home/ubuntu/systemlogs/monitoring.log

# Cloning Repo
cd /home/ubuntu
git clone https://github.com/liormilliger/prometheus-data-collector.git

# Running a first system scan
sh /home/ubuntu/prometheus-data-collector/app/data-collector.sh >> /home/ubuntu/systemlogs/monitoring.log 2>&1

# Running cronjob
(crontab -u ubuntu -l ; echo "* * * * * ~/prometheus-data-collector/app/data-collector.sh >> ~/systemlogs/monitoring.log 2>&1") | crontab -u ubuntu -

# Connecting to ECR
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 704505749045.dkr.ecr.us-east-1.amazonaws.com

cd prometheus-data-collector/app

docker-compose up -d

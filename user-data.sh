#!/bin/bash

# Updating system with packages
apt update

# Installing dependencies
apt install docker -y
apt install docker.io -y
usermod -aG docker ubuntu
apt install awscli -y

# Creating and permitting monitoring.log
mkdir /home/ubuntu/systemlogs
touch /home/ubuntu/systemlogs/monitoring.log
chmod 777 /home/ubuntu/systemlogs/monitoring.log

# Creating Script for collecting data on home directory
cat << 'EOL' > /home/ubuntu/data-collector.sh
#!/bin/bash

# Collect monitoring data
mem_usage=$(free | awk "/Mem/{printf \$3/\$2*100}")
cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
disk_status=$(df -h | grep '/$' | awk '{print $5}')

# Write data to a file (you may modify this to your preferred format)
echo "Memory Usage: ${mem_usage}%"
echo "CPU Usage: ${cpu_usage}%"
echo "Disk Status: ${disk_status}"

EOL

# Changing permissions
chmod +x /home/ubuntu/data-collector.sh

# Running a first system scan
sh /home/ubuntu/data-collector.sh >> /home/ubuntu/systemlogs/monitoring.log 2>&1

# Running cronjob
(crontab -u ubuntu -l ; echo "* * * * * ~/data-collector.sh >> ~/systemlogs/monitoring.log 2>&1") | crontab -u ubuntu -

# Connecting to ECR
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 704505749045.dkr.ecr.us-east-1.amazonaws.com

# Running the application container
docker run -d --name monitoring-app -p 80:80 -v /home/ubuntu/systemlogs:/host_logs 704505749045.dkr.ecr.us-east-1.amazonaws.com/liorm-nanox:monitor-app
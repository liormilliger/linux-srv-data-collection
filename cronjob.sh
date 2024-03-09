#!/bin/bash


# Define the monitoring script content
monitoring_script_content=$(cat <<EOF
#!/bin/bash

# Collect monitoring data
mem_usage=$(free | awk "/Mem/{printf \$3/\$2*100}")
cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk "{print 100 - \$1}")
disk_status=$(df -h | grep '/$' | awk '{print $5}')

# Write data to a file (you may modify this to your preferred format)
echo "Memory Usage: \${mem_usage}%"
echo "CPU Usage: \${cpu_usage}%"
echo "Disk Status: \${disk_status}"
EOF
)

# Write the monitoring script to a file
echo "$monitoring_script_content" > ./data-collector.sh

# Give execute permissions to the monitoring script
chmod +x ./data-collector.sh

# # Add the cron job to the user's crontab
(crontab -l ; echo "* * * * * ~/data-collector.sh >> ~/systemlogs/monitoring.log 2>&1") | crontab -

#!/bin/bash

# Collect monitoring data
mem_usage=$(free | awk "/Mem/{printf \$3/\$2*100}")
cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk "{print 100 - \$1}")
disk_status=$(df -h | grep '/$' | awk '{print $5}')

# Write data to a file (you may modify this to your preferred format)
echo "Memory Usage: ${mem_usage}%"
echo "CPU Usage: ${cpu_usage}%"
echo "Disk Status: ${disk_status}"
#!/bin/bash

# Collect monitoring data
mem_usage=$(free | awk "/Mem/{printf \$3/\$2*100}")

cpu_usage=$(mpstat -P ALL | awk 'NR==1 {print $2, $3}; NR>2 {print $2, $3}')
# mpstat -P ALL displays statistics about CPU usage for all CPUs individually
# awk NR==1 {print $2, $3} prints the values of 2nd and 3rd filed in the first line of the output (Headers)
# (awk) NR>2 {print $2, $3} conditional that prints 2nd and 3rd column of each record (line) from line 2 and on 

disk_status=$(df | awk '$NF == "/" {print $(NF-1)}')
# This command takes from df output the record where root volume is ($NF == "/")
# and prints the % usage in one-before-last column {print $(NF-1)}

# Write data to a file (you may modify this to your preferred format)
echo "Memory Usage: ${mem_usage}%"
echo "CPU Usage: ${cpu_usage}%"
echo "Disk Status: ${disk_status}"
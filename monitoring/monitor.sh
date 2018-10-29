#! /bin/bash

# REFERENCES:
# https://nvidia.custhelp.com/app/answers/detail/a_id/3751/~/useful-nvidia-smi-queries
# http://www.systeen.com/2016/05/07/bash-script-monitor-cpu-memory-disk-usage-linux/

# How to run this script
# <hours>: Time this scrip will be running
# <granularity>: Time in seconds on which each sample will be taken
# <logs-path>: Absolute path to the fila that will contain the output
# ./monitor.sh <hours> <granularity> <logs-path>
# ./monitor.sh 1 5 ${PWD}/monitor.log

# SECONDS -- The number of seconds since the shell started or, if the parameter has been assigned an integer value, 
# the number of seconds since the assignment plus the value that was assigned.

# This script will run about 1 hour = 3600 seconds
RUNNING_SECONDS=$(($1*3600))
# end=$((SECONDS+3600))
end=$((SECONDS+RUNNING_SECONDS))
while [ $SECONDS -lt $end ]; do

# CPU_USAGE=$(top -bn1 | grep load | awk '{printf "%.2f%%\t", $(NF-2)}')
CPU_USAGE=$(top -bn1 | grep load | awk '{printf "%s\t", substr($(NF-2),0,4)}')
CPU_TEMP=$(cat /sys/class/thermal/thermal_zone0/temp | awk 'NR==1{printf "%f\t",$1/1000}')

CPU_MEMORY_USAGE=$(free -m | awk 'NR==2{printf "%.2f%%\t", $3*100/$2 }')
CPU_MEMEORY_TOTAL=$(free -m | awk 'NR==2{printf "%i\t", $2 }')
CPU_MEMEORY_USED=$(free -m | awk 'NR==2{printf "%i\t", $3 }')
CPU_MEMORY_FREE=$(free -m | awk 'NR==2{printf "%i\t", $4 }')

CPU_DISK_USAGE=$(df -h | awk '$NF=="/"{printf "%s\t", $5}')

CPU_METRICS="$CPU_USAGE$CPU_TEMP$CPU_MEMORY_USAGE$CPU_MEMEORY_TOTAL$CPU_MEMEORY_USED$CPU_MEMORY_FREE$CPU_DISK_USAGE"

# GPU METRICS
# -timesptamp: The timestamp of where the query was made in format "YYYY/MM/DD HH:MM:SS.msec".
GPU_TIMESTAMP=$(nvidia-smi --query-gpu=timestamp --format=csv,noheader,nounits | awk 'NR=1{printf "%s %s\t",$1,$2}')
# -name: The official product name of the GPU. This is an alphanumeric string. For all products.
GPU_NAME=$(nvidia-smi --query-gpu=name --format=csv,noheader,nounits | awk 'NR=1{printf "%s %s %s\t",$1,$2,$3}')
# -driver_version: The version of the installed NVIDIA display driver. This is an alphanumeric string.
GPU_DRIVER=$(nvidia-smi --query-gpu=driver_version --format=csv,noheader,nounits | awk 'NR=1{printf "%s\t",$1}')
# -pstate: The current performance state for the GPU. States range from P0 (maximum performance) 
# 	to P12 (minimum performance).
GPU_PST=$(nvidia-smi --query-gpu=pstate --format=csv,noheader,nounits | awk 'NR=1{printf "%s\t",$1}')
# -temperature.gpu: Core GPU temperature. in degrees C.
GPU_TEMP=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits | awk 'NR=1{printf "%s\t",$1}')
# -utilization.gpu: Percent of time over the past sample period during which one or more kernels was
# 	executing on the GPU. The sample period may be between 1 second and 1/6 second depending on the product.
GPU_USAGE=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits | awk 'NR=1{printf "%s\t",$1}')
# -utilization.memory: Percent of time over the past sample period during which global (device) memory
# 	was being read or written. The sample period may be between 1 second and 1/6 second depending on the product.
GPU_MEMORY_USAGE=$(nvidia-smi --query-gpu=utilization.memory --format=csv,noheader,nounits | awk 'NR=1{printf "%s\t",$1}')
# -memory.total: Total installed GPU memory.
GPU_MEMORY_TOTAL=$(nvidia-smi --query-gpu=memory.total --format=csv,noheader,nounits | awk 'NR=1{printf "%s\t",$1}')
# -memory.used: Total memory allocated by active contexts.
GPU_MEMORY_USED=$(nvidia-smi --query-gpu=memory.used --format=csv,noheader,nounits | awk 'NR=1{printf "%s\t",$1}')
# -memory.free: Total free memory.
GPU_MEMORY_FREE=$(nvidia-smi --query-gpu=memory.free --format=csv,noheader,nounits | awk 'NR=1{printf "%s\t",$1}')

GPU_METRICS="$GPU_NAME$GPU_DRIVER$GPU_PST$GPU_TEMP$GPU_USAGE$GPU_MEMORY_USAGE$GPU_MEMORY_TOTAL$GPU_MEMORY_USED$GPU_MEMORY_FREE"

METRICS="$GPU_TIMESTAMP$CPU_METRICS$GPU_METRICS"

echo "$METRICS" >> $3
echo "$METRICS"

# sleep 5
sleep $2
done

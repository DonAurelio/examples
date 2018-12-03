#! /bin/bash

# REFERENCES:
# https://nvidia.custhelp.com/app/answers/detail/a_id/3751/~/useful-nvidia-smi-queries
# http://www.systeen.com/2016/05/07/bash-script-monitor-cpu-memory-disk-usage-linux/
# https://linux.die.net/man/1/iostat

# HOW TO RUN THIS SCRIPT
# ./monitor.sh

# USE THIS SCRIPT AS A CRONJOB
# crontab -e 
# */1 * * * * /home/<your-user>/monitor/monitor.sh >> /home/<your-user>/monitor/out.log 2>> /home/<your-user>/monitor/err.log
# To list existing cron jobs:
# crontab –l
# To remove an existing cron job:
# Enter: crontab –e
# Delete the line that contains your cron job
# Hit ESC > :w > :q

DATE=$(date '+%Y-%m-%d %H:%M:%S')

# CPU METRICTS

# Avrrage percentage of CPU utilization
CPU_USAGE=$(top -bn 1 | awk 'NR==3{printf "%s", $2}')

# iowait: Percentage of time that the CPU or CPUs were idle during which the system had an outstanding disk I/O request.
# https://haydenjames.io/linux-server-performance-disk-io-slowing-application/
CPU_IOWAIT=$(top -bn 1 | awk 'NR==3{printf "%s", $10}')

# RAM memory percentage total memory / used 
CPU_MEMORY_USAGE=$(free -m | awk 'NR==2{printf "%.2f", $3*100/$2 }')

CPU_METRICS="$CPU_USAGE\t$CPU_IOWAIT\t$CPU_MEMORY_USAGE\t" 

# DISK METRICS
# %util : Percentage of CPU time during which I/O requests were issued to the device (bandwidth utilization for the device). 
# Device saturation occurs when this value is close to 100%.
DISK_USGAE=$(iostat -d -x sda | awk 'NR==4{printf "%s",$16 }')

# svctm : The average service time (in milliseconds) for I/O requests that were issued to the device
DISK_SERVICE_TIME=$(iostat -d -x sda | awk 'NR==4{printf "%s",$15 }')


DISK_METRICS="$DISK_USGAE\t$DISK_SERVICE_TIME\t"

# GPU METRICS
# -timesptamp: The timestamp of where the query was made in format "YYYY/MM/DD HH:MM:SS.msec".
# GPU_TIMESTAMP=$(nvidia-smi --query-gpu=timestamp --format=csv,noheader,nounits | awk 'NR=1{printf "%s %s\t",$1,$2}')
# -name: The official product name of the GPU. This is an alphanumeric string. For all products.
# GPU_NAME=$(nvidia-smi --query-gpu=name --format=csv,noheader,nounits | awk 'NR=1{printf "%s %s %s\t",$1,$2,$3}')
# -driver_version: The version of the installed NVIDIA display driver. This is an alphanumeric string.
# GPU_DRIVER=$(nvidia-smi --query-gpu=driver_version --format=csv,noheader,nounits | awk 'NR=1{printf "%s\t",$1}')
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
# GPU_MEMORY_TOTAL=$(nvidia-smi --query-gpu=memory.total --format=csv,noheader,nounits | awk 'NR=1{printf "%s\t",$1}')
# -memory.used: Total memory allocated by active contexts.
# GPU_MEMORY_USED=$(nvidia-smi --query-gpu=memory.used --format=csv,noheader,nounits | awk 'NR=1{printf "%s\t",$1}')
# -memory.free: Total free memory.
# GPU_MEMORY_FREE=$(nvidia-smi --query-gpu=memory.free --format=csv,noheader,nounits | awk 'NR=1{printf "%s\t",$1}')

GPU_METRICS="$GPU_PST\t$GPU_TEMP\t$GPU_USAGE\t$GPU_MEMORY_USAGE\t"

METRICS="$DATE\t$DISK_METRICS$CPU_METRICS$GPU_METRICS"

echo -e "$METRICS"

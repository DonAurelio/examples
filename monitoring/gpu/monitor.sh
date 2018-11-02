#! /bin/bash

# REFERENCES:
# https://nvidia.custhelp.com/app/answers/detail/a_id/3751/~/useful-nvidia-smi-queries
# http://www.systeen.com/2016/05/07/bash-script-monitor-cpu-memory-disk-usage-linux/
# https://linux.die.net/man/1/iostat

# HOW TO RUN THIS SCRIPT
# ./monitor.sh

# USE THIS SCRIPT AS A CRONJOB
# crontab -e 
# */1 * * * * /home/mpiuser/monitor/monitor.sh >> /home/mpiuser/monitor/out.log 2>> /home/mpiuser/monitor/err.log
# To list existing cron jobs:
# crontab –l
# To remove an existing cron job:
# Enter: crontab –e
# Delete the line that contains your cron job
# Hit ESC > :w > :q


DATE=$(date '+%Y-%m-%d %H:%M:%S')

# CPU METRICTS

# CPU load is an average that measures what is the real capacity of the system, it depends by the number of cores 
# of the system. Ex: if you have a single core processor, the load could range from 0.00 to 1.00. If you get 1.00 
# it meas your system is full of processes (that is translated to 100% of utilization). If it get a value > 1.00
# it meas there are processes waiting and your system performance could decrease.
# In a two core machine, this varlue cloud rango from 0.00 to 2.00, 2.00 means your sistem is at its maximun capacity.
CPU_CORE_COUNT=$(lscpu | awk 'NR==4{ printf "%s\t", $2 }')
CPU_LOAD=$(top -bn1 | grep load | awk '{printf "%s\t", substr($(NF-2),0,4)}')

# user: Percentage of CPU utilization that occurred while executing at the user level (application).
CPU_USAGE_USER=$(iostat | awk 'NR==4{ printf "%.2f\t", $1 }')
# nice: Percentage of CPU utilization that occurred while executing at the user level with nice priority.
CPU_USAGE_NICE=$(iostat | awk 'NR==4{ printf "%.2f\t", $2 }')
# system: Percentage of CPU utilization that occurred while executing at the system level (kernel).
CPU_USAGE_SYSTEM=$(iostat | awk 'NR==4{ printf "%.2f\t", $3 }')
# iowait: Percentage of time that the CPU or CPUs were idle during which the system had an outstanding disk I/O request.
CPU_USAGE_IOWAIT=$(iostat | awk 'NR==4{ printf "%.2f\t", $4 }')
# steal: Percentage of time spent in involuntary wait by the virtual CPU or CPUs while the hypervisor was servicing another virtual processor.
CPU_USAGE_STEAL=$(iostat | awk 'NR==4{ printf "%.2f\t", $4 }')
# idle: Percentage of time that the CPU or CPUs were idle and the system did not have an outstanding disk I/O request.
CPU_USAGE_IDLE=$(iostat | awk 'NR==4{ printf "%.2f\t", $6 }')


CPU_METRICS="$CPU_CORE_COUNT	$CPU_LOAD$CPU_USAGE_USER$CPU_USAGE_NICE$CPU_USAGE_SYSTEM$CPU_USAGE_IOWAIT$CPU_USAGE_STEAL$CPU_USAGE_IDLE" 


# CPU MEMORY METRICTS
CPU_MEMORY_USAGE=$(free -m | awk 'NR==2{printf "%.2f%%\t", $3*100/$2 }')
CPU_MEMEORY_TOTAL=$(free -m | awk 'NR==2{printf "%i\t", $2 }')
CPU_MEMEORY_USED=$(free -m | awk 'NR==2{printf "%i\t", $3 }')
CPU_MEMORY_FREE=$(free -m | awk 'NR==2{printf "%i\t", $4 }')

CPU_DISK_USAGE=$(df -h | awk '$NF=="/"{printf "%s\t", $5}')


CPU_METRICS="$CPU_METRICS$CPU_MEMORY_USAGE$CPU_MEMEORY_TOTAL$CPU_MEMEORY_USED$CPU_MEMORY_FREE$CPU_DISK_USAGE"

# GPU METRICS
# -timesptamp: The timestamp of where the query was made in format "YYYY/MM/DD HH:MM:SS.msec".
# GPU_TIMESTAMP=$(nvidia-smi --query-gpu=timestamp --format=csv,noheader,nounits | awk 'NR=1{printf "%s %s\t",$1,$2}')
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

METRICS="$DATE	$CPU_METRICS$GPU_METRICS"

echo "$METRICS"

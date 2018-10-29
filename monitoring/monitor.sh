#! /bin/bash

# REFERENCES:
# https://nvidia.custhelp.com/app/answers/detail/a_id/3751/~/useful-nvidia-smi-queries
# http://www.systeen.com/2016/05/07/bash-script-monitor-cpu-memory-disk-usage-linux/



GPU_METRICS=$(nvidia-smi --query-gpu=timestamp,name,driver_version,pstate,temperature.gpu,utilization.gpu,utilization.memory,memory.total,memory.free,memory.used --format=csv
)

# CPU METRICTS


printf "Memory\t\tDisk\t\tCPU\n"
end=$((SECONDS+3600))
while [ $SECONDS -lt $end ]; do

CPU_USAGE=$(top -bn1 | grep load | awk '{printf "%.2f%%\t\t", $(NF-2)}')
CPU_TEMP=$(cat /sys/class/thermal/thermal_zone0/temp | awk 'NR==1{printf "%f\t\t",$1/1000}')

CPU_MEMORY_USAGE=$(free -m | awk 'NR==2{printf "%.2f%%\t\t", $3*100/$2 }')
CPU_MEMEORY_TOTAL=$(free -m | awk 'NR==2{printf "%i\t\t", $2 }')
CPU_MEMEORY_USED=$(free -m | awk 'NR==2{printf "%i\t\t", $3 }')
CPU_MEMORY_FREE=$(free -m | awk 'NR==2{printf "%i\t\t", $4 }')

CPU_DISK_USAGE=$(df -h | awk '$NF=="/"{printf "%s\t\t", $5}')

CPU_METRICS="$CPU_USAGE$CPU_TEMP$CPU_MEMORY_USAGE$CPU_MEMEORY_TOTAL$CPU_MEMEORY_USED$CPU_MEMORY_FREE$CPU_DISK_USAGE"

# GPU METRICS
# -timesptamp: The timestamp of where the query was made in format "YYYY/MM/DD HH:MM:SS.msec".
GPU_TIMESTAMP=$(nvidia-smi --query-gpu=timestamp --format=csv,noheader,nounits)
# -name: The official product name of the GPU. This is an alphanumeric string. For all products.
GPU_NAME=$(nvidia-smi --query-gpu=name --format=csv,noheader,nounits)
# -driver_version: The version of the installed NVIDIA display driver. This is an alphanumeric string.
GPU_DRIVER=$(nvidia-smi --query-gpu=driver_version --format=csv,noheader,nounits)
# -pstate: The current performance state for the GPU. States range from P0 (maximum performance) 
# 	to P12 (minimum performance).
GPU_PST=$(nvidia-smi --query-gpu=pstate --format=csv,noheader,nounits)
# -temperature.gpu: Core GPU temperature. in degrees C.
GPU_TEMP=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits)
# -utilization.gpu: Percent of time over the past sample period during which one or more kernels was
GPU_USAGE=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits)
# 	executing on the GPU. The sample period may be between 1 second and 1/6 second depending on the product.
# -utilization.memory: Percent of time over the past sample period during which global (device) memory
# 	was being read or written. The sample period may be between 1 second and 1/6 second depending on the product.
# -memory.total: Total installed GPU memory.
# -memory.free: Total free memory.
# -memory.used: Total memory allocated by active contexts.

GPU_METRICS=$(nvidia-smi --query-gpu=timestamp,name,driver_version,pstate,temperature.gpu,utilization.gpu,utilization.memory,memory.total,memory.free,memory.used --format=csv
)

echo "$MEMORY$DISK$CPU"
sleep 5
done

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
METRICS="$DATE"

function cpu_metrics(){
	CPU_USAGE=$(mpstat 1 1 | grep Average | awk 'NR==1{printf "%s",$3}')
	CPU_COUNT=$(nproc --all)
	METRICS=$METRICS,$CPU_USAGE,$CPU_COUNT
}

function memory_metrics(){
	# Place main memory statistics in Megabytes
	MEM_TOTAL=$(free -m -t | grep Total | awk 'NR==1{printf "%s",$2}')
	MEM_USED=$(free -m -t | grep Total | awk 'NR==1{printf "%s",$3}')
	METRICS="$METRICS,$MEM_TOTAL,$MEM_USED"
}

function disk_metrics(){
	# The number of kilobytes read from the device per second.
	DISK_READS=$(iostat -x -d sda 1 2 | grep sda | awk 'NR==2{printf "%s",$4}')
	# The number of kilobytes written to the device per second.
	DISK_WRITES=$(iostat -x -d sda 1 2 | grep sda | awk 'NR==2{printf "%s",$5}')
	# Percentage of CPU time during which I/O requests were issued to the device (bandwidth utilization for the device). 
	# Device saturation occurs when this value is close to 100%.
	DISK_USAGE=$(iostat -x -d sda 1 2 | grep sda | awk 'NR==2{printf "%s",$16}')
	METRICS="$METRICS,$DISK_READS,$DISK_WRITES,$DISK_USAGE"
}



# Parsing argumnets
POSITIONAL=''
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -cpu)
	# COMMAND HERE ....
    shift # past argument
    # shift # past value
    ;;
    -gpu)
	# COMMAND HERE ....
    shift # past argument
    # shift # past value
    ;;
    -memory)
	# COMMAND HERE ....
    shift # past argument
    # shift # past value
    ;;
    -disk)
    disk_name="$2"
    # add_master $HOST_IP
    # COMMAND HERE ....
    shift # past argument
    shift # past value
    ;;
    -network)
    nic_name="$2"
    # add_master $HOST_IP
    # COMMAND HERE ....
    shift # past argument
    shift # past value
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    echo "The $POSITIONAL arguments is not a valid argument"
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

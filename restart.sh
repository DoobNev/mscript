#!/bin/bash

# Command to run the miner
COMMAND="./xelis-taxminer --host 5.39.223.70:8080 --wallet xel:qn8qqv7s3ruzel8dq9lp4shfxksapvq58cp2ul0cwpc2zpa6tansqqsc2ll"
# Log file path
LOG_FILE="/var/log/xelis-taxminer-gpu-monitor.log"

# Function to start the miner
start_miner() {
    echo "$(date): Starting xelis-taxminer..." | tee -a $LOG_FILE
    $COMMAND &
    MINER_PID=$!
    echo "$(date): Miner PID is $MINER_PID" | tee -a $LOG_FILE
}

# Function to check GPU usage
check_gpu_usage() {
    # Get the utilization of each GPU
    GPU_USAGE=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits)
    echo "$(date): GPU Usage: $GPU_USAGE" | tee -a $LOG_FILE
    
    # Check if all GPUs are below the usage threshold
    if echo "$GPU_USAGE" | awk '{if ($1 > 10) exit 1}' ; then
        return 1
    else
        return 0
    fi
}

# Start the miner initially
start_miner

# Monitor loop
while true; do
    sleep 30
    if check_gpu_usage ; then
        echo "$(date): GPUs appear to be idle." | tee -a $LOG_FILE
        echo "$(date): Killing miner with PID $MINER_PID." | tee -a $LOG_FILE
        kill $MINER_PID
        wait $MINER_PID
        start_miner
    else
        echo "$(date): GPUs are active." | tee -a $LOG_FILE
    fi
done

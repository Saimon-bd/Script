#!/bin/bash

# Slack Webhook URL for sending notifications
SLACK_WEBHOOK_URL="YOUR_SLACK_WEBHOOK_URL_HERE"

# Function to send notification to Slack
send_slack_notification() {
    local message="$1"
    curl -X POST -H 'Content-type: application/json' --data "{'text':'$message'}" "$SLACK_WEBHOOK_URL"
}

# Function to check VM health
check_vm_health() {
    local cpu_threshold=70   # Set your desired CPU threshold percentage here
    local memory_threshold=80  # Set your desired memory threshold percentage here

    # Get CPU utilization and memory usage
    cpu_utilization=$(top -b -n 1 | grep "Cpu(s)" | awk '{print $2}')
    memory_usage=$(free | awk '/Mem/{printf("%.2f"), $3/$2*100}')

    # Check CPU and memory thresholds
    if (( $(echo "$cpu_utilization > $cpu_threshold" | bc -l) )); then
        send_slack_notification "CPU utilization high on Linux VM! Current: $cpu_utilization%"
    fi

    if (( $(echo "$memory_usage > $memory_threshold" | bc -l) )); then
        send_slack_notification "Memory running out on Linux VM! Current: $memory_usage%"
    fi
}

# Check the VM health
check_vm_health

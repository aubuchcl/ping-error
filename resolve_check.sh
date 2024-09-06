#!/bin/bash

# Check if the HOST environment variable is set, otherwise exit
if [ -z "$HOST" ]; then
  echo "HOST environment variable is not set. Exiting..."
  exit 1
fi

# Generate a timestamp for the log file name (format: YYYYMMDD_HHMMSS)
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
LOG_FILE="/app/logs/ping_output_$TIMESTAMP.log"

# Run ping command 100 times in a loop
for i in {1..100}; do
  # Perform the ping command with -c 1 (single ping)
  PING_OUTPUT=$(ping -c 1 "$HOST" 2>&1)

  # Check if the ping command failed due to DNS resolution (host not found)
  if echo "$PING_OUTPUT" | grep -q "Name or service not known"; then
    # Log the failure due to DNS resolution error
    RESULT="[$(date)] $HOST: Ping failed - IP not resolved"
    echo "$RESULT"
    echo "$RESULT" >> "$LOG_FILE"
  else
    # Extract the resolved IP address from the ping output
    IP_ADDRESS=$(echo "$PING_OUTPUT" | grep -oP '(?<=\().*(?=\))' | head -n 1)
    
    # Log the success with the resolved IP address
    RESULT="[$(date)] $HOST: Success - IP = $IP_ADDRESS"
    echo "$RESULT"
    echo "$RESULT" >> "$LOG_FILE"
  fi
done

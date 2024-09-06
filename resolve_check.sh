#!/bin/bash

# Check if the HOST environment variable is set, otherwise exit
if [ -z "$HOST" ]; then
  echo "HOST environment variable is not set. Exiting..."
  exit 1
fi

# Generate a timestamp for the log file name (format: YYYYMMDD_HHMMSS)
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
LOG_FILE="/app/logs/error_output_$TIMESTAMP.log"

# Ping the host with a count of 1 and only look for errors (suppress successful output)
if ! ping -c 1 "$HOST" &> /dev/null
then
  # If the ping fails, capture the error message
  ERROR_MSG="[$(date)] Failed to resolve or ping the host: $HOST"

  # Print the error message to stdout
  echo "$ERROR_MSG"

  # Also log the error message to a timestamped file in the volume
  echo "$ERROR_MSG" >> "$LOG_FILE"
fi

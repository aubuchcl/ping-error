# Use the official Ubuntu base image
FROM ubuntu:latest

# Set environment variables to avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Update and install necessary packages
RUN apt-get update && apt-get install -y \
    iputils-ping \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Copy the resolve check script into the container
COPY resolve_check.sh /app/resolve_check.sh

# Make the script executable
RUN chmod +x /app/resolve_check.sh

# Create a volume that will be mounted to store error logs
VOLUME ["/app/logs"]

# Set the default command to execute the script when the container starts
CMD ["./resolve_check.sh"]

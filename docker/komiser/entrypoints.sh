#!/bin/sh

# Create .aws directory if it does not exist
if [ ! -d "/root/.aws" ]; then
  echo "Initializing .aws directory..."
  mkdir -p /root/.aws

  # Create dummy config file
  echo "[default]
region = us-east-1" > /root/.aws/config

  # Create dummy credentials file
  echo "[default]
aws_access_key_id = test
aws_secret_access_key = test" > /root/.aws/credentials
  echo ".aws directory initialized successfully."
fi

# Execute the original entrypoint
exec komiser start "$@"

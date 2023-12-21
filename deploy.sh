#!/bin/bash

S3_BUCKET="s3-landing-dev-lucas"
TIMESTAMP_PATTERN="$1"

# Retrieve the list of log files from S3 matching the timestamp pattern
log_file=$(find . -name changed_files.log)

# Check if the log file exists
if [ -z "$log_file" ]; then
  echo "No log file found for the timestamp pattern: $TIMESTAMP_PATTERN"
  exit 1
fi

while IFS= read -r line; do
  key=$(echo "$line" | grep '^Updated:' | cut -d' ' -f2- | sed 's/\.zip$//')
  app=$(echo "$line" | grep '^Updated:' | cut -d' ' -f2- | sed 's/\.zip$//' | sed 's/_[^_]*$//')


  echo "Checking Lambda function: $app"

  # Check if the Lambda function exists
  if aws lambda get-function --function-name "$app" &> /dev/null; then
    echo "Lambda function $app found. Updating..." 
    # Read the names of the updated files from the log file
    updated_files=$(grep '^Updated:' "$log_file" | cut -d' ' -f2-)

    aws lambda update-function-code \
      --function-name "$app" \
      --s3-bucket "$S3_BUCKET" \
      --s3-key "apps/${app}/${app}_${TIMESTAMP_PATTERN}.zip" \
      --no-cli-pager
  else
    echo "Lambda function $app not found"
  fi
done < "$log_file"

rm "changed_files.log"

#!/bin/bash
# Make the script executable
chmod +x deploy.sh

# Set the directory where the Lambda function code is stored
FUNCTIONS_DIR="./apps"

# Loop through each subdirectory in the specified directory
for dir in $FUNCTIONS_DIR/*; do
    if [ -d "$dir" ]; then
        function_name=$(basename $dir)
        zip_file="$dir/$function_name.zip"
        
        # Check if the Lambda function already exists
        aws lambda get-function --function-name $function_name > /dev/null 2>&1
        if [ $? -eq 0 ]; then
            # Update the code of an existing Lambda function
            aws lambda update-function-code --function-name $function_name --zip-file "fileb://$zip_file"
            echo "Updated code for Lambda function: $function_name"
        else
            # Create a new Lambda function
            aws lambda create-function --function-name $function_name --zip-file "fileb://$zip_file" --handler index.handler --runtime nodejs14.x --role arn:aws:iam::123456789012:role/lambda-role
            echo "Created new Lambda function: $function_name"
        fi
        
        # Check if the directory is not empty
        if [ -f "$dir/index.js" ]; then
            # Deploy or update the Lambda function
            # Add your deployment command here
        fi
    fi
done
#!/bin/bash

# Set the AWS region
AWS_REGION="us-east-1"

# Set the Lambda function name
FUNCTION_NAME="HelloWorld"

# Set the handler
HANDLER="index.handler"

# Set the runtime
RUNTIME="python3.8"

# Set the role ARN
ROLE_ARN=""

# Set the function code directory
FUNCTION_DIR="$(pwd)/apps/_demo-hello-world/HelloWorld.zip"

# Create the Lambda function
aws lambda create-function --function-name $FUNCTION_NAME --zip-file "fileb://$FUNCTION_DIR" --handler $HANDLER --runtime $RUNTIME --role $ROLE_ARN --region $AWS_REGION

# Verify the function creation
aws lambda get-function --function-name $FUNCTION_NAME --region $AWS_REGION

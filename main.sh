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
ROLE_ARN="arn:aws:iam::581577752758:role/data-integration-role"

# Set the function code directory
FUNCTION_DIR="./apps/_demo-hello-world/"

# Create the Lambda function
aws lambda create-function --function-name $FUNCTION_NAME --zip-file "./apps/_demo-hello-world/HelloWorld.zip" --handler $HANDLER --runtime $RUNTIME --role $ROLE_ARN --region $AWS_REGION

# Verify the function creation
aws lambda get-function --function-name $FUNCTION_NAME --region $AWS_REGION

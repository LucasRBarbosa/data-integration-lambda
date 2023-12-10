# Makefile
CC = python -m pip
CC_PACKAGE = -m pip
CC_INSTALL = python -m pip install

all: deploy_lambda_function

deploy_lambda_function:
    @aws lambda deploy --profile prod
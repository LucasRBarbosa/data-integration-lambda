def lambda_handler(event, context):
    print("Hello World")
    print(event["key2"])
    print(event["key1"])
    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!')
    })
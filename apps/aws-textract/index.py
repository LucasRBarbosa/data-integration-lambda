import json

def handler(event, context):
    print(event)
    print(context)
    print("Hello World - first sign of intelligent life")
    
    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!')
    }


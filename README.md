# Purpose
This excellent tutorial was created from the following article:
https://www.bitovi.com/blog/running-aws-resources-on-localstack

# AWS Services
This example uses the following stack:
  1. localstack
  1. SNS
  1. SQS
  1. Lambda

# awslocal command
I've changed all the occurrences of `aws ... --endpoint-url=http://localhost:4566 ...` to `awslocal ...` using the alias here, which shortcuts the `aws` command line to target our `localstack` in particular:
https://github.com/localstack/awscli-local#alternative

# Health
You can see list of available services using this command:
```
curl -vk https://localhost:4566/health | jq "."
```

# Stack Creation Commands
We'll use standard `docker-compose` commands to both create and destroy the stack.

## Create Stack
```
docker-compose up --build
```

## Destroy Stack
```
docker-compose down
```

# Stack Testing Commands

## SNS
```
awslocal sns publish --topic-arn arn:aws:sns:us-east-1:000000000000:testTopic --region us-east-1 --message 'Test Topic!'
```

## SQS
```
awslocal sqs send-message --queue-url http://localhost:4576/000000000000/testQueue --region us-east-1 --message-body 'Test Message!'
```

echo "Create SQS queue testQueue"
awslocal sqs create-queue --queue-name testQueue

echo "Create SNS Topic testTopic"
awslocal sns create-topic --name testTopic

echo "Subscribe testQueue to testTopic"
awslocal sns subscribe \
  --topic-arn arn:aws:sns:us-east-1:000000000000:testTopic \
  --protocol sqs \
  --notification-endpoint arn:aws:sqs:us-east-1:000000000000:testQueue

echo "Create admin"
awslocal \
 iam create-role \
 --role-name admin-role \
 --path / \
 --assume-role-policy-document file:./admin-policy.json

echo "Make S3 bucket"
awslocal s3 mb s3://lambda-functions

echo "Copy the lambda function to the S3 bucket"
awslocal s3 cp lambdas.zip s3://lambda-functions

echo "Create the lambda exampleLambda"
awslocal lambda create-function \
  --function-name exampleLambda \
  --role arn:aws:iam::000000000000:role/admin-role \
  --code S3Bucket=lambda-functions,S3Key=lambdas.zip \
  --handler index.handler \
  --runtime nodejs10.x \
  --description "SQS Lambda handler for test sqs." \
  --timeout 60 \
  --memory-size 128

echo "Map the testQueue to the lambda function"
awslocal lambda create-event-source-mapping \
  --function-name exampleLambda \
  --batch-size 1 \
  --event-source-arn "arn:aws:sqs:us-east-1:000000000000:testQueue"

echo "All resources initialized! 🚀"

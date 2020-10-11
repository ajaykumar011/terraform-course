#!/bin/bash
set -ex
AWS_REGION="ap-south-1"
cd jenkins-packer-demo2
S3_BUCKET="clodzone99"
aws s3 cp s3://${S3_BUCKET}/amivar.tf amivar.tf --region $AWS_REGION
terraform init
terraform apply -auto-approve -var APP_INSTANCE_COUNT=1 -target aws_instance.app-instance

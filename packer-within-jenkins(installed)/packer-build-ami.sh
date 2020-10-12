#!/bin/bash -xe

## Packer Log to be stored in file too ##
#If you want to log the script output
#exec > >(tee /tmp/packer-script.log|logger -t packer-script -s 2>/dev/console) 2>&1

AWS_REGION="us-east-1"

ARTIFACT=`packer build -machine-readable packer-demo.json | awk -F, '$0 ~/artifact,0,id/ {print $6}'`
echo "packer output:"
cat packer-demo.json

AMI_ID=`echo $ARTIFACT | cut -d ':' -f2`
echo "AMI ID: ${AMI_ID}"
echo "${AMI_ID}" > this-ami.txt
aws ec2 describe-images --image-ids $(<this-ami.txt) --region=us-east-1 | grep SnapshotId | tr "/" " " | awk ' {print $2}' | sed -e 's/"//g' | sed -e 's/,$//' > this-snap.txt
echo "writing amivar.tf and uploading it to s3"
echo 'variable "APP_INSTANCE_AMI" { default = "'${AMI_ID}'" }' > amivar.tf
#S3_BUCKET=`aws s3 ls --region $AWS_REGION |grep terraform-state |tail -n1 |cut -d ' ' -f3`
S3_BUCKET="cloudzone99"
aws s3 ls s3://${S3_BUCKET}/ --region $AWS_REGION
aws s3 cp amivar.tf s3://${S3_BUCKET}/amivar.tf --region $AWS_REGION

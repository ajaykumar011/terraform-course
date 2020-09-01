#!/bin/bash
#set -ex (-e exit immediately : when output of any command is non-zero and x shows the traces of each commands)
#JSON data can't be read easily from JSON file by using bash script like other normal files. jq tool is used to solve this problem
#jq command works like sed and awk command, and it uses a domain specific language for working with JSON data.

set -ex 
SERVICE_NAME=$1
IMAGE_URI="$AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$IMAGE_REPO_NAME:$CODEBUILD_RESOLVED_SOURCE_VERSION"
TASKDEF_NAME=$(aws ecs list-task-definitions |jq --raw-output '.taskDefinitionArns[] | select(contains("'${SERVICE_NAME}'"))' | tail -n1)
CURRENT_TASKDEF=`aws ecs describe-task-definition --task-definition $TASKDEF_NAME`
CURRENT_TASKDEF_CONTAINERDEF=`echo $CURRENT_TASKDEF| jq --raw-output ".taskDefinition.containerDefinitions"`
TASKDEF_ROLE_ARN=`echo $CURRENT_TASKDEF| jq --raw-output ".taskDefinition.taskRoleArn"`
EXECUTION_ROLE_ARN=`echo $CURRENT_TASKDEF| jq --raw-output ".taskDefinition.executionRoleArn"`
TASKDEF=`echo $CURRENT_TASKDEF_CONTAINERDEF | jq ' [ .[] |  .image = "'${IMAGE_URI}'" ]'`
CPU=$(echo $CURRENT_TASKDEF |jq -r '.taskDefinition.cpu')
MEMORY=$(echo $CURRENT_TASKDEF |jq -r '.taskDefinition.memory')
NETWORK_MODE=$(echo $CURRENT_TASKDEF |jq -r '.taskDefinition.networkMode')
REQUIRES_COMPATIBILITIES=$(echo $CURRENT_TASKDEF |jq '.taskDefinition.requiresCompatibilities[]' | tr '\n' ',' | sed 's/.$//')
echo '{"family": "'${SERVICE_NAME}'", "taskRoleArn": "'${TASKDEF_ROLE_ARN}'", "executionRoleArn": "'${EXECUTION_ROLE_ARN}'", "containerDefinitions": '$TASKDEF', "cpu": "'$CPU'", "memory": "'$MEMORY'", "requiresCompatibilities": ['$REQUIRES_COMPATIBILITIES'], "networkMode": "'${NETWORK_MODE}'" }' > taskdef.json
#aws ecs register-task-definition --cli-input-json file://task-def-template.json.new > task-def-template.json.out
#NEW_TASKDEF_ARN=`cat task-def-template.json.out |jq -r '.taskDefinition.taskDefinitionArn'`

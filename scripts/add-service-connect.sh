# !/bin/bash
set -e

# Requirements:
#  AWS CLI Version: 2.9.2 or higher

# source functions and arguments script
# must use . instead of 'source' for linux runs to support /bin/dash instad of /bin/bash
. ./scripts/env.sh

# Get deployed region
echo "Checking Cloudformation deployment region..."
AWS_DEFAULT_REGION=$(cat .region)
echo "Cloudformation deployment region found: ${AWS_DEFAULT_REGION}"

linebreak

# Get outputs from CFN Setup
export CLUSTER_NAME=$(getOutput 'ClusterName')

# Deploy the infrastructure, service definitions, and task definitions WITHOUT ECS Service Connect
aws --region "${AWS_DEFAULT_REGION}" \
    cloudformation deploy \
    --stack-name "greeter" \
    --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM \
    --template-file "./iac/serviceconnect-cfn.yaml" \
    --parameter-overrides \
    EnvironmentName="${ENVIRONMENT_NAME}" \
    ClusterName="${CLUSTER_NAME}" && echo "Added Amazon ECS Service Connect!"
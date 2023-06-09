#!/bin/bash
set -e

# Requirements:
#  AWS CLI Version: 2.9.2 or higher

# This script will store all functions and arguments for the 
# service connect demo

# NOTE: POSIX syntax does not use function and mandates the use of parenthesis 

# Get outputs from Cloudformation deployment
getOutput () {
    echo $(\
    aws cloudformation --region ${AWS_DEFAULT_REGION} \
    describe-stacks --stack-name greeter \
    --query "Stacks[0].Outputs[?OutputKey=='$1'].OutputValue" --output text)
}

#  Get Service ID for AWS Cloud Map Namespaces
getServiceId () {
   export namespaceId=$(getNamespaceId)
   echo $(\
        aws --region ${AWS_DEFAULT_REGION} \
        servicediscovery list-services \
        --filters Name="NAMESPACE_ID",Values=$namespaceId,Condition="EQ" \
        --query "Services[*].Id" \
        --output text
    )
}

# Get Namespace ID for AWS Cloud Map Namespaces
getNamespaceId () {
   echo $(\
      aws --region ${AWS_DEFAULT_REGION} \
      servicediscovery list-namespaces \
      --query "Namespaces[?contains(Name, 'internal')].Id" \
      --output text
   )
}

# Progress Spinner
spinner () {
local pid=$! 
while ps -a | awk '{print $1}' | grep -q "${pid}"; do
   for c in / - \\ \|; do # Loop over the sequence of spinner chars.
      # Print next spinner char.
      printf '%s\b' "$c"

      sleep .1 # Sleep, then continue the loop.
   done
   done
}

# Linebreak carriage return
linebreak () {
   printf ' \n '
}

# Delete CFN Stack
deleteCfnStack () {
   echo "Deleting '$1' CloudFormation Stack now..."
   echo "Please wait..."
   aws --profile "${AWS_PROFILE}" \
      --region "${AWS_DEFAULT_REGION}" \
      cloudformation delete-stack \
      --stack-name "$1" 

   aws --profile "${AWS_PROFILE}" \
      --region "${AWS_DEFAULT_REGION}" \
      cloudformation wait stack-delete-complete \
      --stack-name "$1" && echo "CloudFormation Stack '$1' deleted succcessfully."
}

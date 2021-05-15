#!/bin/sh

if [ ! -f ~/.ssh/id_rsa.pub ]
then
  echo "You need an SSH public key to access the cluster nodes"
  exit 1;
fi
if [ -z $1 ]
then
  echo "One argument required: cluster name (will be suffixed with .k8s.local)"
  exit 2;
fi
if [ -z $(which jq) ]
then
  echo "jq must be installed"
  exit 3;
fi
if [ -z $(which aws) ]
then
  echo "AWS CLI tool (aws) must be installed"
  exit 4;
fi
if [ -z $(which kops) ]
then
  echo "kops binary must be installed"
  exit 5;
fi

AWS_DEFAULT_REGION=$(aws configure list | grep region | awk '{ print $2 }')
echo $AWS_DEFAULT_REGION
aws --profile="$1-kops" configure list
if [ $? -ne 0 ]
then
  aws iam create-group --group-name kops
  
  aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonEC2FullAccess --group-name kops
  aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonRoute53FullAccess --group-name kops
  aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonS3FullAccess --group-name kops
  aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/IAMFullAccess --group-name kops
  aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonVPCFullAccess --group-name kops
  
  aws iam create-user --user-name kops
  
  aws iam add-user-to-group --user-name kops --group-name kops

  ACCESS_KEY_JSON=$(aws iam create-access-key --user-name kops)

  export AWS_ACCESS_KEY_ID=$(echo $ACCESS_KEY_JSON | jq '.AccessKey.AccessKeyId' -r)
  export AWS_SECRET_ACCESS_KEY=$(echo $ACCESS_KEY_JSON | jq '.AccessKey.SecretAccessKey' -r)
  echo "$AWS_ACCESS_KEY_ID
$AWS_SECRET_ACCESS_KEY
$AWS_DEFAULT_REGION
" | aws --profile "$1-kops" configure
fi
export AWS_PROFILE="$1-kops"
aws sts get-caller-identity

CLUSTER_NAME="$1.k8s.local"
#kops create cluster $CLUSTER_NAME
#
#aws s3api create-bucket \
#

KOPS_BUCKET="$AWS_PROFILE-state-store"
aws s3api create-bucket \
    --bucket $KOPS_BUCKET \
    --create-bucket-configuration LocationConstraint=$AWS_DEFAULT_REGION \
    --region $AWS_DEFAULT_REGION
aws s3api put-bucket-versioning --bucket $KOPS_BUCKET  --versioning-configuration Status=Enabled

export KOPS_STATE_STORE="s3://$KOPS_BUCKET"
ZONE=${AWS_DEFAULT_REGION}a
kops create cluster --zones=$ZONE $CLUSTER_NAME --cloud aws --ssh-public-key ~/.ssh/id_rsa.pub --authorization=rbac --node-count=2 --node-size=t2.medium --master-size=t2.medium

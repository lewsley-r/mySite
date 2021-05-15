#!/bin/bash
########
# You need a cli user with the follow policices attached to run this script completely: AmazonS3FullAccess, AmazonEC2ContainerRegistryFullAccess, IAMFullAccess
#
#
######

if [[ $# -eq 0 ]] ; then
    echo 'Provide a project name and aws region. example setup_everything.sh projectf eu-west-2'
    exit 0
fi

#You need a user that has a policy IAMFullAccess attached to them
cp gitlab-ci.yml ../.gitlab-ci.yml

aws iam create-group --group-name botgroup

aws iam create-user --user-name deploybot

echo Adding bot to group
aws iam add-user-to-group --user-name deploybot --group-name botgroup

echo Adding policies 
aws iam attach-user-policy --policy-arn arn:aws:iam::aws:policy/AmazonS3FullAccess --user-name deploybot
aws iam attach-user-policy --policy-arn arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser --user-name deploybot

#Create s3 bucket to store the frontend build output in. This is then used in the final build of the backend docker images.
aws s3api create-bucket --bucket frontend.$1 --acl private --region $2 --create-bucket-configuration LocationConstraint=$2

echo YOU NEED THE NEXT INFORMATION TO ADD TO GITLAB
aws iam create-access-key --user-name deploybot

#Create an ecr repository to store the images created by gitlab-ci. These will then used by the kubernetes cluster on startup.
echo You need to add repositoryUri to gitlab so it knowns where to deploy the images after the build. AWS_ECR_URI gitlab variable
ecr_repo=aws ecr create-repository --repository-name $1 | grep repositoryUri

echo backend gitlab variables
echo AWS_ACCESS_KEY_ID  AccessKeyId
echo AWS_DEFAULT_REGION $2
echo AWS_ECR_URI $ecr_repo
echo AWS_SECRET_ACCESS_KEY SecretAccessKey
echo
echo frontend gitlab variables
echo AWS_ACCESS_KEY_ID  AccessKeyId
echo AWS_SECRET_ACCESS_KEY SecretAccessKey
echo AWS_DEFAULT_REGION $2
echo AWS_FRONTEND_BUCKET frontend.$1


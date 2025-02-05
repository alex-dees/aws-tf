repo="nginx"
region=$(aws configure list | grep region | awk '{print $2}')
account=$(aws sts get-caller-identity --query 'Account' --output text)
registry=$account.dkr.ecr.$region.amazonaws.com

crane pull nginx:latest nginx.tar

aws ecr get-login-password | crane auth login -u AWS --password-stdin $registry

# create repo, ignore errors if it already exists
aws ecr create-repository --repository-name $repo &> /dev/null || true

crane push nginx.tar $registry/$repo:latest

rm nginx.tar
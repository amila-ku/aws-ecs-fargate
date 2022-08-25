# Containerized Application Deployment on AWS ECS 

## What you need to get started

1. Install Terraform

```
brew install terraform
```

2. Create AWS account
[Create account](https://aws.amazon.com/premiumsupport/knowledge-center/create-and-activate-aws-account/#:~:text=Sign%20up%20using%20your%20email,Create%20a%20new%20AWS%20account.) and [create user](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users_create.html)

3. Create a S3 bucket

```
aws s3api create-bucket --bucket terraform-backend-store-<your_projectname> --region eu-central-1 --create-bucket-configuration LocationConstraint=eu-central-1
```

4. Set credential for AWS user
If you want to use existing user add aws access keys in ~/.aws/credentials and set the profile to use

```
export AWS_PROFILE=terraformuser
```

Information about use of named profiles is [here](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html)

## Resources that get created

1. AWS VPC
2. Internet Gateway and Nat Gateway
4. Subnets, RouteTables and routes
5. ECS Cluster(Fargate)
6. Secrets in secret manager
7. Aurora Serverless databaase
8. ALB TargetGroups
9. ECS service which is spread accross multiple AZ with Autoscaling
10. Security Groups


## Creating the environment

1. Initialize the modules

```
cd dev
terraform init
```

2. Create Secrets file 


```
echo 'application-secrets = {
  "VTT_DBUSER"            = "postgres"
  "VTT_DBPASSWORD"        = "abcd123#$"
}
' > secrets.tfvars
```


3. Plan resources

```
terraform plan -var-file="secrets.tfvars"
```

4. Create resources

```
terraform apply -var-file="secrets.tfvars"
```


## Decisions made

1. VPC module is created from scratch to make it easier to go through the different components involved.
2. ECS with Fargate is used instead of EKS to reduce complexity of managing and considering cost savings of not having to pay for cluster, since need to complex scaling or multi cloud requirements were not there ECS would be the simpler solution.
3. ECS and ECS service module is created to have control over setup and be able to use it as a single module to make applying changes simple.
4. RDS module from terraform registry is used to create highly available Aurora Serverless database.
5. RDS on graviton used to reduce cost.

## Improvements

1. Run on [graviron2 for fargate](https://aws.amazon.com/blogs/aws/announcing-aws-graviton2-support-for-aws-fargate-get-up-to-40-better-price-performance-for-your-serverless-containers/)
2. CI pipeline 
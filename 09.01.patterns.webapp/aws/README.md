# 09.01.patterns.webapp.aws

Testing simple webapp with terrafom on aws.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)

## References

- [Terraform](https://www.terraform.io/)
- [AWS CLI](https://aws.amazon.com/cli/)
- [AWS IAM](https://aws.amazon.com/iam/)
- [AWS IAM User](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users.html)
- [AWS IAM Role](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html)
- [AWS IAM Policy](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies.html)

## Setup

### AWS CLI

```bash
aws configure
```

### Create a bucket for the backend

```bash
aws s3api create-bucket --bucket linusdevopstf01 --region eu-north-1 --create-bucket-configuration LocationConstraint=eu-north-1

```

### AWS IAM User (Optional)

```bash
aws iam create-user --user-name terraform
aws iam create-access-key --user-name terraform
```

### AWS IAM Role (Optional)

```bash
aws iam create-role --role-name terraform --assume-role-policy-document file://aws/iam/terraform-role.json
aws iam attach-role-policy --role-name terraform --policy-arn arn:aws:iam::aws:policy/AdministratorAccess
```

### AWS IAM Policy (Optional)

```bash
aws iam create-policy --policy-name terraform --policy-document file://aws/iam/terraform-policy.json
```

## Terraform Usage

### Backend configuration

Create a file named `application.backend.conf` with the following content:

```hcl
bucket = "linusdevopstf01"
region = "eu-north-1"
key    = "patterns/basic/terraform.tfstate"
```

### Initialize

```bash
terraform init --backend-config=application.backend.conf -reconfigure
```

### Variables file

Create a file named `configuration.tfvars` with the following content:

```bash
# Tags
organization = "swoas"
customer     = "linus"
project      = "cloud & ops"
cost_center  = "testing"

# VPC configuration
region = "eu-north-1"

vpc_name             = "linus-test-vpc"
enable_dns_hostnames = true
vpc_cidr             = "10.134.0.0/23"

subnets_configuration = [
  {
    subnet_type       = "private"
    name              = "linus-private1"
    availability_zone = "eu-north-1a"
    cidr_block        = "10.134.0.0/28"
  },
  {
    subnet_type       = "private"
    name              = "private2"
    availability_zone = "eu-north-1b"
    cidr_block        = "10.134.1.0/28"
  },
  {
    subnet_type       = "public"
    name              = "public1"
    availability_zone = "eu-north-1a"
    cidr_block        = "10.134.0.32/27"
  },
  {
    subnet_type       = "public"
    name              = "public2"
    availability_zone = "eu-north-1b"
    cidr_block        = "10.134.1.32/27"
  }
]


# EC2 configuration
# For eu-north-1
instance_image = "ami-090793d48e56d862c"
instance_type  = "t3.micro"
instance_name  = "linus-test-instance"

# Bastion
ec2_key_name = "linus-test-vpc-kp"

instance_ingress = [
  {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  },
  {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
]

```

Then run:

```bash
terraform apply -var-file="configuration.tfvars"
```

### Get private key

```bash
terraform output -raw private_key > path_to_the_file.pem
```

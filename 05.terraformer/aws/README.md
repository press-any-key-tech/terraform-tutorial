# 05.terraformer

Extracting infrastrcuture from AWS to Terraform.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)
- [Terraformer](https://github.com/GoogleCloudPlatform/terraformer)

Optional:

- [AWS Account](https://aws.amazon.com/premiumsupport/knowledge-center/create-and-activate-aws-account/)
- [AWS IAM User](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users_create.html)
- [AWS IAM Role](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_create.html)
- [AWS IAM Policy](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_create.html)

## Setup

### AWS CLI

```bash
aws configure
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

## Terraformer Usage

### 1. Initialize Teraform

```bash
terraform init
```

### 2. Import AWS Resources

```bash
terraformer import aws --resources=vpc,subnet --connect=true --regions=eu-west-1 --profile=default
```

### 3. (Optional) Generate Terraform Configuration

```bash
terraformer plan aws --resources=vpc,subnet --regions=eu-west-1 --profile=default
```

### 4. (Optional) Apply Terraform Configuration

```bash
terraformer apply aws --resources=vpc,subnet --regions=eu-west-1 --profile=default
```

### 5. (Optional) Destroy Terraform Configuration

```bash
terraformer destroy aws --resources=vpc,subnet --regions=eu-west-1 --profile=default
```

## References

- [Terraform](https://www.terraform.io/)
- [AWS CLI](https://aws.amazon.com/cli/)
- [AWS IAM](https://aws.amazon.com/iam/)
- [AWS IAM User](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users.html)
- [AWS IAM Role](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html)
- [AWS IAM Policy](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies.html)

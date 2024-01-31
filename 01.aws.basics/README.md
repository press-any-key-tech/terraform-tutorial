# 01.aws.basics

Just testing out terrafom with aws

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)

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

## Terraform Usage

### Initialize

```bash
terraform init
```

### Plan

```bash
terraform plan
```

### Apply

```bash
terraform apply
```

### Destroy

```bash
terraform destroy
```

### Variables file

Create a file named `configuration.tfvars` with the following content:

```bash
instance_type = "t2.medium"
instance_name = "mega-test"
```

Then run:

```bash
terraform plan -var-file="configuration.tfvars"
```

### Get private key

    ```bash
    terraform output -show-sensitive private_key > path_to_the_file.pem
    ```

## Connect with SSH

### Key File permissions

Change permissions of the private key file:

```bash
chmod 400 path_to_the_file.pem
```

```powershell
icacls path_to_the_file.pem /reset
icacls path_to_the_file.pem /GRANT:R "$($env:USERNAME):(R)"
icacls path_to_the_file.pem /inheritance:r
```

(or use the provided `chmod400.ps1` script)

### Connect

```bash
ssh -i path_to_the_file.pem ec2-user@$(terraform output public_ip)
```

## References

- [Terraform](https://www.terraform.io/)
- [AWS CLI](https://aws.amazon.com/cli/)
- [AWS IAM](https://aws.amazon.com/iam/)
- [AWS IAM User](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users.html)
- [AWS IAM Role](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html)
- [AWS IAM Policy](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies.html)

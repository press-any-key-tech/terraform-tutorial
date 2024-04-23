# 01.aws.basics

Just testing out terrafom with azure

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html)
- [Azure CLI](https://learn.microsoft.com/es-es/cli/azure/install-azure-cli)


## Setup

### View version

```bash
az version
```

Response

```json
{
  "azure-cli": "2.59.0",
  "azure-cli-core": "2.59.0",
  "azure-cli-telemetry": "1.1.0",
  "extensions": {}
}
```

### Login

```bash
aws login
```

Authenticate in the web browser.

### View current account

```bash
az account show
```

Response:

```json
{
  "environmentName": "AzureCloud",
  "homeTenantId": "00000000-0000-0000-0000-000000000000",
  "id": "00000000-0000-0000-0000-000000000000",
  "isDefault": true,
  "managedByTenants": [],
  "name": "Main Subscription",
  "state": "Enabled",
  "tenantId": "00000000-0000-0000-0000-000000000000",
  "user": {
    "name": "xxxxxxxx@mail.com",
    "type": "user"
  }
}
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
resource_group = "terraform-rg"
region = "westeurope"

vnet_name = "terraform-vnet"
vnet_cidr_blocks = ["10.0.0.0/16"]
subnet_name = "terraform-subnet"
subnet_cidr_blocks = ["10.0.1.0/24"]

nic_name = "terraform-nic"
nic_ip_configuration_name = "terraform-ipconfig"

vm_name = "terraform-vm"
```

Then run:

```bash
terraform plan -var-file="configuration.tfvars"
```

### Get private key

```bash
terraform output -raw private_key > path_to_the_file.pem
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
ssh -i path_to_the_file.pem adminuser@$(terraform output public_ip)
```

## References

- [Terraform](https://www.terraform.io/)

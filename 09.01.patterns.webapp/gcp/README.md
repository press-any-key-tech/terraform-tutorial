# 09.01.patterns.webapp.gcp

Testing simple webapp with terrafom on GCP.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html)
- [gcloud CLI](https://cloud.google.com/sdk/docs/install?hl=es-419)

## References

- [Terraform](https://www.terraform.io/)
- [gcloud CLI](https://cloud.google.com/sdk/docs/install?hl=es-419)

## Setup

### gcloud CLI

(Optional) If you don't have a project, create one and associate with a billing account. It will require the alpha extensions to google cloud.

```bash
gcloud projects create linus-terraform-001 --name="Linus Terraform 001"

# Get the billing account
gcloud alpha billing accounts list

# Associate the project with the billing account
gcloud alpha billing projects link linus-terraform-001 --billing-account=0X0X0X-0X0X0X-0X0X0X

```

Get the list of projects and select the one you want to use:

```bash
gcloud projects list
```

Configure the gcloud CLI:

```bash
gcloud init
```

Or select an existing project:

```bash
gcloud config set project linus-terraform-001
```

### Create a bucket for the backend

```bash
gsutil mb -p linus-terraform-001 -c standard -l europe-west1 gs://linusdevopstf01
```

### Create a service account

```bash
gcloud iam service-accounts create terraform --display-name "Terraform admin account"

# View service accounts
gcloud iam service-accounts list
# Use "email" field as account name


# Grant the service account the necessary permissions
gcloud projects add-iam-policy-binding linus-terraform-001 --member serviceAccount:terraform@linus-terraform-001.iam.gserviceaccount.com --role roles/owner

```

### Create a key for the service account

```bash
gcloud iam service-accounts keys create terraform.json --iam-account terraform@linus-terraform-001.iam.gserviceaccount.com
```

### Enable the necessary APIs

```bash
gcloud services enable compute.googleapis.com
gcloud services enable storage-api.googleapis.com
gcloud services enable storage-component.googleapis.com
gcloud services enable artifactregistry.googleapis.com
gcloud services enable run.googleapis.com --project=linus-terraform-001
gcloud services enable appengine.googleapis.com --project=linus-terraform-001
gcloud services enable deploymentmanager.googleapis.com --project=linus-terraform-001

```

### Create a registry for the docker image

```bash
gcloud artifacts repositories create tcp-dummy-services --repository-format=docker --location=europe-west1
```

Configure docker to authenticate with the registry

```bash
gcloud auth configure-docker europe-west1-docker.pkg.dev
```

### Tag and push the docker images to the registry

```bash
docker tag tcp-dummy-services:latest europe-west1-docker.pkg.dev/linus-terraform-001/tcp-dummy-services/tcp-dummy-services:latest
docker tag tcp-dummy-services:gcr europe-west1-docker.pkg.dev/linus-terraform-001/tcp-dummy-services/tcp-dummy-services:gcr

docker push europe-west1-docker.pkg.dev/linus-terraform-001/tcp-dummy-services/tcp-dummy-services:latest
docker push europe-west1-docker.pkg.dev/linus-terraform-001/tcp-dummy-services/tcp-dummy-services:gcr
```

## Terraform Usage

### Backend configuration

Create a file named `application.backend.conf` with the following content:

```hcl
bucket = "linusdevopstf01"
region = "europe-west1"
prefix    = "patterns/webapp/terraform.tfstate"
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

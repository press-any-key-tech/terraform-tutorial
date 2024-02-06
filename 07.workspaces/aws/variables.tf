# The home of the variables
variable "tags" {
  description = "External tags map"
  type        = map(string)
  default     = {}
}

variable "region" {
  description = "Set the primary region"
  type        = string
  default     = "eu-west-2"
}

variable "environment" {
  description = "Set environment name"
  type        = string
  default     = ""
}

variable "customer" {
  description = "Set customer name"
  type        = string
  default     = ""
}

variable "cost_center" {
  description = "Cost center associated with the project"
  type        = string
  default     = ""
}

variable "project" {
  description = "Project name"
  type        = string
  default     = ""
}

variable "organization" {
  description = "Organization name (internal)"
  type        = string
  default     = ""
}


variable "vpc_id" {
  description = "Id for the VPC"
  type        = string
  default     = ""
}

variable "vpc_name" {
  description = "Name for the VPC"
  type        = string
  default     = ""
}

variable "enable_dns_hostnames" {
  description = "Should be true to enable DNS hostnames in the VPC"
  type        = bool
  default     = false
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  type        = string
  default     = "0.0.0.0/0"
}

variable "vpc_tags" {
  description = "Vpc tags map"
  type        = map(string)
  default     = {}
}


variable "subnets_configuration" {
  description = "List of subnet configurations"
  type = list(object({
    name              = string
    cidr_block        = string
    availability_zone = string
    subnet_type       = string
  }))
  default = []
}





variable "ec2_key_name" {
  description = "Key name to connect with EC2"
  type        = string
  default     = null
}



variable "instance_type" {
  description = "Instance type to use"
  type        = string
  default     = "t2.micro"
}

variable "instance_name" {
  description = "Instance name to use"
  type        = string
  default     = "terraform-test"
}

variable "instance_image" {
  description = "Instance AMI"
  type        = string
  default     = "ami-0fef2f5dd8d0917e8"
}

variable "instance_ingress" {
  description = "List of maps of ingress rules"
  type = list(object({
    cidr_blocks = list(string)
    from_port   = number
    to_port     = number
    protocol    = string
  }))
  default = [
    {
      cidr_blocks = ["0.0.0.0/0"]
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
    }
  ]
}

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

# Frontend
variable "frontend_bucket_name" {
  description = "Bucket name"
  type        = string
  default     = null
}

variable "frontend_s3_endpoint" {
  description = "S3 endpoint"
  type        = string
  default     = null
}

variable "frontend_origin_id" {
  description = "Distribution origin ID"
  type        = string
  default     = null
}

variable "cluster_name" {
  description = "ECS cluster name"
  type        = string
  default     = null
}

variable "lt_ec2_key_name" {
  description = "Launch Template EC2 key_name"
  type        = string
  default     = null
}

variable "lt_ec2_image_id" {
  description = "Launch Template EC2 image"
  type        = string
  default     = null
}

variable "lt_ec2_instance_type" {
  description = "Launch Template EC2 instance type"
  type        = string
  default     = null
}

variable "alb_listener_port" {
  description = "Port exposed by the ALB"
  type        = number
  default     = 80
}

variable "alb_listener_protocol" {
  description = "Protocol for the ALB listener"
  type        = string
  default     = "HTTP"
}

variable "backend_bucket_name" {
  description = "(Optional) The name of the bucket to use for the backend"
  type        = string
  default     = null
}

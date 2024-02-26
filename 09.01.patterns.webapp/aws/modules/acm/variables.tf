variable "name" {
  type        = string
  default     = ""
  description = "Name  (e.g. `app` or `cluster`)."
}

variable "environment" {
  type        = string
  default     = ""
  description = "Environment (e.g. `prod`, `dev`, `staging`)."
}

variable "tags" {
  type        = map(any)
  default     = {}
  description = "Additional tags (e.g. map(`BusinessUnit`,`XYZ`)."
}

variable "private_key" {
  type        = string
  default     = ""
  description = "Private key."
}

variable "certificate_body" {
  type        = string
  default     = ""
  description = "Certificate body."
}

variable "certificate_chain" {
  type        = string
  default     = ""
  description = "Certificate chain."
}


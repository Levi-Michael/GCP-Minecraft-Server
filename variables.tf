# variables.tf
variable "project_id" {
  description = "GCP project ID"
}

variable "region" {
  description = "GCP region"
  default     = "us-central1"
}

variable "zone" {
  description = "GCP zone"
  default     = "us-central1-a"
}

variable "subnet_cidr" {
  description = "Subnet CIDR range"
  default     = "10.0.0.0/24"
}

variable "billing_account" {
  description = "billing Account ID"
}

variable "prefix" {
  description = "Prefix"
  default     = "tf"
}

variable "instance_type" {
  description = "Instance Type"
  default     = "e2-medium"
}

variable "allowed_range" {
  description = "Iallowed_range"
  default     = ["0.0.0.0/0"]
}

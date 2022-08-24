variable "name" {
  description = "the name of your stack, e.g. \"cloudorg\""
}

variable "owner" {
  description = "the owner of your stack, e.g. \"me\""
}


variable "environment" {
  description = "the name of your environment, e.g. \"prod\""
}

variable "cidr" {
  description = "The CIDR block for the VPC."
}

variable "public_subnets" {
  description = "List of public subnets"
}

variable "private_subnets" {
  description = "List of private subnets"
}

variable "availability_zones" {
  description = "List of availability zones"
}
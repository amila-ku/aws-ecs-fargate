variable "name" {
  description = "the name of your stack, e.g. \"cloudorg\""
}

variable "environment" {
  description = "the name of your environment, e.g. \"prod\""
}

variable "region" {
  description = "the AWS region in which resources are created"
}

variable "owner" {
  description = "the owner of your stack, e.g. \"me\""
}

variable "subnets" {
  description = "List of subnet IDs"
}

variable "public_subnets" {
  description = "List of public subnet IDs"
}


variable "container_port" {
  description = "Port of container"
}

variable "container_cpu" {
  description = "The number of cpu units used by the task"
}

variable "container_memory" {
  description = "The amount (in MiB) of memory used by the task"
}

variable "container_image" {
  description = "Docker image to be launched"
}

variable "service_desired_count" {
  description = "Number of services running in parallel"
}

variable "container_environment" {
  description = "The container environmnent variables"
  type        = list
}

variable "container_secrets" {
  description = "The container secret environmnent variables"
  type        = list
}

variable "container_secrets_arns" {
  description = "ARN for secrets"
}

variable "vpc_id" {
  description = "VPC ID"
}

variable "alb_tls_cert_arn" {
  description = "The ARN of the certificate that the ALB uses for https"
}

variable "health_check_path" {
  description = "Path to check if the service is healthy, e.g. \"/status\""
}

variable "cpu_scaling_target" {
  description = "Threshold value when CPU based scaling will be triggered"
}

variable "memory_scaling_target" {
  description = "Threshold value when Memory based scaling will be triggered"
}

variable "scaling_min_capacity" {
  description = "Minumum number of tasks to have"
}

variable "scaling_max_capacity" {
  description = "Maximum number of tasks to have"
}



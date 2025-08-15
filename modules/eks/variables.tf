variable "vpc_id" {
  description = "VPC ID where the bastion host will be created"
  type        = string
  
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
  default     = "eks-cluster" 
}

variable "env_name" {
  description = "The name of the environment"
  type        = string
  default     = "development"
  
}

variable "project_name" {
  description = "The name of the project"
  type        = string
  default     = "EKS"
  
}

variable "instance_type" {
  description = "The type of EC2 instance for the bastion host"
  type        = string
  default     = "t3.small"
  
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs where the bastion host will be deployed"
  type        = list(string)
  
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs where the bastion host will be deployed"
  type        = list(string)
}

variable "key_name" {
  description = "The name of the key pair to use for the bastion host"
  type        = string
}

variable "admin_users" {
  description = "List of IAM users with admin access"
  type        = list(string)
  default     = [
    "arn:aws:iam::923214554566:user/DevAdmin",
    "arn:aws:iam::923214554566:user/devuser",
    "arn:aws:iam::923214554566:root"
  ]
}
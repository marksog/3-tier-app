variable "env_name" {
  description = "The name of the environment"
  type        = string
  default     = "development"
}

variable "name" {
  description = "The name of the VPC"
  type        = string
  default     = "app-vpc"
  
}
variable "aws_region" {
  description = "The AWS region where resources will be deployed"
  type        = string
  default     = "us-east-1" 
}

variable "key_name" {
  description = "The name of the SSH key pair to use for EC2 instances"
  type        = string
  default     = "jenkins_server"
}


variable "azs" {
  description = "List of availability zones for the VPC"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
  
}
variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.1.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "The CIDR block for the public subnet"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
  default     = "dev-eks-cluster"
}

variable "project_name" {
  description = "The name of the project"
  type        = string
  default     = "EKS"
  
}

variable "instance_type" {
  description = "The type of EC2 instance for the bastion host"
  type        = string
  default     = "t2.mico"
  
}

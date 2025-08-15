variable "vpc_id" {
  description = "VPC ID where the bastion host will be created"
  type        = string 
}

variable "env_name" {
  description = "The name of the environment"
  type        = string
  default     = "development" 
}

variable "instance_type" {
  description = "The type of EC2 instance for the bastion host"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "The name of the key pair to use for the bastion host"
  type        = string
  
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs where the bastion host will be deployed"
  type        = list(string)
}

output "name" {
  description = "The name of the environment"
  value       = var.env_name
  
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnets
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnets
}

output "eks_cluster_name" {
  description = "The name of the EKS cluster"
  value       = var.cluster_name
  
}

output "eks_cluster_endpoint" {
  description = "The endpoint of the EKS cluster"
  value       = module.eks.cluster_endpoint
}

output "eks_node_instance_ids" {
  value = data.aws_instances.eks_nodes.ids
}

output "eks_node_private_ips" {
  value = data.aws_instances.eks_nodes.private_ips
}

output "eks_node_public_ips" {
  value = data.aws_instances.eks_nodes.public_ips
}
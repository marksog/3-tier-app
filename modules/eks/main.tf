resource "aws_security_group" "node_group_remote_access" {
  name        = "node_group_remote_access"
  description = "Security group for remote access to EKS node group"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow SSH access from anywhere"
}
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        description = "allow all outgoing traffic"
    }
}

module "eks" {
    source          = "terraform-aws-modules/eks/aws"
    version         = "~> 20.0"

    cluster_name = var.cluster_name
    cluster_version = "1.28"
    cluster_endpoint_public_access = false
    cluster_endpoint_private_access = true

    # access entry for iam users
    access_entries = {
        for user in var.admin_users : user => {
            principal_arn = user
            policy_associations = {
            adminss = {
                policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
                access_scope = {
                type = "cluster"
                }
            }
          }
        }
    }

    cluster_security_group_additional_rules = {
        access_for_bastion_jenkins_host = {
            cidr_blocks = ["0.0.0.0/0"]
            description = "Allow access from Bastion and Jenkins host"
            from_port   = 443
            to_port     = 443
            protocol    = "tcp" 
            type        = "ingress"
        }
    }

    cluster_addons = {
        coredns = {
            most_recent = true
        }
        kube-proxy = {
            most_recent = true
        }
        vpc-cni = {
            most_recent = true
        }
    }

    vpc_id = var.vpc_id
    subnet_ids = var.public_subnet_ids
    control_plane_subnet_ids = var.private_subnet_ids

    # eks managed node group

    eks_managed_node_group_defaults = {
        instance_type = var.instance_type
        attach_cluster_primary_security_group = true
    }

    eks_managed_node_groups = {
        app_cluster_ng = {
            max_size = 2
            min_size = 1
            desired_size = 1
            instance_type = var.instance_type
            capacity_type = "ON_DEMAND"
            ami_type = "AL2_x86_64"

            disk_size = 20
            use_custom_launch_template = false

            remote_access = {
                ec2_ssh_key = var.key_name
                source_security_group_ids = [aws_security_group.node_group_remote_access.id]
            }

            tags = {
                Name        = "app-cluster-ng"
                Environment = var.env_name
            }
        }
    }
    tags = {
        Environment = var.env_name
        Project     = var.project_name
        Name        = var.cluster_name
    }
}


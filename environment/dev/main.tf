module "network" {
  source = "../../modules/vpc"

  vpc_cidr = var.vpc_cidr
  azs = var.azs
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs

  tags = {
    "Environment" = var.env_name
    "Project"     = var.project_name
    "Name"        = var.name
  }
}
### key pair for SSH access

resource "aws_key_pair" "deployer" {
  key_name   = "terra-automate-key"
  public_key = file("terra-key.pub")
}

module "bastion_host" {
    source = "../../modules/bastion"

    env_name = var.env_name
    vpc_id = module.network.vpc_id
    public_subnet_ids = module.network.public_subnet_ids
    key_name = aws_key_pair.deployer.key_name

    depends_on = [ module.network ]
}

module "jenkins" {
    source = "../../modules/jenkins"

    env_name = var.env_name
    vpc_id = module.network.vpc_id
    public_subnet_ids = module.network.public_subnet_ids
    key_name = aws_key_pair.deployer.key_name

    depends_on = [ module.network ]
}

module "eks" {
    source = "../../modules/eks"

    vpc_id = module.network.vpc_id
    public_subnet_ids = module.network.public_subnet_ids
    private_subnet_ids = module.network.private_subnet_ids

    cluster_name = var.cluster_name
    env_name = var.env_name
    project_name = var.project_name
    instance_type = var.instance_type
    key_name = aws_key_pair.deployer.key_name

    depends_on = [ module.network ]
  
}

data "aws_instances" "eks_nodes" {
  instance_tags = {
    "eks:cluster-name" = module.eks.cluster_name
  }

  filter {
    name   = "instance-state-name"
    values = ["running"]
  }

  depends_on = [module.eks]
}
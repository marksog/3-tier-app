resource "aws_security_group" "allow_users_connection" {
    name = "bastion_host_sg"
    description = "Allow SSH access from users"
    vpc_id = var.vpc_id

    dynamic "ingress" {
        for_each = [
            { description = "SSH from users", from = 22, to = 22, protocol = "tcp", cidr = ["0.0.0.0/0"] },
            { description = "allow port 80", from = 80, to = 80, protocol = "tcp", cidr = ["0.0.0.0/0"]},
            { description = "port 443 allow", from = 443, to = 443, protocol = "tcp", cidr = ["0.0.0.0/0"] }
        ]
        content {
            description = ingress.value.description
            from_port   = ingress.value.from
            to_port     = ingress.value.to
            protocol    = ingress.value.protocol
            cidr_blocks = ingress.value.cidr
        }

    }

    egress {
            description = "Allow SSH access from users"
            from_port   = 0
            to_port     = 0
            protocol    = "-1" # Allow all protocols
            cidr_blocks = ["0.0.0.0/0"]
        }
    tags = merge(
        {
            Name = "bastion_host_sg"
            Environment = var.env_name
        })
}

data "aws_ami" "os_image" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "state"
    values = ["available"]
  }
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/*24.04-amd64*"]
  }
}

# resource "aws_key_pair" "deployer" {
#   key_name   = "dev_key"
#   public_key = file("${path.root}/environment/dev/dev_key.pub")
#   #file(var.public_key_path)
# }

resource "aws_instance" "bastion_host" {
  ami = data.aws_ami.os_image.id
  instance_type = var.instance_type
  key_name = var.key_name
  vpc_security_group_ids = [aws_security_group.allow_users_connection.id]
  subnet_id = var.public_subnet_ids[0]
  user_data = file("${path.module}/bastion_host.sh")
  tags = {
    Name = "bastion_host"
    Environment = var.env_name
  }
  root_block_device {
    volume_size = 20
    volume_type = "gp3"
    delete_on_termination = true
  }

  

}
    
    

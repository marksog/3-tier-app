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

resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins_sg"
  description = "Security group for Jenkins server"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = [
      { description = "HTTP", from_port = 80, to_port = 80, protocol = "tcp", cidr = ["0.0.0.0/0"] },
      { description = "HTTPS", from_port = 443, to_port = 443, protocol = "tcp", cidr = ["0.0.0.0/0"] },
      { description = "SSH", from_port = 22, to_port = 22, protocol = "tcp", cidr = ["0.0.0.0/0"] },
      { description = "Jenkins", from_port = 8080, to_port = 8080, protocol = "tcp", cidr = ["0.0.0.0/0"] }
    ]
    content {
      description = ingress.value.description
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr
    }
  }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name        = "jenkins_sg"
        Environment = var.env_name
    }
  
}

resource "aws_instance" "Jenkins_instance" {
    ami = data.aws_ami.os_image.id
    instance_type = var.instance_type
    key_name = var.key_name
    vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
    subnet_id = var.public_subnet_ids[0]
    user_data = file("${path.module}/user_data.sh")
    tags = {
        Name        = "Jenkins Server"
        Environment = var.env_name
    }
    root_block_device {
        volume_size = 20
        volume_type = "gp3"
        delete_on_termination = true
    }
}
    resource "aws_eip" "jenkins_eip" {
        instance = aws_instance.Jenkins_instance.id
        domain = "vpc"
    }
  
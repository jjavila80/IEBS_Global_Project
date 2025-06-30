resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated" {
  key_name   = var.key_pair_name
  public_key = tls_private_key.ec2_key.public_key_openssh
}

resource "local_file" "private_key" {
  content              = tls_private_key.ssh_key.private_key_pem
  filename             = "${path.module}/terraform-key.pem"
  file_permission      = "0600"
}

resource "aws_security_group" "k8s_sg" {
  name        = "k8s-sg"
  description = "Permitir SSH y puerto 3000"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "API port 3000"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-${var.ubuntu_version}-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_instance" "k8s_node" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.generated.key_name
  vpc_security_group_ids = [aws_security_group.k8s_sg.id]

  tags = {
    Name = "k8s-node"
  }

  user_data = <<-EOF
    #!/bin/bash
    set -eux

    # Update & install prerequisites
    apt-get update -y
    apt-get install -y curl wget apt-transport-https ca-certificates gnupg lsb-release conntrack

    # Install Docker
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
      https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" > \
      /etc/apt/sources.list.d/docker.list
    apt-get update -y
    apt-get install -y docker-ce docker-ce-cli containerd.io

    # Enable Docker
    systemctl enable docker
    systemctl start docker

    # Download Minikube
    curl -Lo /usr/local/bin/minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    chmod +x /usr/local/bin/minikube

    # Start Minikube
    minikube config set driver docker
    minikube start --driver=docker

    # Install kubectl
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

    # Bash completion (opcional)
    echo "source <(kubectl completion bash)" >> /root/.bashrc
  EOF
}


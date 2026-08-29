resource "aws_launch_template" "app" {

  name_prefix   = "three-tier-app-"
  image_id      = var.ami_id
  instance_type = var.instance_type

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }

  network_interfaces {
    associate_public_ip_address = false

    security_groups = [
      aws_security_group.ec2_sg.id
    ]
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash

    set -e

    # Update packages
    dnf update -y

    # Install Docker
    dnf install -y docker

    # Start Docker
    systemctl enable docker
    systemctl start docker

    # Add ec2-user to Docker group
    usermod -aG docker ec2-user

    # Install AWS CLI
    dnf install -y awscli

    # Login to ECR
    aws ecr get-login-password --region us-east-1 | \
    docker login \
      --username AWS \
      --password-stdin \
      ${var.aws_account_id}.dkr.ecr.us-east-1.amazonaws.com

    # Pull backend image
    docker pull \
      ${var.aws_account_id}.dkr.ecr.us-east-1.amazonaws.com/three-tier-backend:latest

    # Remove old container if present
    docker rm -f backend || true

    # Start backend
    docker run -d \
      --name backend \
      --restart unless-stopped \
      -p 80:5000 \
      ${var.aws_account_id}.dkr.ecr.us-east-1.amazonaws.com/three-tier-backend:latest

  EOF
  )
}

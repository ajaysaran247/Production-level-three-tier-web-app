########################################
# Launch Template
########################################

resource "aws_launch_template" "app" {

  name_prefix = "three-tier-"

  image_id = var.ami_id

  instance_type = var.instance_type

  key_name = "PThreeTierWeb"

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }

  network_interfaces {

    associate_public_ip_address = false

    security_groups = [
      aws_security_group.ec2_sg.id
    ]
  }

  user_data = base64encode(<<EOF
#!/bin/bash

yum update -y

yum install docker -y

systemctl enable docker

systemctl start docker

usermod -aG docker ec2-user
EOF
  )

  tag_specifications {

    resource_type = "instance"

    tags = {
      Name = "App-Server"
    }
  }
}

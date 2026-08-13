############################################
# ALB Security Group
############################################

resource "aws_security_group" "alb_sg" {

  name        = "alb-security-group"
  description = "Allow HTTP and HTTPS"
  vpc_id      = aws_vpc.main.id

  ingress {

    description = "HTTP"

    from_port = 80
    to_port   = 80

    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {

    description = "HTTPS"

    from_port = 443
    to_port   = 443

    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {

    from_port = 0
    to_port   = 0

    protocol = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ALB-Security-Group"
  }
}

###################################################
# EC2 Security Group
###################################################

resource "aws_security_group" "ec2_sg" {

  name        = "ec2-security-group"
  description = "Allow traffic from ALB"
  vpc_id      = aws_vpc.main.id

  ingress {

    from_port = 80
    to_port   = 80

    protocol = "tcp"

    security_groups = [
      aws_security_group.alb_sg.id
    ]
  }

  ingress {

    description = "SSH"

    from_port = 22
    to_port   = 22

    protocol = "tcp"

    cidr_blocks = [
      "0.0.0.0/32"
    ]
  }

  egress {

    from_port = 0
    to_port   = 0

    protocol = "-1"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags = {
    Name = "EC2-Security-Group"
  }
}

###################################################
# RDS Security Group
###################################################

resource "aws_security_group" "rds_sg" {

  name        = "rds-security-group"
  description = "Allow MySQL only from EC2"
  vpc_id      = aws_vpc.main.id

  ingress {

    from_port = 3306
    to_port   = 3306

    protocol = "tcp"

    security_groups = [
      aws_security_group.ec2_sg.id
    ]
  }

  egress {

    from_port = 0
    to_port   = 0

    protocol = "-1"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags = {
    Name = "RDS-Security-Group"
  }
}

########################################
# IAM Role
########################################

resource "aws_iam_role" "ec2_role" {

  name = "three-tier-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"

      Principal = {
        Service = "ec2.amazonaws.com"
      }

      Action = "sts:AssumeRole"
    }]
  })
}

########################################
# SSM Policy
########################################

resource "aws_iam_role_policy_attachment" "ssm" {

  role = aws_iam_role.ec2_role.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

########################################
# CloudWatch Policy
########################################

resource "aws_iam_role_policy_attachment" "cloudwatch" {

  role = aws_iam_role.ec2_role.name

  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

########################################
# ECR Read Policy
########################################

resource "aws_iam_role_policy_attachment" "ecr" {

  role = aws_iam_role.ec2_role.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

########################################
# Instance Profile
########################################

resource "aws_iam_instance_profile" "ec2_profile" {

  name = "three-tier-instance-profile"

  role = aws_iam_role.ec2_role.name
}

############################################
# Allow EC2 to read database secret
############################################

resource "aws_iam_role_policy" "ec2_secrets_manager" {

  name = "ec2-read-database-secret"

  role = aws_iam_role.ec2_role.id

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {
        Effect = "Allow"

        Action = [
          "secretsmanager:GetSecretValue"
        ]

        Resource = aws_secretsmanager_secret.database.arn
      }

    ]
  })
}

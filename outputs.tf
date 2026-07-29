########################################
# VPC
########################################

output "vpc_id" {

  value = aws_vpc.main.id
}

########################################
# Public Subnets
########################################

output "public_subnets" {

  value = [
    aws_subnet.public_subnet_1.id,
    aws_subnet.public_subnet_2.id
  ]
}

########################################
# Private App Subnets
########################################

output "private_app_subnets" {

  value = [
    aws_subnet.private_app_subnet_1.id,
    aws_subnet.private_app_subnet_2.id
  ]
}

########################################
# ALB DNS
########################################

output "alb_dns_name" {

  value = aws_lb.alb.dns_name
}

########################################
# RDS Endpoint
########################################

output "rds_endpoint" {

  value = aws_db_instance.mysql.endpoint
}

########################################
# S3 Bucket
########################################

output "frontend_bucket" {

  value = aws_s3_bucket.frontend.bucket
}

########################################
# SNS Topic
########################################

output "sns_topic_arn" {

  value = aws_sns_topic.alerts.arn
}

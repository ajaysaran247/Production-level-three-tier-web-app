variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  type    = string
  default = "three-tier-app"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet_1_cidr" {
  default = "10.0.1.0/24"
}

variable "public_subnet_2_cidr" {
  default = "10.0.2.0/24"
}

variable "private_app_subnet_1_cidr" {
  default = "10.0.11.0/24"
}

variable "private_app_subnet_2_cidr" {
  default = "10.0.12.0/24"
}

variable "private_db_subnet_1_cidr" {
  default = "10.0.21.0/24"
}

variable "private_db_subnet_2_cidr" {
  default = "10.0.22.0/24"
}

variable "availability_zone_1" {
  default = "us-east-1a"
}

variable "availability_zone_2" {
  default = "us-east-1b"
}

variable "ami_id" {
  type    = string
  default = "ami-004f790b835b26145"
}

variable "instance_type" {
  default = "t3.micro"
}
variable "db_password" {

  description = "Password for the RDS database"

  type      = string
  sensitive = true
}
variable "aws_account_id" {
  description = "AWS Account ID"
  type        = string
}

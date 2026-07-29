############################
# Public Subnet 1
############################

resource "aws_subnet" "public_subnet_1" {

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_1_cidr
  availability_zone       = var.availability_zone_1
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-Subnet-1"
  }
}

############################
# Public Subnet 2
############################

resource "aws_subnet" "public_subnet_2" {

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_2_cidr
  availability_zone       = var.availability_zone_2
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-Subnet-2"
  }
}

############################
# Private App Subnet 1
############################

resource "aws_subnet" "private_app_subnet_1" {

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_app_subnet_1_cidr
  availability_zone = var.availability_zone_1

  tags = {
    Name = "Private-App-Subnet-1"
  }
}

############################
# Private App Subnet 2
############################

resource "aws_subnet" "private_app_subnet_2" {

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_app_subnet_2_cidr
  availability_zone = var.availability_zone_2

  tags = {
    Name = "Private-App-Subnet-2"
  }
}

############################
# Private DB Subnet 1
############################

resource "aws_subnet" "private_db_subnet_1" {

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_db_subnet_1_cidr
  availability_zone = var.availability_zone_1

  tags = {
    Name = "Private-DB-Subnet-1"
  }
}

############################
# Private DB Subnet 2
############################

resource "aws_subnet" "private_db_subnet_2" {

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_db_subnet_2_cidr
  availability_zone = var.availability_zone_2

  tags = {
    Name = "Private-DB-Subnet-2"
  }
}

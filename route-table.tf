############################################
# Public Route Table
############################################

resource "aws_route_table" "public_rt" {

  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"

    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Public-Route-Table"
  }
}

############################################
# Associate Public Subnet 1
############################################

resource "aws_route_table_association" "public_subnet_1" {

  subnet_id = aws_subnet.public_subnet_1.id

  route_table_id = aws_route_table.public_rt.id
}

############################################
# Associate Public Subnet 2
############################################

resource "aws_route_table_association" "public_subnet_2" {

  subnet_id = aws_subnet.public_subnet_2.id

  route_table_id = aws_route_table.public_rt.id
}

############################################
# Private Route Table
############################################

resource "aws_route_table" "private_rt" {

  vpc_id = aws_vpc.main.id

  route {

    cidr_block = "0.0.0.0/0"

    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "Private-Route-Table"
  }
}

############################################
# Associate Private App Subnet 1
############################################

resource "aws_route_table_association" "private_app_1" {

  subnet_id = aws_subnet.private_app_subnet_1.id

  route_table_id = aws_route_table.private_rt.id
}

############################################
# Associate Private App Subnet 2
############################################

resource "aws_route_table_association" "private_app_2" {

  subnet_id = aws_subnet.private_app_subnet_2.id

  route_table_id = aws_route_table.private_rt.id
}

############################################
# Associate Private DB Subnet 1
############################################

resource "aws_route_table_association" "private_db_1" {

  subnet_id = aws_subnet.private_db_subnet_1.id

  route_table_id = aws_route_table.private_rt.id
}

############################################
# Associate Private DB Subnet 2
############################################

resource "aws_route_table_association" "private_db_2" {

  subnet_id = aws_subnet.private_db_subnet_2.id

  route_table_id = aws_route_table.private_rt.id
}

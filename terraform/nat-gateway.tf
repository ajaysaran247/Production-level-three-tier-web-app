############################################
# Elastic IP
############################################

resource "aws_eip" "nat_eip" {

  domain = "vpc"

  tags = {
    Name = "${var.project_name}-nat-eip"
  }
}

############################################
# NAT Gateway
############################################

resource "aws_nat_gateway" "nat" {

  allocation_id = aws_eip.nat_eip.id

  subnet_id = aws_subnet.public_subnet_1.id

  tags = {
    Name = "${var.project_name}-nat-gateway"
  }

  depends_on = [
    aws_internet_gateway.igw
  ]
}

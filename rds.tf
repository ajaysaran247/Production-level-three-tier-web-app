########################################
# DB Subnet Group
########################################

resource "aws_db_subnet_group" "db_subnet_group" {

  name = "three-tier-db-subnet-group"

  subnet_ids = [
    aws_subnet.private_db_subnet_1.id,
    aws_subnet.private_db_subnet_2.id
  ]

  tags = {
    Name = "DB-Subnet-Group"
  }
}

########################################
# RDS MySQL
########################################

resource "aws_db_instance" "mysql" {

  identifier = "three-tier-db"

  allocated_storage = 20

  storage_type = "gp3"

  engine = "mysql"

  engine_version = "8.0"

  instance_class = "db.t3.micro"

  db_name = "threetierdb"

  username = "admin"

  password = "ChangeMe123"

  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name

  vpc_security_group_ids = [
    aws_security_group.rds_sg.id
  ]

  skip_final_snapshot = true

  publicly_accessible = false

  multi_az = false

  backup_retention_period = 0

  deletion_protection = false

  tags = {
    Name = "Three-Tier-RDS"
  }
}

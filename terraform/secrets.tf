############################################
# AWS Secrets Manager
############################################

resource "aws_secretsmanager_secret" "database" {

  name = "${var.project_name}/database-v2"

  description = "Database credentials for Production Three Tier Application"

  tags = {
    Name        = "Three-Tier-Database-Secret"
    Environment = "Production"
  }
}

############################################
# Secret Value
############################################

resource "aws_secretsmanager_secret_version" "database" {

  secret_id = aws_secretsmanager_secret.database.id

  secret_string = jsonencode({
    DB_HOST     = aws_db_instance.mysql.address
    DB_PORT     = 3306
    DB_NAME     = "threetierdb"
    DB_USER     = "admin"
    DB_PASSWORD = var.db_password
  })
}

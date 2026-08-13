resource "local_file" "backend_env" {

  filename = "${path.module}/../application/backend/.env"

  content = <<EOF
DB_HOST=${aws_db_instance.mysql.endpoint}
DB_PORT=3306
DB_NAME=threetierdb
DB_USER=admin
DB_PASSWORD=ChangeMe123
EOF
}

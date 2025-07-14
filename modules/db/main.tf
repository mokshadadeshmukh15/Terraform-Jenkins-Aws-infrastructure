resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db-subnet-group"
  subnet_ids = var.private_subnet_ids
  tags = { Name = "db-subnet-group" }
}

resource "aws_db_instance" "sql" {
  identifier              = "dev-sql-db"
  engine                  = "sqlserver-ex"
  engine_version          = "15.00.4073.23.v1"
  instance_class          = "db.t3.medium"
  allocated_storage       = 20
  username                = var.db_username
  password                = var.db_password
  db_subnet_group_name    = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids  = [var.db_sg_id]
  skip_final_snapshot     = true
  storage_encrypted       = true
  publicly_accessible     = false
  multi_az                = false
}

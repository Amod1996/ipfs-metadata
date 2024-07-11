resource "aws_db_instance" "postgres" {
  allocated_storage    = 20
  engine               = "postgres"
  engine_version       = "14.10"
  instance_class       = "db.t3.micro"
  db_name              = "testdb"
  identifier           = "blockparty-sre-db"
  username             = var.postgres_user
  password             = var.postgres_password
  skip_final_snapshot  = true
  publicly_accessible  = true
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name = aws_db_subnet_group.main.name
}

resource "aws_db_subnet_group" "main" {
  name       = "main-subnet"
  subnet_ids = aws_subnet.public[*].id

  tags = {
    Name = "main-subnet"
  }
}
data "aws_db_subnet_group" "existing" {
  name = "main"
}
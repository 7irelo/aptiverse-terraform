resource "aws_db_subnet_group" "main" {
  name       = "${var.environment}-db-subnet-group"
  subnet_ids = var.private_subnets

  tags = {
    Name = "${var.environment}-db-subnet-group"
  }
}

resource "aws_db_instance" "main" {
  identifier              = "${var.environment}-db"
  engine                 = "postgres"
  engine_version         = "15.3"
  instance_class         = var.db_instance_class
  allocated_storage      = 20
  storage_type          = "gp3"
  storage_encrypted     = true
  username              = var.db_username
  password              = var.db_password
  db_name               = var.db_name

  vpc_security_group_ids = [var.security_groups.rds]
  db_subnet_group_name   = aws_db_subnet_group.main.name

  backup_retention_period = var.backup_retention_period
  backup_window          = "03:00-04:00"
  maintenance_window     = "sun:04:00-sun:05:00"
  multi_az              = var.multi_az

  skip_final_snapshot    = var.environment != "prod"
  final_snapshot_identifier = "${var.environment}-final-snapshot"

  enabled_cloudwatch_logs_exports = ["postgresql"]
  performance_insights_enabled = true

  tags = {
    Name = "${var.environment}-database"
  }
}

resource "aws_ssm_parameter" "db_password" {
  name        = "/${var.environment}/database/password"
  description = "Database password for ${var.environment}"
  type        = "SecureString"
  value       = var.db_password

  tags = {
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}
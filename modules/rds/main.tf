# modules/rds/main.tf
resource "aws_db_instance" "this" {
  allocated_storage      = var.allocated_storage
  max_allocated_storage  = var.max_allocated_storage
  engine                 = var.engine
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  db_subnet_group_name   = var.db_subnet_group_name
  vpc_security_group_ids = var.vpc_security_group_ids
  identifier             = var.instance_identifier
  username               = var.admin_username
  password               = var.admin_password
  backup_retention_period = var.backup_retention
  multi_az               = var.multi_az
  monitoring_interval    = var.monitoring_interval
  performance_insights_enabled = var.performance_insights
  deletion_protection    = var.deletion_protection
  skip_final_snapshot    = var.skip_final_snapshot
}

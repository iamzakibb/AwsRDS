
module "rds" {
  source               = "./modules/rds"
  db_name              = var.db_name
  instance_identifier  = var.instance_identifier
  engine               = var.engine
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  allocated_storage    = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  backup_retention     = var.backup_retention
  multi_az             = var.multi_az
  monitoring_interval  = var.monitoring_interval
  performance_insights = var.performance_insights
  deletion_protection  = var.deletion_protection
  skip_final_snapshot  = var.skip_final_snapshot
  admin_username       = var.admin_username
  admin_password       = var.admin_password
  vpc_security_group_ids = var.vpc_security_group_ids
  db_subnet_group_name = var.db_subnet_group_name
}


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
  vpc_security_group_ids = [module.rds_security_group.security_group_id]
  db_subnet_group_name =  module.rds_subnet_group.subnet_group_name
  backup_window = var.backup_window
  maintenance_window = var.maintenance_window
  tags               = var.tags
}
module "rds_security_group" {
  source              = "./security-group"
  security_group_name = var.security_group_name
  vpc_id              = var.vpc
  database_port       = 5432
  allowed_cidr_blocks = var.allowed_cidr_blocks
}
module "rds_subnet_group" {
  source             = "./modules/rds-subnet-grouwith-subnets"
  name               = var.subnet_group_name
  vpc_id             = var.vpc_id # Replace with your VPC ID
  vpc_cidr_block     = var.vpc_cidr_block # Replace with your VPC CIDR block
  new_subnet_prefix  = 8              # Subnet prefix (adjust to match subnet size)
  subnet_count       = 2              # Create 2 subnets in different AZs
  tags = {
    Environment = "dev"
    Project     = "my-rds-project"
  }
}

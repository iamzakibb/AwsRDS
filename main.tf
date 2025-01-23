data "aws_vpc" "selected" {
  id = var.vpc_id
}
data "aws_availability_zones" "available" {}


module "rds" {
  source               = "./modules/rds"
  allocated_storage = null
  max_allocated_storage = null
  cluster_identifier         = var.cluster_identifier
  vpc_security_group_ids     = [module.rds_security_group.security_group_id]
  instance_class             = var.instance_class
  instance_count             = var.instance_count
  db_name              = var.db_name
  instance_identifier  = var.instance_identifier
  engine               = var.engine
  engine_version       = var.engine_version
  backup_retention     = var.backup_retention
  multi_az             = var.multi_az
  monitoring_interval  = var.monitoring_interval
  performance_insights = var.performance_insights
  deletion_protection  = var.deletion_protection
  skip_final_snapshot  = var.skip_final_snapshot
  admin_username       = var.admin_username
  admin_password       = var.admin_password
  performance_insights_kms_key_id = module.rds.performance_insights_kms_key_id
  db_subnet_group_name = module.rds_subnet_group.name
  backup_window        = var.backup_window
  publicly_accessible        = var.publicly_accessible
  description = var.kms_key_description
  maintenance_window   = var.maintenance_window
    key_use_principals = [
    module.rds.monitoring_role_arn               
  ]
  key_management_principals = [module.rds.kms_management_role_arn]
  monitoring_role_arn = module.rds.monitoring_role_arn
  # enable_cloudwatch_logs_exports = ["postgresql", "upgrade"]
  tags                 = var.tags
}
module "rds_security_group" {
  source              = "./modules/security-group"
  security_group_name = var.security_group_name
  vpc_id              = var.vpc_id # Use the existing VPC ID
  database_port       = 5432
  
  # allowed_cidr_blocks = var.allowed_cidr_blocks
  tags                = var.tags
}

module "rds_subnet_group" {
  source             = "./modules/rds-subnet-group"
  name               = var.subnet_group_name
  vpc_id             = var.vpc_id # Reference existing VPC
  vpc_cidr = data.aws_vpc.selected.cidr_block
  vpc_cidr_block = data.aws_vpc.selected.cidr_block
  availability_zones = data.aws_availability_zones.available.names
  new_subnet_prefix  = 8              # Subnet prefix (adjust to match subnet size)
  subnet_count       = 2              # Create 2 subnets in different AZs
  tags               = var.tags
}

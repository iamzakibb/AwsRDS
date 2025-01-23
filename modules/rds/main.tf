data "aws_caller_identity" "current" {}
resource "aws_kms_key" "key" {
  description             = var.description
  enable_key_rotation     = true
  deletion_window_in_days = var.deletion_window_in_days

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "kms-key-policy",
  "Statement": [
    {
      "Sid": "AllowAccountAccess",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      },
      "Action": "kms:*",
      "Resource": "*"
    },
    {
      "Sid": "AllowKeyUse",
      "Effect": "Allow",
      "Principal": {
        "AWS": ${jsonencode(var.key_use_principals)}
      },
      "Action": [
        "kms:GenerateDataKey",
        "kms:CreateGrant",
        "kms:DescribeKey",
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*"
      ],
      "Resource": "*"
    }
  ]
}
POLICY

  tags = var.tags
}


  
resource "aws_rds_cluster" "this" {
  cluster_identifier              = var.cluster_identifier
  iam_database_authentication_enabled = true
  copy_tags_to_snapshot           = true
  final_snapshot_identifier  = "${var.cluster_identifier}-final-snapshot"
  engine                          = "aurora-postgresql"
  engine_version                  = var.engine_version
  database_name                   = var.db_name
  master_username                 = var.admin_username
  master_password                 = var.admin_password
  db_subnet_group_name            = var.db_subnet_group_name
  vpc_security_group_ids          = var.vpc_security_group_ids
  backup_retention_period         = var.backup_retention
  preferred_backup_window         = var.backup_window
  preferred_maintenance_window    = var.maintenance_window
  storage_encrypted               = true
  kms_key_id                      = aws_kms_key.key.arn
  deletion_protection             = var.deletion_protection
  enabled_cloudwatch_logs_exports  = ["postgresql"]

  tags = var.tags
}

resource "aws_rds_cluster_instance" "instances" {
  monitoring_interval = var.monitoring_interval
  monitoring_role_arn = aws_iam_role.rds_monitoring_role.arn
  count                           = var.instance_count
  identifier                      = "${var.cluster_identifier}-${count.index + 1}"
  cluster_identifier              = aws_rds_cluster.this.id
  instance_class                  = var.instance_class
  engine                          = aws_rds_cluster.this.engine
  publicly_accessible             = var.publicly_accessible
  performance_insights_enabled    = var.performance_insights
  performance_insights_kms_key_id = aws_kms_key.key.arn
  auto_minor_version_upgrade = true

  tags = var.tags
}



# resource "aws_db_instance" "this" {
#   allocated_storage = null
#   max_allocated_storage = null
#   engine                           = var.engine
#   engine_version                   = var.engine_version
#   instance_class                   = var.instance_class
#   db_subnet_group_name             = var.db_subnet_group_name
#   vpc_security_group_ids           = var.vpc_security_group_ids
#   identifier                       = var.instance_identifier
#   username                         = var.admin_username
#   password                         = var.admin_password
#   backup_retention_period          = var.backup_retention
#   multi_az                         = var.multi_az
#   monitoring_interval              = var.monitoring_interval
#   performance_insights_enabled     = var.performance_insights
#   performance_insights_kms_key_id  = aws_kms_key.key.arn
#   deletion_protection              = var.deletion_protection
#   skip_final_snapshot              = var.skip_final_snapshot
#   backup_window                    = var.backup_window
#   maintenance_window               = var.maintenance_window
#   
#   auto_minor_version_upgrade       = true
#   storage_encrypted = true
#   kms_key_id        = aws_kms_key.key.arn
#   monitoring_role_arn              = var.monitoring_role_arn

#   tags = merge(
#     var.tags,
#     {
#       "Name" = var.instance_identifier
#     }
#   )
# }

resource "aws_iam_role" "rds_monitoring_role" {
  name = "rds-monitoring-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "rds.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "rds_monitoring_policy" {
  role       = aws_iam_role.rds_monitoring_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

# Add IAM role for KMS key management
resource "aws_iam_role" "kms_management_role" {
  name = "kms-management-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "kms_management_policy" {
  role       = aws_iam_role.kms_management_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
}


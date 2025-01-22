resource "aws_kms_key" "key" {
  description             = var.description
  enable_key_rotation     = true
  multi_region            = false
  deletion_window_in_days = var.deletion_window_in_days

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "kms-key-policy",
  "Statement": [
    {
      "Sid": "UseAllow",
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
    },
    {
      "Sid": "ManageAllow",
      "Effect": "Allow",
      "Principal": {
        "AWS": ${jsonencode(var.key_management_principals)}
      },
      "Action": [
        "kms:Create*",
        "kms:Describe*",
        "kms:List*",
        "kms:Enable*",
        "kms:Put*",
        "kms:Revoke*",
        "kms:Update*",
        "kms:Disable*",
        "kms:Get*",
        "kms:Delete*",
        "kms:TagResource",
        "kms:UntagResource",
        "kms:ScheduleKeyDeletion",
        "kms:CancelKeyDeletion",
        "kms:ReplicateKey"
      ],
      "Resource": "*"
    }
  ]
}
POLICY

  tags = var.tags
}

resource "aws_db_instance" "this" {
  allocated_storage                = var.allocated_storage
  max_allocated_storage            = var.max_allocated_storage
  engine                           = var.engine
  engine_version                   = var.engine_version
  instance_class                   = var.instance_class
  db_subnet_group_name             = var.db_subnet_group_name
  vpc_security_group_ids           = var.vpc_security_group_ids
  identifier                       = var.instance_identifier
  username                         = var.admin_username
  password                         = var.admin_password
  backup_retention_period          = var.backup_retention
  multi_az                         = var.multi_az
  monitoring_interval              = var.monitoring_interval
  performance_insights_enabled     = var.performance_insights
  performance_insights_kms_key_id  = var.performance_insights_kms_key_id
  deletion_protection              = var.deletion_protection
  skip_final_snapshot              = var.skip_final_snapshot
  backup_window                    = var.backup_window
  maintenance_window               = var.maintenance_window
  enabled_cloudwatch_logs_exports  = ["error", "general", "slowquery", "audit"]
  auto_minor_version_upgrade       = true
  monitoring_role_arn              = var.monitoring_role_arn

  tags = merge(
    var.tags,
    {
      "Name" = var.instance_identifier
    }
  )
}

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

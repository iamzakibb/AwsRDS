
data "aws_availability_zones" "available" {}
data "aws_caller_identity" "current" {}
data "aws_db_subnet_group" "existing" {
  name = var.subnet_group_id
}
data "aws_security_group" "existing" {
  id = var.security_group_id
}

resource "aws_iam_role" "kms_secrets_admin" {
  name = "KMSSecretsAdminRoleForDB"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = data.aws_caller_identity.current.arn
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}
resource "aws_kms_key" "secrets_kms_key" {
  description         = "KMS key for encrypting secrets"
  enable_key_rotation = true

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      # 1. Root account full permissions
      {
        Sid       = "EnableRootPermissions",
        Effect    = "Allow",
        Principal = {
          AWS = "arn:aws-us-gov:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        Action   = "kms:*",
        Resource = "*"
      },

      # 2. Admin role access
      {
        Sid       = "AllowAdminAccess",
        Effect    = "Allow",
        Principal = {
          AWS = "arn:aws-us-gov:iam::${data.aws_caller_identity.current.account_id}:role/${aws_iam_role.kms_secrets_admin.name}"
        },
        Action   = [
          "kms:Decrypt",
          "kms:DescribeKey"
        ],
        Resource = "*"
      },

      # 3. RDS service principal permission
      {
        Sid       = "AllowRDSServiceAccess",
        Effect    = "Allow",
        Principal = {
          Service = "rds.amazonaws.com"
        },
        Action   = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ],
        Resource = "*"
      },

      # 4. Deny all others — except Root, Admin, and RDS service
      {
        Sid       = "DenyAllExceptRootAdminAndRDS",
        Effect    = "Deny",
        Principal = "*",
        Action    = "kms:*",
        Resource  = "*",
        Condition = {
          StringNotLike = {
            "aws:PrincipalArn" = [
              "arn:aws-us-gov:iam::${data.aws_caller_identity.current.account_id}:root",
              "arn:aws-us-gov:iam::${data.aws_caller_identity.current.account_id}:role/*"
            ]
          },
          StringNotEqualsIfExists = {
            "aws:PrincipalService" = "rds.amazonaws.com"
          }
        }
      }
    ]
  })
}



resource "aws_rds_cluster" "this" {
  cluster_identifier              = var.cluster_identifier
  engine                          = "aurora-postgresql"
  engine_version                  = var.engine_version
  database_name                   = var.db_name
  master_username                 = var.admin_username
  master_password                 = var.admin_password
  db_subnet_group_name            = data.aws_db_subnet_group.existing.id
  vpc_security_group_ids          = [data.aws_security_group.existing.id]

  backup_retention_period         = var.backup_retention
  preferred_backup_window         = var.backup_window
  preferred_maintenance_window    = var.maintenance_window

  storage_encrypted               = true
  kms_key_id                      = aws_kms_key.secrets_kms_key.arn

  deletion_protection             = false
  skip_final_snapshot             = var.skip_final_snapshot
  # final_snapshot_identifier       = var.skip_final_snapshot ? null : var.final_snapshot_identifier

  # copy_tags_to_snapshot           = true
  iam_database_authentication_enabled = true


  tags = var.tags
}

resource "aws_rds_cluster_instance" "instances" {
  count                           = var.instance_count
  identifier                      = "${var.cluster_identifier}-${count.index + 1}"
  cluster_identifier              = aws_rds_cluster.this.id
  instance_class                  = var.instance_class
  engine                          = aws_rds_cluster.this.engine
  publicly_accessible             = false

  performance_insights_enabled    = var.performance_insights
  performance_insights_kms_key_id = aws_kms_key.secrets_kms_key.arn

  # monitoring_interval             = var.monitoring_interval
  # monitoring_role_arn             = var.monitoring_role_arn
  auto_minor_version_upgrade      = true

  tags = var.tags
}

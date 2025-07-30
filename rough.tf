
data "aws_availability_zones" "available" {}
data "aws_caller_identity" "current" {}
# data "aws_db_subnet_group" "existing" {
#   name = var.subnet_group_id
# }

resource "aws_db_subnet_group" "rds_subnet_group_test_env" {
  name       = "test-env-subnet-group"
  description = "RDS subnet group for test environment"
  subnet_ids = [
    "subnet-03bb081ef2330c0a3",  
    "subnet-012f9231b775b34d3"   
  ]

  tags = {
    Name = "test-env-subnet-group"
    Environment = "test"
  }
}
data "aws_vpc" "existing" {
  id = var.vpc_id
}

resource "aws_security_group" "test_rds_sg" {
  name        = "Postgres-SG-Test"
  description = "Security group for test RDS PostgreSQL"
  vpc_id      = data.aws_vpc.existing.id

  # Ingress Rules (each rule defined separately)
  ingress {
    description     = "Allow PostgreSQL from SG 1"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    # cidr_blocks = data.aws_vpc.existing.cidr_block
    # security_groups = ["sg-067596a23bfce9a6"]
  }

  ingress {
    description     = "Allow PostgreSQL from SG 2"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    #  cidr_blocks = data.aws_vpc.existing.cidr_block
    # security_groups = ["sg-0be4a9d66bb7e3228"]
  }

  ingress {
    description     = "Allow PostgreSQL from SG 3"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    #  cidr_blocks = data.aws_vpc.existing.cidr_block
    # security_groups = ["sg-05f6ccc7d91078d8"]
  }

  ingress {
    description     = "Allow PostgreSQL from SG 4"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    #  cidr_blocks = data.aws_vpc.existing.cidr_block
    # security_groups = ["sg-0ccc965daf63ca665"]
  }

  ingress {
    description     = "Allow PostgreSQL from SG 5"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    #  cidr_blocks = data.aws_vpc.existing.cidr_block
    # security_groups = ["sg-0596ed447a7f1b896"]
  }

  ingress {
    description     = "Allow PostgreSQL from SG 6"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    #  cidr_blocks = data.aws_vpc.existing.cidr_block
    # security_groups = ["sg-0fb1c499684a53b0b"]
  }

  ingress {
    description     = "Allow PostgreSQL from SG 7"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    #  cidr_blocks = data.aws_vpc.existing.cidr_block
    # security_groups = ["sg-01f269c1998ad5182"]
  }

  #Egress
  egress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    # cidr_blocks = data.aws_vpc.existing.cidr_block
  }

  tags = {
    Name = "Postgres-SG-Test"
  }
}


resource "aws_iam_role" "kms_secrets_admin" {
  name = "KMSSecretsAdminRoleForDBTestEnv"

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
      # 1. Allow root account full access
      {
        Sid      = "AllowRootAccountFullAccess",
        Effect   = "Allow",
        Principal = {
          AWS = "arn:aws-us-gov:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        Action   = "kms:*",
        Resource = "*"
      },

      # 2. Allow the secrets admin IAM role
      {
        Sid      = "AllowSecretsAdminRole",
        Effect   = "Allow",
        Principal = {
          AWS = "arn:aws-us-gov:iam::${data.aws_caller_identity.current.account_id}:role/${aws_iam_role.kms_secrets_admin.name}"
        },
        Action   = [
          "kms:Decrypt",
          "kms:Encrypt",
          "kms:DescribeKey"
        ],
        Resource = "*"
      },

      # 3. Allow RDS service to use the key
      {
        Sid      = "AllowRDSServiceAccess",
        Effect   = "Allow",
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

      # 4. Deny everyone else unless it's root, the admin role, or RDS
      # {
      #   Sid       = "DenyAllExceptExplicitAllowed",
      #   Effect    = "Deny",
      #   Principal = "*",
      #   Action    = "kms:*",
      #   Resource  = "*",
      #   Condition = {
      #     "ArnNotLikeIfExists" = {
      #       "aws:PrincipalArn" = [
      #         "arn:aws-us-gov:iam::${data.aws_caller_identity.current.account_id}:root",
      #         "arn:aws-us-gov:iam::${data.aws_caller_identity.current.account_id}:role/${aws_iam_role.kms_secrets_admin.name}"
      #       ]
      #     },
      #     "StringNotEqualsIfExists" = {
      #       "aws:PrincipalService" = "rds.amazonaws.com"
      #     }
      #   }
      # }
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
  db_subnet_group_name            = aws_db_subnet_group.rds_subnet_group_test_env.name
  vpc_security_group_ids          = [aws_security_group.test_rds_sg.id]
  allow_major_version_upgrade     = true
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

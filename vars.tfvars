cluster_identifier         = "dev-aurora-cluster01"
engine_version             = "14.6"
db_name                    = "appdb"
admin_username             = "dbadmin"
admin_password             = "StrongP@ssword123"
subnet_group_id            = "default-vpc-0f29e4c236e003fb8"
security_group_id          = "sg-07e4f5ad51341741b"
instance_class             = "db.r6g.large"
instance_count             = 2

backup_retention           = 7
backup_window              = "02:00-03:00"
maintenance_window         = "Sun:03:00-Sun:04:00"

performance_insights       = true
# monitoring_interval        = 60
# monitoring_role_arn        = ""

skip_final_snapshot        = false
final_snapshot_identifier  = "dev-aurora-cluster-final"

tags = {
  Environment = "dev"
  Project     = "aurora-poc"
}


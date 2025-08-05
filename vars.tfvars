cluster_identifier         = "infobank-test"

engine_version             = "16.6"
db_name                    = "infobank"
admin_username             = "dbadmin"
admin_password             = "StrongP##ssword123"
# subnet_group_id            = "default-vpc-0f29e4c236e003fb8"
#security_group_id          = "sg-0a00755380fd64daf"
instance_class             = "db.r6g.large"
instance_count             = 1

backup_retention           = 7
backup_window              = "02:00-03:00"
maintenance_window         = "Sun:03:00-Sun:04:00"

performance_insights       = true
# monitoring_interval        = 60
# monitoring_role_arn        = ""

skip_final_snapshot        = true
final_snapshot_identifier  = "test-aurora-cluster-final"

tags = {
  Environment = "test"
  Project     = "aurora-poc"
}
vpc_id = "vpc-0362a10068758712d"

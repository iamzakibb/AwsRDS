
# output "rds_endpoint" {
#   description = "The RDS endpoint address."
#   value       = aws_db_instance.this.endpoint
# }

# output "rds_instance_id" {
#   description = "The ID of the RDS instance."
#   value       = aws_db_instance.this.id
# }

# output "tags" {
#   value = aws_db_instance.this.tags
# }

output "monitoring_role_arn" {
  value = aws_iam_role.rds_monitoring_role.arn
}

output "performance_insights_kms_key_id" {
  value = aws_kms_key.key.id
  description = "The KMS key ID used for performance insights in the RDS instance."
}
output "kms_key_arn" {
  value = aws_kms_key.key.arn
}
output "kms_management_role_arn" {
  value = aws_iam_role.kms_management_role.arn
}

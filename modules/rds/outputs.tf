
output "rds_endpoint" {
  description = "The RDS endpoint address."
  value       = aws_db_instance.this.endpoint
}

output "rds_instance_id" {
  description = "The ID of the RDS instance."
  value       = aws_db_instance.this.id
}
output "tags" {
  description = "Tags applied to the RDS instance"
  value       = aws_db_instance.rds_instance.tags
}

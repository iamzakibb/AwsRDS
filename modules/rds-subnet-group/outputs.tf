output "subnet_ids" {
  description = "The IDs of the created subnets"
  value       = aws_subnet.private[*].id
}

output "subnet_group_name" {
  description = "The name of the RDS Subnet Group"
  value       = aws_db_subnet_group.this.name
}
output "name" {
  value = aws_db_subnet_group.this.name
}
output "subnet_group_arn" {
  description = "The ARN of the RDS Subnet Group"
  value       = aws_db_subnet_group.this.arn
}

output "private_subnet_cidrs" {
  value = [for i in range(var.number_of_subnets) : cidrsubnet(var.vpc_cidr, 2, i)]
}

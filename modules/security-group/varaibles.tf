variable "security_group_name" {
  description = "Name of the RDS security group"
  type        = string
  default     = "rds-security-group"
}

variable "vpc_id" {
  description = "VPC ID where the security group will be created"
  type        = string
}

variable "database_port" {
  description = "Port number for the database (e.g., 3306 for MySQL, 5432 for PostgreSQL)"
  type        = number
  default     = 5432
}

variable "allowed_cidr_blocks" {
  description = "List of CIDR blocks allowed to access the database"
  type        = list(string)
  default     = ["192.168.1.0/24"] # Replace with your trusted CIDR ranges
}

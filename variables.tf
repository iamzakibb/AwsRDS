
variable "db_name" {
  description = "The name of the database to create."
  type        = string
  default = "value"
}

variable "instance_identifier" {
  description = "The identifier for the RDS instance."
  type        = string
  default = "dev-aurora-postgres"
}

variable "engine" {
  description = "The database engine to use (e.g., postgres, aurora)."
  type        = string
  default     = "aurora-postgresql"
}

variable "engine_version" {
  description = "The engine version to use."
  type        = string
  default = "16.4"
}

variable "instance_class" {
  description = "The instance type of the RDS instance."
  type        = string
  default = "db.r4.large"
}

variable "allocated_storage" {
  description = "The amount of allocated storage in GB."
  type        = number
  default = 10
}

variable "max_allocated_storage" {
  description = "The maximum allocated storage for autoscaling."
  type        = number
  default = 50
}

variable "backup_retention" {
  description = "The number of days to retain backups."
  type        = number
  default     = 35
}


variable "multi_az" {
  description = "Whether to deploy a Multi-AZ RDS instance."
  type        = bool
  default     = true
}

variable "monitoring_interval" {
  description = "The interval, in seconds, between enhanced monitoring metrics."
  type        = number
  default = 0
}

variable "performance_insights" {
  description = "Whether to enable Performance Insights."
  type        = bool
  default     = true
}

variable "deletion_protection" {
  description = "Whether to enable deletion protection."
  type        = bool
  default = true
}

variable "skip_final_snapshot" {
  description = "Whether to skip taking a final DB snapshot before deletion."
  type        = bool
  default     = false
}

variable "admin_username" {
  description = "The master username for the database."
  type        = string
  default = "value"
}

variable "admin_password" {
  description = "The master password for the database."
  type        = string
  sensitive   = true
  default = "value"
}

variable "vpc_security_group_ids" {
  description = "A list of VPC security groups to associate with the RDS instance."
  type        = list(string)
  default = [ "value" ]
}

variable "db_subnet_group_name" {
  description = "A DB subnet group to associate with the RDS instance."
  type        = string
  default = "value"
}
 variable "backup_window" {
  description = "The daily time range during which backups are created."
  type = string
  default = "22:00-03:00"
   
 }
 variable "maintenance_window" {
  type = string
  default = "Mon:03:00-Mon:04:00"
   
 }
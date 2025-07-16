variable "required_tags" {

}
variable "cluster_identifier" {
  description = "Unique name for the Aurora cluster"
  type        = string
}

variable "engine_version" {
  description = "Aurora PostgreSQL engine version"
  type        = string
}

variable "db_name" {
  description = "Initial database name (must not be a reserved word)"
  type        = string
}

variable "admin_username" {
  description = "Master username (not 'admin' or other reserved)"
  type        = string
}

variable "admin_password" {
  description = "Master user password"
  type        = string
  sensitive   = true
}


variable "instance_class" {
  description = "Instance class for each cluster instance"
  type        = string
}

variable "instance_count" {
  description = "Number of writer/reader instances"
  type        = number
}

variable "backup_retention" {
  description = "Days to retain backups"
  type        = number
}

variable "backup_window" {
  description = "Preferred daily backup window"
  type        = string
}

variable "maintenance_window" {
  description = "Preferred weekly maintenance window"
  type        = string
}

variable "performance_insights" {
  description = "Enable Performance Insights?"
  type        = bool
}


variable "skip_final_snapshot" {
  description = "Skip final snapshot on deletion?"
  type        = bool
}

variable "final_snapshot_identifier" {
  description = "Identifier for the final snapshot (if skip_final_snapshot = false)"
  type        = string
}

variable "tags" {
  description = "Map of tags to apply to all resources"
  type        = map(string)
}

variable "subnet_group_id" {
  description = "ID of the existing DB subnet group"

}

variable "security_group_id" {
  description = "ID of the existing security group"

}


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
  default = "admin"
}

variable "admin_password" {
  description = "The master password for the database."
  type        = string
  sensitive   = true
  default = "appUser"
}

variable "vpc_security_group_ids" {
  description = "A list of VPC security groups to associate with the RDS instance."
  type        = list(string)
  default = [ "value" ]
}

variable "vpc_id" {
  description = "VPC ID where the security group will be created"
  type        = string
}


 variable "backup_window" {
  description = "The daily time range during which backups are created."
  type = string
  default = "22:00-03:00"
   
 }
 variable "maintenance_window" {
  type = string
  default = "sun:05:00-sun:06:00"
   
 }
variable "security_group_name" {
  description = "Name of the RDS security group"
  type        = string
  default     = "rds-security-group"
}
variable "allowed_cidr_blocks" {
  description = "List of CIDR blocks allowed to access the database"
  type        = list(string)
  default     =  ["", ""] # Replace with your trusted CIDR ranges
}
variable "tags" {
  default = {
    "CI Environment"          = "production" # Change based on your environment
    "Information Classification" = "confidential"
    "AppServiceTag"           = "approved-value" # Replace 'approved-value' with a valid value
  }
}
variable "vpc_id" {
  description = "The ID of the VPC where the subnets will be created"
  type        = string
  default = "vpc-0f29e4c236e003fb8"
}

variable "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  type        = string
  default = "value"
}
variable "db_subnet_group_name" {
  description = "A DB subnet group to associate with the RDS instance."
  type        = string
  default = "rds-subnet-group"
}
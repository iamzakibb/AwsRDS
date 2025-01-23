variable "name" {
  description = "The name of the DB subnet group"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC where the subnets will be created"
  type        = string
}

variable "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  type        = string
}

variable "new_subnet_prefix" {
  description = "The subnet prefix to create new subnets (e.g., 8 for /24 subnets)"
  type        = number
  default     = 8
}

variable "subnet_count" {
  description = "The number of subnets to create"
  type        = number
  default     = 2
}

variable "tags" {
  description = "A map of tags to assign to resources"
  type        = map(string)
  default     = {}
}
variable "private_subnet_cidrs" {
  description = "A list of CIDR blocks for the private subnets"
  type        = list(string)
default = [ "10.0.1.0/24", "10.0.2.0/24"] 
}
variable "number_of_subnets" {
  type = string
  default = "2"
}
variable "vpc_cidr" {
  type = string
  
  
}
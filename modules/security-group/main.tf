data "aws_vpc" "selected" {
  id = var.vpc_id
}

resource "aws_security_group" "rds_sg" {
  name        = var.security_group_name
  description = "Security group for RDS instance"
  vpc_id      = data.aws_vpc.selected.id # Use existing VPC ID
  tags = var.tags
}

resource "aws_security_group_rule" "allow_inbound_db" {
  type              = "ingress"
  from_port         = var.database_port
  to_port           = var.database_port
  protocol          = "tcp"
  security_group_id = aws_security_group.rds_sg.id

  # Restrict access to specific IP ranges (replace with trusted CIDRs)
  cidr_blocks = var.allowed_cidr_blocks
}

resource "aws_security_group_rule" "allow_outbound_to_vpc" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1" # Allows all protocols
  security_group_id = aws_security_group.rds_sg.id

  # Restrict egress to the CIDR block of the existing VPC
  cidr_blocks = [data.aws_vpc.selected.cidr_block]
}

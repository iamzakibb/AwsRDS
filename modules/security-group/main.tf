resource "aws_security_group" "rds_sg" {
  name        = var.security_group_name
  description = "Security group for RDS instance"
  vpc_id      = var.vpc_id
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

resource "aws_security_group_rule" "allow_outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1" # Allows all outbound traffic
  security_group_id = aws_security_group.rds_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}

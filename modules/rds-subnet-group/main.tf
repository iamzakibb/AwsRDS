# Create subnets
resource "aws_subnet" "private" {
  count                   = var.subnet_count
  vpc_id                  = var.vpc_id
  cidr_block              = cidrsubnet(var.vpc_cidr_block, var.new_subnet_prefix, count.index)
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = false

  tags = merge(
    {
      Name = "${var.name}-private-subnet-${count.index}"
    },
    var.tags
  )
}

# Data source for AZs
data "aws_availability_zones" "available" {}

# Create an RDS Subnet Group
resource "aws_db_subnet_group" "this" {
  name       = var.name
  subnet_ids = aws_subnet.private[*].id

  tags = merge(
    {
      Name = var.name
    },
    var.tags
  )
}

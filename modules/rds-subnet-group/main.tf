# Create subnets
resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)

  vpc_id     = var.vpc_id
  cidr_block        = cidrsubnet(var.vpc_cidr, 3, count.index)
  availability_zone = var.availability_zones[count.index]

  tags = merge(
    var.tags,
    {
      "Name" = "private-subnet-${count.index + 1}"
    }
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

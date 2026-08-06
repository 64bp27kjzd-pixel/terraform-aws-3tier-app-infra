# ----------------------
# VPC
# ----------------------
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(var.common_tags, {
    Name = local.vpc_name
  })
}

# ----------------------
# Public Subnet
# ----------------------
resource "aws_subnet" "public" {
  count = length(var.azs)

  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = false

  tags = merge(var.common_tags, {
    Name = "${var.name_prefix}-public-subnet-${count.index + 1}"
  })
}

# ----------------------
# Private Subnet
# ----------------------
resource "aws_subnet" "private" {
  count = length(var.azs)

  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index + length(var.azs))
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = false

  tags = merge(var.common_tags, {
    Name = "${var.name_prefix}-private-subnet-${count.index + 1}"
  })
}

# ----------------------
# Internet Gateway
# ----------------------
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags   = merge(var.common_tags, {
    Name   = local.igw_name
  })
}

# ----------------------
# NAT Gateway
# ----------------------
resource "aws_eip" "this" {
  count  = local.nat_gateway_count
  domain = "vpc"

  tags = merge(var.common_tags, {
    Name   = "${local.eip_name}-${count.index + 1}"
  })
}

resource "aws_nat_gateway" "this" {
  count = local.nat_gateway_count

  allocation_id = aws_eip.this[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = merge(var.common_tags, {
    Name = "${local.nat_gateway_name}-${count.index + 1}"
  })

  depends_on = [aws_internet_gateway.this]
}

# ----------------------
# Route Table (Public)
# ----------------------
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = merge(var.common_tags, {
    Name = local.public_rt_name
  })
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# ----------------------
# Route Table (Private)
# ----------------------
resource "aws_route_table" "private" {
  count  = length(aws_subnet.private)
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this[var.single_nat_gateway ? 0 : count.index].id
  }

  tags = merge(var.common_tags, {
    Name = "${local.private_rt_name}-${count.index + 1}"
  })
}

resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}
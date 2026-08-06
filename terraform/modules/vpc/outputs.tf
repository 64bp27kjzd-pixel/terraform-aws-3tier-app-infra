output "vpc_id" {
  value = aws_vpc.this.id
}

output "vpc_cidr" {
  value = aws_vpc.this.cidr_block
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "public_cidrs" {
  value = aws_subnet.public[*].cidr_block
}

output "private_cidrs" {
  value = aws_subnet.private[*].cidr_block
}

output "nat_gateway_ids" {
  description = "NAT Gateway IDのリスト"
  value       = aws_nat_gateway.this[*].id
}

output "nat_gw_ids" {
  value = aws_nat_gateway.this[*].id
}
locals {
  vpc_name         = "${var.name_prefix}-vpc"
  eip_name         = "${var.name_prefix}-eip"
  igw_name         = "${var.name_prefix}-igw"
  nat_gateway_name = "${var.name_prefix}-nat-gateway"
  public_rt_name   = "${var.name_prefix}-public-rt"
  private_rt_name  = "${var.name_prefix}-private-rt"
}
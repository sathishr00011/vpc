################################################
# Public subnets
# Each subnet in a different AZ
################################################
resource "aws_subnet" "public" {
  count                   = "${length(var.availability_zones)}"
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${cidrsubnet(var.cidr_block, 8, count.index)}"
  availability_zone       = "${element(var.availability_zones, count.index)}"
  map_public_ip_on_launch = true

  tags = {
    "name" = "Public subnet - ${element(var.availability_zones, count.index)}"
  }
}
################################################
# Public subnets
# Each subnet in a different AZ
################################################
resource "aws_subnet" "private" {
  count  = "${length(var.availability_zones)}"
  vpc_id = "${aws_vpc.main.id}"

  # Take into account CIDR block allocated to the public subnet

  cidr_block              = "${cidrsubnet(var.cidr_block, 8, count.index + length(var.availability_zones))}"
  availability_zone       = "${element(var.availability_zone, count.index)}"
  map_public_ip_on_launch = false

  tags = {
    "Name" = "Private subnet - ${element(var.availability_zones, count.index)}"
  }
}
####################################################
# Nat gateways enable instances in a private subnet
# to connect to the internet or other AWS services,
# but prevent the internet from initiating
#
# we create a separate NAT gateway in each AZ
#
# Each NAT gatway requires an Elastic IP
####################################################
resource "aws_eip" "nat" {
  count = "${length(var.availability_zones)}"
  vpc   = true
}
resource "aws_nat_gateway" "main" {
  count         = "${length(var.availability_zones)}"
  subnet_id     = "${element(aws_subnet.public.*.id, count.index)}"
  allocation_id = "${element(aws_eip.nat.*.id, count.index)}"

  tags = {
    "Name" = "NAT - ${element(var.availability_zones, count.index)}"
  }
}




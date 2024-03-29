resource "aws_vpc" "main" {
  cidr_block = "${var.cidr_block}"
  tags = {
    "Name" = "Main VPC"
  }
}

######################################################
# Enable access to or from the Internet for instances
# in pblic subnets
######################################################

resource "aws_internet_getway" "main" {
  vpc_id = "${aws_vpc.main.id}"
  tags = {
    "Name" = "Main IGW"
  }
}

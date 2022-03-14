resource "aws_vpc" "vpc_PUB" {
  cidr_block           = "10.10.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name        = "Public VPC"
  }
}
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.vpc_PUB.id}"
  tags = {
    Name = "GW_TERRAFORM"
  }
}
resource "aws_eip" "eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.gw]
}
resource "aws_subnet" "public_subnet" {
  vpc_id                  = "${aws_vpc.vpc_PUB.id}"
  count                   = 1
  cidr_block              = "10.10.0.0/24"
  availability_zone       = "eu-west-1b"
  map_public_ip_on_launch = true
  tags = {
    Name        = element(var.sub_PUB, count.index)
  }
}
resource "aws_route_table" "rt-public" {
  vpc_id = "${aws_vpc.vpc_PUB.id}"
  route {
    cidr_block    = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  route {
    cidr_block    = "10.20.0.0/16"
    vpc_peering_connection_id = aws_vpc_peering_connection.VPC_PEER.id
  }
  tags = {
    Name = "RT_TERRAFORM_PUBLIC"
  }
}
resource "aws_route_table_association" "RTA-public" {
  count          = 1
  subnet_id      = "${element(aws_subnet.public_subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.rt-public.id}"
}

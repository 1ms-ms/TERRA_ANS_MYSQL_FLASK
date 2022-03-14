resource "aws_vpc" "vpc_PRIV" {
  cidr_block           = "10.20.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name        = "Private VPC"
  }
}
resource "aws_vpc_peering_connection" "VPC_PEER" {
  peer_owner_id = 537646401150
  peer_vpc_id   = aws_vpc.vpc_PRIV.id
  vpc_id        = aws_vpc.vpc_PUB.id
  auto_accept   = true
}
resource "aws_subnet" "private_subnet" {
  vpc_id                  = "${aws_vpc.vpc_PRIV.id}"
  cidr_block              = "10.20.0.0/24"
  availability_zone       = "eu-west-1a"
  map_public_ip_on_launch = false
  tags = {
    Name        = element(var.sub_PRIV, 1)
  }
}
resource "aws_route_table" "rt-private" {
  vpc_id = "${aws_vpc.vpc_PRIV.id}"
  route {
    cidr_block    = "10.10.0.0/16"
    vpc_peering_connection_id = aws_vpc_peering_connection.VPC_PEER.id
  }
  tags = {
    Name = "RT_TERRAFORM_PRIVATE"
  }
}
resource "aws_route_table_association" "RTA-private" {
  count          = 1
  subnet_id      = "${element(aws_subnet.private_subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.rt-private.id}"
}

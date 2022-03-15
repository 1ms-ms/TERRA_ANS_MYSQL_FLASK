resource "aws_subnet" "private_subnet" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "10.10.20.0/24"
  availability_zone       = "eu-west-1a"
  map_public_ip_on_launch = false
  tags = {
    Name        = element(var.sub_PRIV, 1)
  }
}
resource "aws_route_table" "rt-private" {
  vpc_id = "${aws_vpc.vpc.id}"
  route {
    cidr_block    = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.NAT.id
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

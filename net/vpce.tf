locals {
    endpoints = toset([
        "ssm",
        "ssmmessages",
        "ec2messages"
    ])
}

resource "aws_security_group" "vpce_sg" {
  vpc_id = aws_vpc.main.id
}

resource "aws_vpc_security_group_ingress_rule" "allow_vpc_in" {
  security_group_id = aws_security_group.vpce_sg.id
  cidr_ipv4 = aws_vpc.main.cidr_block
  ip_protocol = "tcp"
  from_port = 443
  to_port = 443
}

resource "aws_vpc_security_group_egress_rule" "allow_vpc_out" {
  security_group_id = aws_security_group.vpce_sg.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = -1
}

resource "aws_vpc_endpoint" "vpce" {
    for_each =  local.endpoints
    vpc_id = aws_vpc.main.id
    private_dns_enabled = true
    vpc_endpoint_type = "Interface"
    subnet_ids = values(aws_subnet.private)[*].id
    security_group_ids = [aws_security_group.vpce_sg.id]
    service_name = "com.amazonaws.${var.region}.${each.key}"
}
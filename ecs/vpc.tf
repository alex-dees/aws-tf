
locals {
    azs = slice(
        data.aws_availability_zones.available.names, 
        0, 
        var.az_num)
}

resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/24"
    enable_dns_hostnames = true
    tags = { 
        Name = "${var.namespace}-vpc" 
    }
}

resource "aws_subnet" "private" {
    vpc_id = aws_vpc.main.id
    availability_zone = local.azs[0]
    cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 1, 1)
}

# for_each = { for index, name in local.azs : index => name }
# cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 1, each.key)
# availability_zone = each.value

resource "aws_route_table" "pvt-rt" {
    vpc_id = aws_vpc.main.id
}

resource "aws_route_table_association" "pvt-rt-association" {
  subnet_id = aws_subnet.private.id
  route_table_id = aws_route_table.pvt-rt.id
}
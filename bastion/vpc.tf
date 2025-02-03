
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
    for_each = { for index, name in local.azs : index => name }

    vpc_id = aws_vpc.main.id
    availability_zone = each.value
    cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 1, each.key)
    tags = { 
        Name = "${var.namespace}-private-${each.key}"
    }
}

data "aws_ami" "amzn-linux-2023" {
  most_recent = true
  owners = ["amazon"]
  
  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

resource "aws_iam_instance_profile" "bastion-profile" {
  name = "bastion-profile"
  role = aws_iam_role.bastion-role.name
}

resource "aws_security_group" "ec2_sg" {
  vpc_id = aws_vpc.main.id
}

resource "aws_vpc_security_group_ingress_rule" "ec2_sg_in" {
  security_group_id = aws_security_group.ec2_sg.id
  cidr_ipv4 = aws_vpc.main.cidr_block
  ip_protocol = "tcp"
  from_port = 22
  to_port = 22
}

resource "aws_vpc_security_group_egress_rule" "ec2_sg_out" {
  security_group_id = aws_security_group.ec2_sg.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = -1
}

resource "aws_instance" "bastion" {
  instance_type = var.instance_type
  subnet_id = aws_subnet.private.id
  ami = data.aws_ami.amzn-linux-2023.image_id
  vpc_security_group_ids = [ aws_security_group.ec2_sg.id ]
  iam_instance_profile = aws_iam_instance_profile.bastion-profile.name
}
variable "region" {
  type = string
  default = "us-east-1"
}

variable "namespace" {
  type = string
  default = "net"
}

variable "az_num" {
  type    = number
  default = 2
}

variable "instance_type" {
  type = string
  default = "t3.micro"
}
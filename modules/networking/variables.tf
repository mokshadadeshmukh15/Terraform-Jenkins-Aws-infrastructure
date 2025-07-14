variable "vpc_cidr" {}
variable "vpc_name" {}
variable "cidr_public_subnet" { type = list(string) }
variable "cidr_private_subnet" { type = list(string) }
variable "availability_zones" { type = list(string) }

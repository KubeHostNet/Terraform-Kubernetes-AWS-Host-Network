## Copyright 2020 Green River IT as described in LICENSE.txt distributed with this project on GitHub.  
## Start at https://github.com/KubeHostNet/  
  
# VPC and elements

resource "aws_vpc" "kubernetes-host" {
  cidr_block = "10.1.0.0/16"
  enable_dns_hostnames = "1"
   tags { Name = "Kubernetes-Host" }
}

resource "aws_subnet" "kubernetes-host" {
  count = 2
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block        = "10.1.${count.index}.0/25"
  vpc_id            = "${aws_vpc.kubernetes-host.id}"
}

#resource "aws_subnet" "kubernetes-control-plane" {
#  availability_zone = "${data.aws_availability_zones.available.names[0]}"
#  cidr_block        = "10.1.0.128/25"
#  vpc_id            = "${aws_vpc.kubernetes-host.id}"
#}


resource "aws_internet_gateway" "kubernetes-host" {
  vpc_id = "${aws_vpc.kubernetes-host.id}"
}

##################################################################################################
### PLACING "aws_route_table" "kubernetes-host" IN SEPARATE FILE FOR CLEANER AUTOMATION
##################################################################################################

resource "aws_route_table_association" "kubernetes-host" {
  count = 2
  subnet_id      = "${aws_subnet.kubernetes-host.*.id[count.index]}"
  route_table_id = "${aws_route_table.kubernetes-host.id}"
}

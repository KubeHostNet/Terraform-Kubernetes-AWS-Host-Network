## Copyright 2020 Green River IT as described in LICENSE.txt distributed with this project on GitHub.  
## Start at https://github.com/KubeHostNet/  
  
resource "aws_route_table" "kubernetes-host" {
  vpc_id = "${aws_vpc.kubernetes-host.id}"
}

resource "aws_route" "everyone" {
  route_table_id            = "${aws_route_table.kubernetes-host.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.kubernetes-host.id}"
  depends_on                = ["aws_route_table.kubernetes-host"]
}

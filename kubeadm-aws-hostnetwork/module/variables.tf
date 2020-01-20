## Copyright 2020 Green River IT as described in LICENSE.txt distributed with this project on GitHub.  
## Start at https://github.com/KubeHostNet/  
  
# These data sources make the config generic for any region.
data "aws_region" "current" {}
data "aws_availability_zones" "available" {}

# Values for these variables will be fed in by the call to instantiate this module.
variable "access_key" { }
variable "region" { }
variable "path_to_ssh_keys" { }
variable "name_of_ssh_key" { }
variable "num_worker_nodes" { }
variable "max_worker_nodes" { }
variable "min_worker_nodes" { }

#############Output variables
output "security_group_id_kubernetes_nodes" { value = "${aws_security_group.kubernetes-nodes.id}" }
output "vpc_id_kubernetes" { value = "${aws_vpc.kubernetes-host.id}" }
output "cidr_subnet_list_kubernetes" { value = "${aws_subnet.kubernetes-host.*.cidr_block}" }
output "route_table_id_kubernetes_host" { value = "${aws_route_table.kubernetes-host.id}" }
output "cidr_vpc_kubernetes" { value = "${aws_vpc.kubernetes-host.cidr_block}" }

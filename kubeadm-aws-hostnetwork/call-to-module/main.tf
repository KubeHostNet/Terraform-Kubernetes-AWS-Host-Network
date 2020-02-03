## Copyright 2020 Green River IT as described in LICENSE.txt distributed with this project on GitHub.  
## Start at https://github.com/KubeHostNet/  
  
module "kubeadm-aws-hostnetwork" {
  source = "../module/"
  region = "${var.k8s_region}"
  access_key = "${var.k8s_public_access_key}"
  path_to_ssh_keys = "${var.path_to_ssh_keys}"
  name_of_ssh_key = "${var.name_of_ssh_key}"
  num_worker_nodes = 3
  max_worker_nodes = 3
  min_worker_nodes = 1

}

# Input variables to be fed in from .tfvars for security purposes
variable "k8s_region" { }
variable "k8s_public_access_key" { }
variable "path_to_ssh_keys" { }
variable "name_of_ssh_key" { }

##Output variables
output "security_group_id_kubernetes_nodes" { value = "${module.kubeadm-aws-hostnetwork.security_group_id_kubernetes_nodes}" }
output "vpc_id_kubernetes" { value = "${module.kubeadm-aws-hostnetwork.vpc_id_kubernetes}" }
output "cidr_subnet_list_kubernetes" { value = "${module.kubeadm-aws-hostnetwork.cidr_subnet_list_kubernetes}" }
output "cidr_subnet_list_kubernetes_control" { value = "${module.kubeadm-aws-hostnetwork.cidr_subnet_list_kubernetes_control}" }
output "cidr_vpc_kubernetes" { value = "${module.kubeadm-aws-hostnetwork.cidr_vpc_kubernetes}" }
output "route_table_id_kubernetes_host" { value = "${module.kubeadm-aws-hostnetwork.route_table_id_kubernetes_host}" }



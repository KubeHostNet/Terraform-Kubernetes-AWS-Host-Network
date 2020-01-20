# Terraform Kubernetes AWS Host Network 
  
Terraform Kubernetes AWS Host Network is an open-source toolkit for creating 
and maintaining a Host Network that can house a Kubernetes Cluster on AWS.  
  
This project is a component of KubeHostNet, which will consume and manage this.  
  
The Kubernetes cluster that will run inside this host network will be created by 
[Ansible Kubernetes Kubeadm Playbooks](https://github.com/greenriverit/ansible-kubernetes-kubeadm-playbooks/), 
which is also on GitHub as part of KubeHostNet.  
  
The names defined as tags for the EC2 instances in Terraform Kubernetes AWS Host 
Network match the group names defined in Ansible Kubernetes Kubeadm Playbooks.  
  
Matching of these tag names and group names is necessary in order for the automation 
to work properly.  For simplicity, we have chosen the names `k8smaster`, `k8sworker`, 
and `k8sadmin` to represent the Kubernetes Master, the Kubernetes Worker Nodes, and 
the external Kubernetes administration machine (which should be running outside the 
cluster somewhere else in your networks).  
  
The primary development of Terraform Kubernetes AWS Host Network was done by
[Green River IT, Incorporated](http://greenriverit.com) in California.  It is released 
under the generous license terms defined in the [LICENSE](LICENSE.txt) file.
  
## Support
  
If you encounter any problems with this release, please create a
[GitHub Issue](https://github.com/GreenRiverIT/Terraform-Kubernetes-AWS-Host-Network/issues).
  
For commercial support please send us an email.  
  
## Dependencies
  
This is meant to be consumed by KubeHostNet. 

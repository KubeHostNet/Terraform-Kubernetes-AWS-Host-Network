## Copyright 2020 Green River IT as described in LICENSE.txt distributed with this project on GitHub.  
## Start at https://github.com/KubeHostNet/  
  
# Security groups and rules.  
# In this simplified example, we are putting all master and worker nodes in the same security group and subnet.  

resource "aws_security_group" "kubernetes-nodes" {
  name        = "kubernetes nodes"
  description = "Security group for all nodes in the cluster"
  vpc_id      = "${aws_vpc.kubernetes-host.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_security_group_rule" "kubernetes-nodes-ingress-each-other" {
  description              = "Allow node to communicate with each other"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = "${aws_security_group.kubernetes-nodes.id}"
  source_security_group_id = "${aws_security_group.kubernetes-nodes.id}"
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "host-nodes-ingress-each-other-ssh" {
  description              = "Allow Ansible server and clients to communicate with each other"
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  security_group_id        = "${aws_security_group.kubernetes-nodes.id}"
  source_security_group_id = "${aws_security_group.kubernetes-nodes.id}"
}

###################################################################################################################
## Separate file will define "aws_security_group_rule" "vpc-peer-nodes-ingress-each-other" for easier automation. 
###################################################################################################################

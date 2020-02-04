## Copyright 2020 Green River IT as described in LICENSE.txt distributed with this project on GitHub.  
## Start at https://github.com/KubeHostNet/  
  
####################################################  
# This USERDATA will prepare each EC2 instance to allow ansible to install Kubernetes.
# Using a Terraform local simplifies Base64 encoding.  
locals {

  k8s-host-userdata = <<USERDATA
#!/bin/bash -xe
# Install software
sudo yum -y update
sudo amazon-linux-extras install -y epel
sudo yum -y install awscli
sudo yum -y install ansible
sudo yum install -y dos2unix
sudo yum install -y telnet
sudo yum install -y git  
  
# Add user
sudo groupadd -g 2002 kubernetes-host
sudo useradd -u 2002 -g 2002 -c "Kubernetes Host Account" -s /bin/bash -m -d /home/kubernetes-host kubernetes-host

# Configure SSH for the user
mkdir -p /home/kubernetes-host/.ssh
cp -pr /home/ec2-user/.ssh/authorized_keys /home/kubernetes-host/.ssh/authorized_keys
chown -R kubernetes-host:kubernetes-host /home/kubernetes-host/.ssh
chmod 700 /home/kubernetes-host/.ssh
cat << 'EOF' > /etc/sudoers.d/kubernetes-host
User_Alias KUBERNETES_HOST = %kubernetes-host
KUBERNETES_HOST ALL=(ALL)      NOPASSWD: ALL
EOF
chmod 400 /etc/sudoers.d/kubernetes-host
# disable login for kubernetes-host except through ssh keys
cat << 'EOF' >> /etc/ssh/sshd_config
Match User kubernetes-host
        PasswordAuthentication no
        AuthenticationMethods publickey

EOF
# restart sshd
systemctl restart sshd

# Now load and run the script to check for redundant repo.  This is a patch for a specific redundancy that appeared.  Should either isolate and treat the cause of the redundancy instead, or handle redundancies more generally.
mkdir /home/kubernetes-host/scripts
mkdir /home/kubernetes-host/pod-network-yaml
sudo chown -R kubernetes-host:kubernetes-host /home/kubernetes-host/pod-network-yaml/

# Get and run a script to fix a repo problem resulting from AWS' Amazon Linux 2 build process
cd /home/kubernetes-host/
sudo git clone https://github.com/KubeHostNet/ansible-kubernetes-kubeadm-playbooks.git && echo "git clone operation succeeded"

ls -al /home/kubernetes-host/
sudo chown -R kubernetes-host:kubernetes-host /home/kubernetes-host/ansible-kubernetes-kubeadm-playbooks
### Configure and run script to fix an error resulting from AWS' Amazon Linux 2 build process
### This will need to be delivered from a more isolated source later.  For now, pulling in unrelated ansible stuff with it.  
sudo mv /home/kubernetes-host/ansible-kubernetes-kubeadm-playbooks/scripts/removeRedundantRepo.sh /home/kubernetes-host/scripts/
sudo dos2unix /home/kubernetes-host/scripts/removeRedundantRepo.sh
chmod +x /home/kubernetes-host/scripts/removeRedundantRepo.sh
/home/kubernetes-host/scripts/removeRedundantRepo.sh

sudo mv /home/kubernetes-host/ansible-kubernetes-kubeadm-playbooks/pod-network-yaml/calico.yaml /home/kubernetes-host/pod-network-yaml
sudo mv /home/kubernetes-host/ansible-kubernetes-kubeadm-playbooks/pod-network-yaml/rbac-kdd.yaml /home/kubernetes-host/pod-network-yaml
#sudo chown -R kubernetes-host:kubernetes-host /home/kubernetes-host/ansible-kubernetes-kubeadm-playbooks/pod-network-yaml/
sudo chown -R kubernetes-host:kubernetes-host /home/kubernetes-host/pod-network-yaml/

# Get and configure firewalld and python-firewalld so that Ansible playbooks work as intended.
sudo yum install -y dbus-glib-devel  dbus-glib python-slip-dbus dbus-python firewalld
sudo systemctl enable firewalld
sudo systemctl start firewalld
USERDATA

}

# This will identify the most recent version of Amazon Linux 2
data "aws_ami" "amazon-linux-2" {  
  most_recent = true
  
  owners = ["amazon"]
 
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
  
  filter {
    name   = "architecture"
    values = ["x86_64*"]
  }

}  

############################################################################################################  
## The below is to create an extra EC2 image outside the autoscaling group to house K8s Control Plane.  
############################################################################################################  
    
resource "aws_instance" "k8s-master-host" {
  depends_on = ["aws_internet_gateway.kubernetes-host"]
  ami                         = "${data.aws_ami.amazon-linux-2.id}"
  associate_public_ip_address = true
  iam_instance_profile        = "${aws_iam_instance_profile.kubernetes-node.id}"
  instance_type               = "m4.large"
  key_name                    = "${var.name_of_ssh_key}"
  user_data_base64 = "${base64encode(local.k8s-host-userdata)}"
  source_dest_check           = false
  vpc_security_group_ids      = ["${aws_security_group.kubernetes-nodes.id}"]
  subnet_id                   = "${aws_subnet.kubernetes-host.*.id[count.index]}"
  #subnet_id                   = "${aws_subnet.kubernetes-control-plane.id}"

  tags = { Name = "k8smaster" }

}

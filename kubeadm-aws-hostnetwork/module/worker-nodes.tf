## Copyright 2020 Green River IT as described in LICENSE.txt distributed with this project on GitHub.  
## Start at https://github.com/KubeHostNet/  
  
resource "aws_launch_configuration" "k8s-worker-nodes" {
  depends_on = ["aws_internet_gateway.kubernetes-host"]
  associate_public_ip_address = true
  iam_instance_profile        = "${aws_iam_instance_profile.kubernetes-node.id}"
  image_id                    = "${data.aws_ami.amazon-linux-2.id}"
  instance_type               = "m4.large"
  name_prefix                 = "k8s-adm-launch-config"
  security_groups             = ["${aws_security_group.kubernetes-nodes.id}"]
  user_data_base64            = "${base64encode(local.k8s-host-userdata)}"
  key_name                    = "${var.name_of_ssh_key}"

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_autoscaling_group" "k8s-worker-nodes" {
  depends_on = ["aws_internet_gateway.kubernetes-host"]
  desired_capacity     = "${var.num_worker_nodes}"
  launch_configuration = "${aws_launch_configuration.k8s-worker-nodes.id}"
  max_size             = "${var.max_worker_nodes}"
  min_size             = "${var.min_worker_nodes}"
  name                 = "k8s-workers"
  vpc_zone_identifier  = ["${aws_subnet.kubernetes-host.*.id[count.index]}"]

  tag {
    key                 = "Name"
    value               = "k8sworker"
    propagate_at_launch = true
  }

}

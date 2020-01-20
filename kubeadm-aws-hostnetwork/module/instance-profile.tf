## Copyright 2020 Green River IT as described in LICENSE.txt distributed with this project on GitHub.  
## Start at https://github.com/KubeHostNet/  
  
########### NOTE THESE POLICIES ARE TOO BROAD AND WILL NEED TO BE NARROWED FOR PRODUCTION.
resource "aws_iam_role" "kubernetes-node" {
  name = "kubernetes-node-role"  
  
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy" "describe_instances" {
  name = "describe_instances"
  role = "${aws_iam_role.kubernetes-node.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*",
        "ec2:ModifyInstanceAttribute"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "kubernetes-node" {
  name = "kubernetes-node-profile"
  role = "${aws_iam_role.kubernetes-node.name}"
}

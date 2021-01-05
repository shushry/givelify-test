resource "aws_iam_role" "ec2-role" {
  name               = "ec2-role"
  assume_role_policy = <<EOF
{
"Version": "2012-10-17",
"Statement": {
"Effect": "Allow",
"Principal": {"Service": "ec2.amazonaws.com"},
"Action": "sts:AssumeRole"
}
}
EOF
}



resource "aws_iam_role_policy" "ec2-s3" {
  role = aws_iam_role.ec2-role.name
  name = "ec2-s3"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::givelify/*"
    }
  ]
}
EOF
}



resource "aws_iam_role_policy_attachment" "ec2-role-attach" {
  role       = aws_iam_role.ec2-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}



resource "aws_iam_instance_profile" "ec2-profile" {
  name = "ec2-profile"
  role = aws_iam_role.ec2-role.id
}



resource "aws_security_group" "webservers" {
  name        = "webservers"
  description = "Allow http and ssh traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "ingress http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  ingress {
    description = "ingress 22"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

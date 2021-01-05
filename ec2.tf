resource "aws_key_pair" "key" {
  key_name   = "givelify_ws_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCoakf/lHpJjQGkpUAhKhgfXiIjNREvGM26XVPFQEkLqf4Z47BcyeMBX8sKWHSDtj+r9OkzcvzxKOxyTAWgr1AiKMMRgFs3AjEELCkP1wugf5p1vvCwpRYMrVU3QnQtwUoBUtUpW/5oUqK3WAcrOvwvbj7yfZ30vZHilHdJh5kXRDCKTfJj8uxLyW+tlzyxQBTYDDhNTXfqDiXhKPHnhHe048flehtDfiraecq7k8YUjZAa6VahQMFdsTHMOOy/P84MPl0GPa6buesjxC2Dy4vzRnTUkdBl/5uglUG9Njcsj7svmfe0Vcpvz0BeZx/a3zgztAUTtFSwZBe0pIxQyuJH"
}




resource "aws_instance" "webserver" {
  count                  = var.webserver_count
  ami                    = data.aws_ami.ami.id
  instance_type          = "t3.micro"
  subnet_id              = element(module.vpc.private_subnets, count.index)
  key_name               = aws_key_pair.key.key_name
  user_data_base64       = base64encode(local.webserver_setup)
  vpc_security_group_ids = [aws_security_group.webservers.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2-profile.name

  root_block_device {
    volume_size = "20"
  }

  tags = {
    Name = "web-server-${count.index + 1}"
  }

  depends_on = [
    aws_iam_role.ec2-role
  ]
}

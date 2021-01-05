resource "aws_alb" "alb" {
  name               = "givelify"
  internal           = false
  load_balancer_type = "application"
  subnets            = module.vpc.public_subnets
}



resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_alb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.tg.arn
  }
}



resource "aws_alb_target_group" "tg" {
  name     = "givelify-tg"
  port     = "80"
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 10
    timeout             = 5
    interval            = 10
    path                = "/"
    port                = "80"
  }
}



resource "aws_lb_target_group_attachment" "webserver" {
  count            = length(aws_instance.webserver)
  target_group_arn = aws_alb_target_group.tg.arn
  target_id        = aws_instance.webserver[count.index].id
  port             = 80
}

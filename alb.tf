resource "aws_alb" "main" {
  security_groups = ["${var.alb_security_groups}"]
  subnets         = ["${var.public_subnet_ids}"]
  name            = "${var.project}-${var.environment}"
  internal        = "${var.alb_internal_bool}"

  tags {
    Name        = "${var.project}-${var.environment}"
    Project     = "${var.project}"
    Environment = "${var.environment}"
  }
}

resource "aws_alb_target_group" "main" {
  name = "${var.project}-${var.environment}-target-group"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    timeout             = "3"
    path                = "${var.health_check_path}"
    unhealthy_threshold = "2"
  }

  port     = "${var.port}"
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"

  tags {
    Name        = "${var.project}-${var.environment}-target-group"
    Project     = "${var.project}"
    Environment = "${var.environment}"
  }
  depends_on = [
    "aws_alb.main"
  ]
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = "${aws_alb.main.id}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.main.id}"
    type             = "forward"
  }
}

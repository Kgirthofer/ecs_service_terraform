resource "aws_cloudwatch_metric_alarm" "service_cpu_high" {
  alarm_name          = "${var.project}-${var.environment}-service-CPU-High"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "${var.cpu_up_evaluation_periods}"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "${var.cpu_up_time_period}"
  statistic           = "Average"
  threshold           = "${var.cpu_threshold_up}"

  dimensions {
    ClusterName = "${var.cluster_name}"
    ServiceName = "${aws_ecs_service.main.name}"
  }

  alarm_actions = ["${aws_appautoscaling_policy.cpu_up.arn}"]
}

resource "aws_cloudwatch_metric_alarm" "service_cpu_low" {
  alarm_name          = "${var.project}-${var.environment}-service-CPU-Low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "${var.cpu_down_evaluation_periods}"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "${var.cpu_down_time_period}"
  statistic           = "Average"
  threshold           = "${var.cpu_threshold_down}"

  dimensions {
    ClusterName = "${var.cluster_name}"
    ServiceName = "${aws_ecs_service.main.name}"
  }

  alarm_actions = ["${aws_appautoscaling_policy.cpu_down.arn}"]
}

resource "aws_appautoscaling_target" "scale_target" {
  service_namespace = "ecs"
  resource_id = "service/${var.cluster_name}/${aws_ecs_service.main.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  role_arn = "${aws_iam_role.ecs_autoscale_role.arn}"
  min_capacity = "${var.service_asg_min_cap}"
  max_capacity = "${var.service_asg_max_cap}"

  depends_on = [
    "aws_ecs_service.main"
  ]

}

resource "aws_appautoscaling_policy" "cpu_up" {
  name                      = "${var.project}-${var.environment}-scale-up"
  service_namespace         = "ecs"
  resource_id               = "service/${var.cluster_name}/${aws_ecs_service.main.name}"
  scalable_dimension        = "ecs:service:DesiredCount"
  adjustment_type           = "ChangeInCapacity"
  cooldown                  = "${var.cpu_up_cooldown}"
  metric_aggregation_type   = "Average"

  step_adjustment {
    metric_interval_lower_bound = 0
    scaling_adjustment = 1
  }
  depends_on = [
    "aws_appautoscaling_target.scale_target"
  ]
}

resource "aws_appautoscaling_policy" "cpu_down" {
  name                      = "${var.project}-${var.environment}-scale-down"
  service_namespace         = "ecs"
  resource_id               = "service/${var.cluster_name}/${aws_ecs_service.main.name}"
  scalable_dimension        = "ecs:service:DesiredCount"
  adjustment_type           = "ChangeInCapacity"
  cooldown                  = "${var.cpu_down_cooldown}" 
  metric_aggregation_type   = "Average"

  step_adjustment {
    metric_interval_lower_bound = 0
    scaling_adjustment = -1
  }
  depends_on = [
    "aws_appautoscaling_target.scale_target"
  ]
}

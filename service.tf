resource "aws_ecs_service" "main" {
  name            = "${var.project}"
  cluster         = "${var.cluster_name}"
  task_definition = "${var.task_definition}"
  desired_count   = "${var.service_desired_count}"
  iam_role        = "${var.ecs_service_role_name}"

  placement_strategy {
    type  = "spread"
    field = "attribute:ecs.availability-zone"
  }
  
  placement_strategy {
    type  = "binpack"
    field = "cpu"
  }

  load_balancer {
    target_group_arn = "${aws_alb_target_group.main.arn}"
    container_name = "${var.alb_container_name}"
    container_port = "${var.alb_container_port}" 
  }
 
  lifecycle {
    ignore_changes = ["desired_count"]
  }
}

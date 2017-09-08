output "name" {
  value = "${aws_ecs_service.main.name}"
}

output "lb_dns_name" {
  value = "${aws_alb.main.dns_name}"
}

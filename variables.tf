## Unknown vars
variable "alb_container_name" {}
variable "alb_container_port" {}
variable "project" {}
variable "cluster_name" {}
variable "custom_url" {}
variable "domain" {}
variable "public_subnet_ids" {
  type = "list"
}
variable "alb_security_groups" {
  type = "list"
}
variable "environment" {}
variable "health_check_path" {}
variable "task_definition" {}

## Defaulted vars
variable "alb_internal_bool" {
  default = "true"
}
variable "domain_zone_id" {
}
variable "service_desired_count" {
  default = 1
}
variable "region" {
  default = "us-east-1"
}
variable "cpu_threshold_up" {
  default = 60
}
variable "cpu_up_evaluation_periods" {
  default = 3
}
variable "cpu_up_time_period" {
  default = 60
}
variable "cpu_up_cooldown" {
  default = 240
}
variable "cpu_threshold_down" {
  default = 20
}
variable "cpu_down_evaluation_periods" {
  default = 1
}
variable "cpu_down_time_period" {
  default = 300
}
variable "cpu_down_cooldown" {
  default = 300
}
variable "service_asg_min_cap" {
  default = 1
}
variable "service_asg_max_cap" {
  default = 3
}
variable "port" {
  default = 80
}
variable "vpc_id" {
}
variable "ecs_service_role_name" {
}

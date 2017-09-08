# ecs-service-tf

A Terraform module to create an Amazon Web Services (AWS) ECS Service on top of an ECS cluster.

## Usage

```hcl
module "container_service" {
  source = "git::ssh://git@github.com/kgirthofer/ecs-service-tf?ref=0.1.0"

  cluster_name = "test-cluster"
  
  alb_container_name = "nginx-frontend"
  alb_security_groups = [...]
  health_check_path = "/health_check"
  alb_container_port = 80
  public_subnet_ids = [...]
  alb_internal_bool = true

  custom_url = "whatever"

  service_desired_count = 3
  service_asg_min_cap = 3
  service_asg_max_cap = 12  

  project     = "docker-test-app"
  task_definition = "docker-test-app:1"
  environment = "stg"
}
```

## Variables

- `alb_container_name` - Name of the container the ALB should route traffic too (Default: `unknown`)
- `alb_container_port` - Port the ALB will route traffic to on the container (Default: `unknown`)
- `alb_internal_bool` - Boolean flag to set the ALB to internal or public (Default: `true`)
- `custom_url` - Prefix for the URL - environment will append. I.e. test will be test-env.whatever.com (Default `unknown`)
- `domain_zone_id` - Route53 Hosted Zone ID (Default: `unknown`)
- `service_desired_count` - Number of services desired to run - Ignored after initial run (Default: `1`)
- `region` - Where it all happens (Default: `us-east-1`)
- `cpu_threshold_up` - Percentage of CPU utilization to trigger scaling up action (Default: `60`)
- `cpu_up_evaluation_periods` - How many periods of alarm until scaling up is triggered (Default: `3`)
- `cpu_up_time_period` - How much time is one period (Default: `60`)
- `cpu_up_cooldown` - How much time inbetween scaling actions in seconds (Default: `240`)
- `cpu_threshold_down` - Percentage of CPU utilization to trigger scaling down action (Default: `20`)
- `cpu_down_evaluation_periods` - How many periods of alarm until scalind down is triggered (Default `1`)
- `cpu_down_time_period` - How much time is one period (Default: `300`)
- `cpu_down_cooldown` - How much time inbetween scalind actions in seconds (Default: `300`)
- `service_asg_min_cap` - Minimum number of services running (Default: `1`)
- `service_asg_max_cap` - Maximum number of services running (Default: `3`)
- `project` - Name of the project or application (Default: `unknown`)
- `cluster_name` - Name of the cluster to launch into (Default: `unknown`)
- `task_definition` - Full task definition - taskdef:refNum (Default: `unknown`)
- `public_subnet_ids` - List of subnet ID's to launch ALB into - format ["subnet-xxxxxxxx", "subnet-xxxxxxxx"] (Default: `unknown`)
- `alb_security_groups` - List of security groups to attach to the ALB - format ["sg-xxxxxxxx", "sg-xxxxxxxx"] (Default: `unknown`)
- `environment` - Service environment (Default: `unknown`)
- `health_check_path` - Path for the ALB to register target health (Default: `unknown`)
- `port` - ALB exposed port (Default: `80`)
- `vpc_id` - VPC to launch into (Default: `unknown`)
- `ecs_service_role_name` - Service role needed to assuming permissions to adjust ECS cluster, ALB, and others (Default: `unknown`)

## Outputs

- `name` - The container service Name 
- `lb_dns_name` - The raw DNS name for the ELB (A Record)

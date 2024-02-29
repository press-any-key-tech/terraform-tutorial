

################################################################################
# Task definition
################################################################################

# ECS task execution role data
data "aws_iam_policy_document" "ecs_execution_role" {
  version = "2012-10-17"
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# ECS task execution role
resource "aws_iam_role" "ecs_execution_role" {
  name               = format("%s-%s-ecs-execution-role", var.cluster_name, var.service_name)
  assume_role_policy = data.aws_iam_policy_document.ecs_execution_role.json

  path                 = "/"
  max_session_duration = 3600

  tags = merge(
    { "Name" = format("%s-%s-ecs-execution-role", var.cluster_name, var.service_name) },
    var.tags,
  )
}

# ECS task execution role policy attachment
resource "aws_iam_role_policy_attachment" "ecs_execution_role" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "ecs_task_role" {
  path                 = "/"
  name                 = format("%s-%s-ecs-task-role", var.cluster_name, var.service_name)
  assume_role_policy   = data.aws_iam_policy_document.ecs_execution_role.json
  max_session_duration = 3600
  tags = merge(
    { "Name" = format("%s-%s-ecs-task-role", var.cluster_name, var.service_name) },
    var.tags,
  )
}

# Allow to access the log stream
resource "aws_iam_role_policy" "access_log_stream_policy" {
  # TODO: Change policy to module folder?
  policy = templatefile("${path.module}/../../policies/log-stream-policy.json", { logsGroup = var.logs_group_arn })
  role   = aws_iam_role.ecs_execution_role.name
  name   = format("%s-access_log_stream_policy", var.cluster_name)
}


resource "aws_ecs_task_definition" "taskdef" {
  count = length(var.tasks)

  container_definitions    = var.tasks[count.index].container_definition
  cpu                      = var.tasks[count.index].cpu
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  family                   = var.tasks[count.index].family
  memory                   = var.tasks[count.index].memory
  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"]
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  tags = merge(
    { "Name" = format("%s_%s_%s", var.environment, var.tasks[count.index].name, var.tasks[count.index].family) },
    var.tags,
  )
}

################################################################################
# Service discovery configuration
################################################################################

# TODO: make configurable
resource "aws_service_discovery_service" "service" {
  count = length(var.tasks)

  # TODO: do not use the same name for the task and the namespace
  name = var.tasks[count.index].name

  dns_config {
    namespace_id = var.namespace_id

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}



################################################################################
# Load Balancer configuration
################################################################################
# TODO: allow to use an ALB or a NLB

resource "aws_lb_target_group" "ElasticLoadBalancingV2TargetGroup" {
  count = length(var.tasks)

  # TODO: make configurable
  dynamic "health_check" {
    for_each = var.tasks[count.index].health_check_path != null ? [1] : []
    content {
      interval            = 60
      path                = var.tasks[count.index].health_check_path
      port                = "traffic-port"
      protocol            = var.tasks[count.index].health_check_protocol
      timeout             = 5
      unhealthy_threshold = 2
      healthy_threshold   = 3
      matcher             = var.tasks[count.index].health_check_status_code
    }
  }

  vpc_id = var.vpc_id

  port        = var.tasks[count.index].port
  protocol    = "HTTP"
  target_type = "ip"
  name        = format("%s-alb-tg-%s", var.tasks[count.index].name, var.tasks[count.index].port)

  tags = merge(
    { "Name" = format("%s-alb-tg-%s", var.tasks[count.index].name, var.tasks[count.index].port) },
    var.tags,
  )
}


resource "aws_lb_listener_rule" "example" {
  count = length(var.tasks)

  listener_arn = var.lb_listener_arn
  priority     = var.listener_rule_priority_base + count.index

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ElasticLoadBalancingV2TargetGroup[count.index].arn
  }

  condition {
    path_pattern {
      values = [var.tasks[count.index].path]
    }
  }

  # condition {
  #   host_header {
  #     values = [var.tasks[count.index].subdomain]
  #   }
  # }

}


################################################################################
# Service configuration
################################################################################

# resource "aws_iam_role" "AWSServiceRoleForECS" {
#   assume_role_policy = <<POLICY
# {
#   "Statement": [
#     {
#       "Action": "sts:AssumeRole",
#       "Effect": "Allow",
#       "Principal": {
#         "Service": "ecs.amazonaws.com"
#       }
#     }
#   ],
#   "Version": "2012-10-17"
# }
# POLICY

#   description          = "Role to enable Amazon ECS to manage your cluster."
#   managed_policy_arns  = ["arn:aws:iam::aws:policy/aws-service-role/AmazonECSServiceRolePolicy"]
#   max_session_duration = "3600"
#   name                 = "AWSServiceRoleForECS"
#   path                 = "/aws-service-role/ecs.amazonaws.com/"

#   tags = merge(
#     { "Name" = "AWSServiceRoleForECS" },
#     var.tags,
#   )

# }

# resource "aws_iam_role_policy_attachment" "AWSServiceRoleForECS_AmazonECSServiceRolePolicy" {
#   policy_arn = "arn:aws:iam::aws:policy/aws-service-role/AmazonECSServiceRolePolicy"
#   role       = aws_iam_role.AWSServiceRoleForECS.name
# }



resource "aws_security_group" "ServiceSecurityGroup" {
  description = "Service/SecurityGroup"
  name        = format("%s-%s-service-sg", var.cluster_name, var.service_name)
  tags = merge(
    { "Name" = format("%s-%s-service-sg", var.cluster_name, var.service_name) },
    var.tags,
  )
  vpc_id = var.vpc_id

  dynamic "ingress" {
    for_each = var.tasks
    content {
      from_port = ingress.value.port
      to_port   = ingress.value.port
      protocol  = "tcp"
      cidr_blocks = [
        "0.0.0.0/0"
      ]
      # TODO: only allow from the load balancer
      # security_groups = [
      #   "${aws_security_group.ServiceLBSecurityGroup.id}"
      # ]
      description = format("Allow from anyone on port %d", ingress.value.port)
    }
  }

  egress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    description = "Allow all outbound traffic by default"
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }
}



resource "aws_ecs_service" "ecs-service" {
  count = length(var.tasks)

  name          = format("%s-%s-service", var.environment, var.tasks[count.index].name)
  cluster       = var.cluster_name
  desired_count = var.tasks[count.index].min_capacity
  launch_type   = "EC2"
  # platform_version                   = "LATEST"
  task_definition                    = aws_ecs_task_definition.taskdef[count.index].arn
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 50

  service_registries {
    registry_arn   = aws_service_discovery_service.service[count.index].arn
    container_name = var.tasks[count.index].container_name
  }


  network_configuration {
    # assign_public_ip not allowed for launch type EC2
    assign_public_ip = false

    security_groups = [
      "${aws_security_group.ServiceSecurityGroup.id}"
    ]
    subnets = var.vpc_subnets_ids
  }
  health_check_grace_period_seconds = 30
  scheduling_strategy               = "REPLICA"
  load_balancer {
    target_group_arn = aws_lb_target_group.ElasticLoadBalancingV2TargetGroup[count.index].arn
    container_name   = var.tasks[count.index].container_name
    container_port   = var.tasks[count.index].port
  }

  # alarms {
  #   enable   = "false"
  #   rollback = "false"
  # }
  # deployment_circuit_breaker {
  #   enable   = "false"
  #   rollback = "false"
  # }

  # deployment_controller {
  #   type = "ECS"
  # }


  tags = merge(
    { "Name" = format("%s-%s-service", var.environment, var.tasks[count.index].name) },
    var.tags,
  )

}


# # ECS Autoscaling
# resource "aws_appautoscaling_target" "ecs_target" {
#   count = length(var.tasks)

#   max_capacity = var.tasks[count.index].max_capacity
#   min_capacity = var.tasks[count.index].min_capacity
#   resource_id  = "service/${var.cluster_name}/${aws_ecs_service.ecs-service[count.index].name}"
#   # resource_id        = aws_ecs_service.ecs-service.id
#   scalable_dimension = "ecs:service:DesiredCount"
#   service_namespace  = "ecs"
# }

# resource "aws_appautoscaling_policy" "ecs_policy" {
#   count = length(var.tasks)

#   name               = format("cpu-utilization_%s", count.index)
#   policy_type        = "TargetTrackingScaling"
#   resource_id        = aws_appautoscaling_target.ecs_target[count.index].resource_id
#   scalable_dimension = aws_appautoscaling_target.ecs_target[count.index].scalable_dimension
#   service_namespace  = aws_appautoscaling_target.ecs_target[count.index].service_namespace

#   target_tracking_scaling_policy_configuration {
#     predefined_metric_specification {
#       predefined_metric_type = "ECSServiceAverageCPUUtilization"
#     }

#     target_value = 50.0
#   }
# }


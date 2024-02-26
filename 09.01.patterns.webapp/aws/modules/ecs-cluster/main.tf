################################################################################
# FARGATE cluster configuration
################################################################################

# resource "aws_ecs_cluster" "cluster" {
#   name = var.cluster_name

#   # TODO: make configurable
#   setting {
#     name  = "containerInsights"
#     value = "disabled"
#   }

#   tags = merge(
#     { "Name" = var.cluster_name },
#     var.tags,
#   )

# }

# resource "aws_ecs_cluster_capacity_providers" "cluster_provider" {
#   cluster_name = aws_ecs_cluster.cluster.name

#   capacity_providers = ["FARGATE"]

#   default_capacity_provider_strategy {
#     base              = 1
#     weight            = 100
#     capacity_provider = "FARGATE"
#   }


#   depends_on = [aws_ecs_cluster.cluster]

# }


################################################################################
# EC2 cluster configuration
################################################################################


# Ignore terraform deprecation warnings about `aws_ecs_cluster_capacity_provider` and `aws_ecs_cluster_capacity_provider` resources
# The only way to create an EC2 capacity provider is to use the `aws_ecs_capacity_provider` resource


resource "aws_iam_role" "ecs-instance-role" {
  assume_role_policy   = file("${path.module}/policies/instance-role-policy.json")
  managed_policy_arns  = var.instance_role_managed_policies
  max_session_duration = var.instance_role_max_session_duration
  name                 = format("%s-ecs-instance-role", var.cluster_name)
  path                 = "/"
}

resource "aws_iam_instance_profile" "ecs-instance-profile" {
  name = aws_iam_role.ecs-instance-role.name
  role = aws_iam_role.ecs-instance-role.name
}


resource "aws_security_group" "ec2-ecs-cluster-sg" {
  description = "EC2 ECS Cluster SG"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }

  # TODO: make configurable
  ingress {
    cidr_blocks      = ["0.0.0.0/0"]
    from_port        = "22"
    ipv6_cidr_blocks = ["::/0"]
    protocol         = "tcp"
    self             = "false"
    to_port          = "22"
  }

  ingress {
    cidr_blocks      = ["0.0.0.0/0"]
    from_port        = "80"
    ipv6_cidr_blocks = ["::/0"]
    protocol         = "tcp"
    self             = "false"
    to_port          = "80"
  }

  name   = format("%s-cluster-sg", var.cluster_name)
  vpc_id = var.vpc_id
}




resource "aws_launch_template" "ecs-launch-template" {
  default_version         = try(var.lt_ec2_default_version, null)
  disable_api_stop        = var.lt_ec2_disable_api_stop
  disable_api_termination = var.lt_ec2_disable_api_termination

  iam_instance_profile {
    arn = aws_iam_instance_profile.ecs-instance-profile.arn
    # name = aws_iam_instance_profile.ecs-instance-profile.name
  }

  # TODO: allow to define block devices
  # block_device_mappings {
  #   device_name = "/dev/sda1"

  #   ebs {
  #     volume_size = 100
  #     volume_type = "gp2"
  #   }
  # }

  name          = format("%s-lt", var.cluster_name)
  image_id      = var.lt_ec2_image_id
  instance_type = var.lt_ec2_instance_type
  # TODO: if not specified, set null
  key_name = var.lt_ec2_key_name

  user_data = try(base64encode(var.lt_ec2_user_data), base64encode(templatefile("${path.module}/ec2_default_user_data.sh", { ECS_CLUSTER_NAME = var.cluster_name })))

  vpc_security_group_ids = [aws_security_group.ec2-ecs-cluster-sg.id]
}



resource "aws_autoscaling_group" "ecs-autoscaling-group" {
  desired_capacity = var.desired_capacity
  max_size         = var.max_size
  min_size         = var.min_size
  name             = format("%s-ecs-autoscaling-group", var.cluster_name)

  # availability_zones        = ["eu-west-1c", "eu-west-1b", "eu-west-1a"]
  # capacity_rebalance        = "false"
  # default_cooldown          = "300"
  # default_instance_warmup   = "0"
  # force_delete              = "false"
  # health_check_grace_period = "0"
  # health_check_type         = "EC2"

  launch_template {
    id      = aws_launch_template.ecs-launch-template.id
    version = aws_launch_template.ecs-launch-template.latest_version
  }

  # max_instance_lifetime   = "0"
  # metrics_granularity     = "1Minute"

  # Needed by capacity provider
  protect_from_scale_in = true

  # TODO: make configurable?
  service_linked_role_arn = "arn:aws:iam::550891793775:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"

  tag {
    key                 = "Name"
    propagate_at_launch = "true"
    value               = format("ECS Instance - %s", var.cluster_name)
  }

  vpc_zone_identifier = var.vpc_subnets_ids
  # wait_for_capacity_timeout = "10m"
}


resource "aws_ecs_capacity_provider" "ec2" {
  name = format("%s-ec2-cp", var.cluster_name)

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.ecs-autoscaling-group.arn
    managed_termination_protection = "ENABLED"

    # TODO: make configurable
    managed_scaling {
      status                    = "ENABLED"
      target_capacity           = 100
      minimum_scaling_step_size = 1
      maximum_scaling_step_size = 1
    }
  }
}

resource "aws_ecs_cluster" "cluster" {
  name = var.cluster_name
}

resource "aws_ecs_cluster_capacity_providers" "cluster_provider" {
  cluster_name = aws_ecs_cluster.cluster.name

  capacity_providers = [aws_ecs_capacity_provider.ec2.name]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = aws_ecs_capacity_provider.ec2.name
  }

  depends_on = [aws_ecs_cluster.cluster]

}


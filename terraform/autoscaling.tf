########################################
# Auto Scaling Group
########################################

resource "aws_autoscaling_group" "asg" {

  name = "three-tier-asg"

  desired_capacity = 2

  min_size = 2

  max_size = 4

  vpc_zone_identifier = [

    aws_subnet.private_app_subnet_1.id,

    aws_subnet.private_app_subnet_2.id
  ]

  target_group_arns = [
    aws_lb_target_group.tg.arn
  ]

  launch_template {

    id = aws_launch_template.app.id

    version = "$Latest"
  }

  health_check_type = "ELB"

  health_check_grace_period = 300

  tag {

    key = "Name"

    value = "Application-Server"

    propagate_at_launch = true
  }
}

########################################
# Target Tracking Scaling Policy
########################################

resource "aws_autoscaling_policy" "cpu" {

  name = "cpu-policy"

  autoscaling_group_name = aws_autoscaling_group.asg.name

  policy_type = "TargetTrackingScaling"

  target_tracking_configuration {

    predefined_metric_specification {

      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 70
  }
}

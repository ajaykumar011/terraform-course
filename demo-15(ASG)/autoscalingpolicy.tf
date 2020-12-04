# scale up alarm

resource "aws_autoscaling_policy" "web-cpu-policy" {
  name                   = "web-cpu-policy"
  autoscaling_group_name = aws_autoscaling_group.web-autoscaling.name  #connection to resourcetype.resourcename.name_attribute
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "1"
  # cooldown means cool down (do nothing) between  two autoscaling activity. Auto Scaling group doesn't launch or terminate additional instances 
  cooldown               = "300"  
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "web-cpu-alarm" {
  alarm_name          = "web-cpu-alarm"
  alarm_description   = "web-cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"  # Evaluate 2 times then alarm triggers
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"  #30% percentage average cpu for period of  120 seconds
  statistic           = "Average"
  threshold           = "30"  #30% percentage average cpu for period of 120 seconds

  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.web-autoscaling.name
  }

  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.web-cpu-policy.arn]  #connects to action resourcetype.resourname.arn_attribute
}

# scale down alarm
resource "aws_autoscaling_policy" "web-cpu-policy-scaledown" {
  name                   = "web-cpu-policy-scaledown"
  autoscaling_group_name = aws_autoscaling_group.web-autoscaling.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1"  # '-' defines down
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "web-cpu-alarm-scaledown" {
  alarm_name          = "web-cpu-alarm-scaledown"
  alarm_description   = "web-cpu-alarm-scaledown"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "5"

  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.web-autoscaling.name
  }

  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.web-cpu-policy-scaledown.arn] #connects to action resourcetype.resourname.arn_attribute
}


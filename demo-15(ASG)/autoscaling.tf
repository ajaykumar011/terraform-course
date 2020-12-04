#Launch configuration named as web-launchconfig
resource "aws_launch_configuration" "web-launchconfig" {
  name_prefix     = "web-launchconfig"
  image_id        = var.AMIS[var.AWS_REGION]
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.mykeypair.key_name  # This resource is defined in key.tf format: resourcetype.resourcename.attributes
  security_groups = [aws_security_group.allow-ssh.id]  # This is defined in resouregroup.tf file format: resourcetype.resourcename.id
}

#AutoScaling group (ASG)
resource "aws_autoscaling_group" "web-autoscaling" {
  name                      = "web-autoscaling"
  vpc_zone_identifier       = [aws_subnet.main-public-1.id, aws_subnet.main-public-2.id]
  launch_configuration      = aws_launch_configuration.web-launchconfig.name  #resourcetype.resourcename.attribute
  min_size                  = 1
  max_size                  = 2
  health_check_grace_period = 300  #How long (grace time) Auto Scaling should wait until it starts using the ELB health check 
  health_check_type         = "EC2"
  force_delete              = true

  tag {
    key                 = "Name"
    value               = "ec2 instance"
    propagate_at_launch = true
  }
}


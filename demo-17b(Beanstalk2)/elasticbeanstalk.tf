resource "aws_elastic_beanstalk_application" "app" {
  name        = "app"
  description = "app"
}

resource "aws_elastic_beanstalk_environment" "app-prod" {
  name                = "app-prod"
  application         = aws_elastic_beanstalk_application.app.name
  #solution_stack_name = "64bit Amazon Linux 2018.03 v2.9.6 running PHP 7.3"
  # to get the solution stack. we need to 'aws configure'  install eb tools..
  # pip install awsebcli --upgrade –user (to install / upgrade)
  # pip uninstall awsebcli (to uninstall)

  #I created a elastic beanstalk application manually (AWS console). And then used AWS CLI to get the environment information -
  #aws elasticbeanstalk describe-environments --application-name php-demo --region ap-south-1

  solution_stack_name = "64bit Amazon Linux 2 v5.2.0 running Node.js 12"

  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = aws_vpc.main.id  #resourcetype.resourcename(main).attributeid
  }

  #Choose a subnet in each AZ for the instances that run your application. To avoid exposing your instances to the Internet, 
  #run your instances in private subnets and load balancer in public subnets. 
  #To run your load balancer and instances in the same public subnets, assign public IP addresses to the instances.
  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = "${aws_subnet.main-public-1.id},${aws_subnet.main-public-2.id}"
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "AssociatePublicIpAddress"
    value     = "false"
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.app-ec2-role.name
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SecurityGroups"
    value     = aws_security_group.app-prod.id
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "EC2KeyName"
    value     = aws_key_pair.mykeypair.id
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "t2.micro"
  }
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "ServiceRole"
    value     = aws_iam_role.elasticbeanstalk-service-role.name
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBScheme"
    value     = "public"
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBSubnets"
    value     = "${aws_subnet.main-public-1.id},${aws_subnet.main-public-2.id}"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name = "AssociatePublicIpAddress"
    value = "true"
  }
  setting {
    namespace = "aws:elb:loadbalancer"
    name      = "CrossZone"
    value     = "true"
  }
  setting {
    namespace = "aws:elasticbeanstalk:command"
    name      = "BatchSize"
    value     = "30"
  }
  setting {
    namespace = "aws:elasticbeanstalk:command"
    name      = "BatchSizeType"
    value     = "Percentage"
  }
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "Availability Zones"
    value     = "Any 2"
  }
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = "1"
  }
  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name      = "RollingUpdateType"
    value     = "Health"
  }
  // setting {
  //   namespace = "aws:elasticbeanstalk:application:environment"
  //   name      = "RDS_USERNAME"
  //   value     = aws_db_instance.mariadb.username
  // }
  // setting {
  //   namespace = "aws:elasticbeanstalk:application:environment"
  //   name      = "RDS_PASSWORD"
  //   value     = aws_db_instance.mariadb.password
  // }
  // setting {
  //   namespace = "aws:elasticbeanstalk:application:environment"
  //   name      = "RDS_DATABASE"
  //   value     = aws_db_instance.mariadb.name
  // }
  // setting {
  //   namespace = "aws:elasticbeanstalk:application:environment"
  //   name      = "RDS_HOSTNAME"
  //   value     = aws_db_instance.mariadb.endpoint
  // }
}


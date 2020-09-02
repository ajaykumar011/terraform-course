terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  access_key = var.AWS_ACCESS_KEY
  secret_key = var.AWS_SECRET_KEY
  region     = "ap-south-1"
}

#creating security group
resource "aws_security_group" "web-ssh-http" {
  name        = "web-ssh-http"
  description = "allow ssh and http traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

#creating aws instance of Amazon Linux 2. 
resource "aws_instance" "web" {
  ami               = "ami-0ebc1ac48dfd14136"
  instance_type     = "t2.micro"
  availability_zone = "ap-south-1a"
  security_groups   = ["${aws_security_group.web-ssh-http.name}"]
  key_name = "aws-devops"
  user_data = <<-EOF
                #!/bin/bash
                yum update -y
                amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
                yum install -y httpd mariadb-server git
                systemctl start httpd
                systemctl enable httpd
                usermod -a -G apache ec2-user
                git clone https://github.com/ajaykumar011/cloudformation_files.git /var/www/html/
                chown -R ec2-user:apache /var/www
                chmod 2775 /var/www
                find /var/www -type d -exec chmod 2775 {} \;
                find /var/www -type f -exec chmod 0664 {} \;
                echo "<?php phpinfo(); ?>" > /var/www/html/phpinfo.php
  EOF

  ebs_block_device {
    device_name           = "/dev/xvda"
    volume_size           = 15
    volume_type           = "gp2"
    delete_on_termination = true
    encrypted             = false
    #snapshot_id           = "snap-084cb269d55295d27"  
  }

  tags = {
        Name = "webserver"
  }

}

#creating and attaching ebs volume , size in 20 GB

resource "aws_ebs_volume" "data-vol" {
 availability_zone = "ap-south-1a"
 size = 20
 type = "gp2"
 tags = {
        Name = "data-volume"
    }
}
# Attachment of EBS
resource "aws_volume_attachment" "data-vol-attachment" {
 device_name = "/dev/xvdc"
 volume_id = aws_ebs_volume.data-vol.id
 instance_id = aws_instance.web.id
}

#creating an EIP

resource "aws_eip" "web-eip" {
  instance = aws_instance.web.id
  vpc      = true
  tags = {
     Name = "Websever EIP"
  }
}
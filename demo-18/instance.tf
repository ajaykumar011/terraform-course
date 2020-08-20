data "aws_ami" "ubuntu" {
  most_recent = true

  #https://cloud-images.ubuntu.com/locator/ec2/ (to get the AMI ID)
  #aws ec2 describe-images --region ap-south-1 --image-ids ami-xxxxxxx  (to get the values of AMI)
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "example" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  # the VPC subnet
  #if the var.EN is equal to prod then choose ''vpc-prod' 's public subnet else 'vpc-dev' public subnet.
  subnet_id = var.ENV == "prod" ? module.vpc-prod.public_subnets[0] : module.vpc-dev.public_subnets[0]

  # the security group 
  #choose the security group and assign values based on dev and prod
  vpc_security_group_ids = [var.ENV == "prod" ? aws_security_group.allow-ssh-prod.id : aws_security_group.allow-ssh-dev.id]

  # the public SSH key
  key_name = aws_key_pair.mykeypair.key_name
}

#terraform plan -var ENV=dev (for plan of dev)
#terraform apply -var ENV=dev (for dev environment)
#terraform apply -var ENV=prod  (for prod)
#terraform apply (for prod as prod is default)
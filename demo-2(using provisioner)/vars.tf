
#Access keys are defined here but not value not assigned
#values are assigned in terraform.tfvars file.
variable "AWS_ACCESS_KEY" {
}

variable "AWS_SECRET_KEY" {
}

variable "AWS_REGION" {
  default = "ap-south-1"
}

#Map variables for AMIS defined here
variable "AMIS" {
  type = map(string)
  default = {
    us-east-1 = "ami-107d3e61"
    ap-south-1 = "ami-02b5fbc2cb28b77b8"
    eu-west-1 = "ami-044f36cc778038e81"
  }
}

#Key variables and Instance username defined here
variable "PATH_TO_PRIVATE_KEY" {
  default = "mykey"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "mykey.pub"
}

variable "INSTANCE_USERNAME" {
  default = "ubuntu"
}


variable "AWS_ACCESS_KEY" {
}

variable "AWS_SECRET_KEY" {
}

variable "AWS_REGION" {
  default = "ap-south-1"
}

variable "AMIS" {
  type = map(string)
  default = {
    us-east-1 = "ami-107d3e61"
    ap-south-1 = "ami-02b5fbc2cb28b77b8"
    eu-west-1 = "ami-044f36cc778038e81"
  }
}

# http://cloud-images.ubuntu.com/locator/ec2/ (Ubuntu Image locator)

variable "AWS_ACCESS_KEY" {
}

variable "AWS_SECRET_KEY" {
}

variable "AWS_REGION" {
  default = "ap-south-1"
}

variable "PATH_TO_PRIVATE_KEY" {
  default = "mykey"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "mykey.pub"
}

variable "AMIS" {
  type = map(string)
  default = {
    us-east-1 = "ami-107d3e61"
    ap-south-1 = "ami-02b5fbc2cb28b77b8"
    eu-west-1 = "ami-044f36cc778038e81"
  }
}

# we would give the DB password at the time of terraform apply -var RDS_PASSWORD=mysupersecret
# or we can also define in terraform.tfvars

variable "RDS_PASSWORD" {  
}


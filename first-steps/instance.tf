provider "aws" {
  access_key = "Enter key"
  secret_key = "Enter key"
  region     = "ap-south-1"
}

resource "aws_instance" "example" {
  ami           = "ami-02b5fbc2cb28b77b8"
  instance_type = "t2.micro"
}


terraform {
  backend "s3" {
    bucket = "terraform-state-121212j"
    key    = "terraform.tfstate"
    region = "ap-south-1"
  }
}

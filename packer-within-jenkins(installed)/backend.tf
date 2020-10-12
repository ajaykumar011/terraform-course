terraform {
  backend "s3" {
    bucket = "cloudzone99"
    key    = "terraform.tfstate"
    region = "ap-south-1"
  }
}

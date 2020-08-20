terraform{
    backend "s3"{
        bucket = "terraform-state-4545"
        key = "terraform/myproject"
        region = "ap-south-1"
    }
}
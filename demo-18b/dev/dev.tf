module "main-vpc" {
  source     = "../modules/vpc"
  ENV        = "dev"
  AWS_REGION = var.AWS_REGION
}

module "instances" {
  source         = "../modules/instances"
  ENV            = "dev"
  VPC_ID         = module.main-vpc.vpc_id
  PUBLIC_SUBNETS = module.main-vpc.public_subnets
  # instance is created in first subnet as in vpc there is list of [0] ex- subnet_id = element(var.PUBLIC_SUBNETS, 0)
}

# terraform init will be done inside the folders of both dev not from outside
# terraform plan and apply also same as above

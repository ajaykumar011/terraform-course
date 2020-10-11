  module "codedeploy" {
    source  = "github.com/skyscrapers/terraform-codedeploy//app"
    name    = "application"
    project = "example"
  }

  module "deployment_group" {
    source             = "github.com/skyscrapers/terraform-codedeploy//deployment-group"
    environment        = "production"
    app_name           = module.codedeploy.app_name
    service_role_arn   = module.iam.arn_role
    autoscaling_groups = ["autoscaling1", "autoscaling2"]
  }

  module "codedeploy_bucket" {
  source      = "github.com/skyscrapers/terraform-codedeploy//s3bucket?ref=478373f6f8d4a46b7a1ec96090707365e0ae3e42"
  name_prefix = "app"
}


//   module "slack-notification" {
//     source  = "github.com/skyscrapers/terraform-codedeploy//notify-slack"
//     slack_webhook_url = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
//     slack_channel = "#channel_name"
//     kms_key_arn = aws_kms_key.kms_key.arn
//   }
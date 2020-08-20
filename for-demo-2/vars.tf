variable "AWS_REGION" {
  type    = string
  default = "ap-south-1"
}
variable "project_tags" {
  type          = map(string)
  default       = {
    Component   = "Frontend"
    Environment = "Production"
  }
}


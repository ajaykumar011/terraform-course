variable "name_prefix" {
  type = string
  default = "ajay"
}

variable "name_suffix" {
  type = string
  default = "blog"
}

variable "environment" {
  type = string
}

variable "approval" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "aws_account" {
  type = string
}

variable "subscriptions" {
  description = "List of telephone numbers to subscribe to SNS."
  type        = list(string)
}
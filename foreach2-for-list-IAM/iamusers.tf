//Simple count example with iam user named neo1, neo2, neo3
resource "aws_iam_user" "example1" {
  count = 3
  name  = "neo.${count.index}"
}

//Another example

variable "user_names" {
  description = "Create IAM users with these names"
  type        = list(string)
  default     = ["neo", "trinity", "morpheus"]
}

resource "aws_iam_user" "example2" {
  count = length(var.user_names)
  name  = var.user_names[count.index]
}

output "neo_arn" {
  value       = aws_iam_user.example1[0].arn
  description = "The ARN for user Neo"
}

output "all_arns" {
  value       = aws_iam_user.example2[*].arn
  description = "The ARNs for all users"
}
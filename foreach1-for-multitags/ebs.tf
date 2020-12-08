
resource "aws_ebs_volume" "example" {
  availability_zone = "ap-south-1a"
  size              = 20
  tags = {for k, v in merge({ Name = "Myvolume" }, var.project_tags): k => lower(v)} 
  // Remember this.
}


// When a for expression is wrapped in square brackets ([ and ]) as shown above, the result is a list. 
// A for expression wrapped in braces ({ and }) produces a map in a similar way.
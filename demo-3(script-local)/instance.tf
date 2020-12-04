resource "aws_instance" "example" {
  ami           = var.AMIS[var.AWS_REGION]
  instance_type = "t2.micro"
  key_name      = "aws-devops"
  security_groups = [ "default" ]
  tags = {
    Name = "Web-Example"
  }

  provisioner "local-exec" {
    command = "echo ${aws_instance.example.private_ip} >> private_ips.txt"
  }
}

output "ip" {
  value = aws_instance.example.public_ip
  description = "The public IP address of the main server instance."
}
output "instance_ips" {
  value = ["${aws_instance.example.*.public_ip}"]
}

#To list all outputs and shows everything:
#$ terraform output
#$ terraform show

output "address" {
  value = "${aws_instance.example.public_dns}"
}

output "addresses" {
  value = ["${aws_instance.example.*.public_dns}"]
}
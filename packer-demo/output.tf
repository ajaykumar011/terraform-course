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
resource "aws_instance" "example" {
  ami           = var.AMIS[var.AWS_REGION]
  instance_type = "t2.micro"

  # the VPC subnet
  subnet_id = aws_subnet.main-public-1.id

  # the security group
  vpc_security_group_ids = [aws_security_group.allow-ssh-http.id]

  # the public SSH key
  key_name = aws_key_pair.mykeypair.key_name
  
  provisioner "file" {
    source      = "script.sh"
    destination = "/tmp/script.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/script.sh",
      "sudo sed -i -e 's/\r$//' /tmp/script.sh",  # Remove the spurious CR characters.
      "sudo /tmp/script.sh",
    ]
  }
  connection {
    host        = coalesce(self.public_ip, self.private_ip)
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.PATH_TO_PRIVATE_KEY)
  }
} #end of Instance Section

output "instance_ips" {
  value = ["${aws_instance.example.*.public_ip}"]
}

#To list all outputs and shows everything:
#$ terraform output
#$ terraform show

output "addresses" {
  value = ["${aws_instance.example.*.public_dns}"]
}

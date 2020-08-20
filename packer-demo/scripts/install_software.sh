#!/bin/bash
apt-get update
apt-get install -y nginx docker.io vim lvm2

#construction index.html file for EC2

sudo echo "<h2>STATIC EC2 Information</h2>" | sudo tee /var/www/html/index.nginx-debian.html
echo "<br>AMI ID: $(curl http://169.254.169.254/latest/meta-data/ami-id)" | sudo tee -a /var/www/html/index.nginx-debian.html
echo "<br>Instance ID: $(curl http://169.254.169.254/latest/meta-data/ami-id)" | sudo tee -a /var/www/html/index.nginx-debian.html
echo "<br>Local Hostname: $(curl http://169.254.169.254/latest/meta-data/local-hostname)" | sudo tee -a /var/www/html/index.nginx-debian.html
echo "<br>Public Hostname: $(curl http://169.254.169.254/latest/meta-data/public-hostname)" | sudo tee -a /var/www/html/index.nginx-debian.html
echo "<br>Local IP: $(curl http://169.254.169.254/latest/meta-data/local-ipv4)" | sudo tee -a /var/www/html/index.nginx-debian.html
echo "<br>Public IP: $(curl http://169.254.169.254/latest/meta-data/public-ipv4)" | sudo tee -a /var/www/html/index.nginx-debian.html
echo "<br>MAC ID: $(curl http://169.254.169.254/latest/meta-data/network/interfaces/macs/)" | sudo tee -a /var/www/html/index.nginx-debian.html
echo "<br>Availability Zone: $(curl http://169.254.169.254/latest/meta-data/placement/availability-zone)" | sudo tee -a /var/www/html/index.nginx-debian.html

echo "<br><h3>DYNAMIC EC2 Information</h3></br><br>" | sudo tee -a /var/www/html/index.nginx-debian.html
curl http://169.254.169.254/latest/dynamic/instance-identity/document | sudo tee -a /var/www/html/index.nginx-debian.html


# make sure nginx is started
service nginx restart
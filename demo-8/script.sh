#!/bin/bash

# sleep until instance is ready
until [[ -f /var/lib/cloud/instance/boot-finished ]]; do
  sleep 1
done

# install nginx
apt-get update
apt-get -y install nginx

# make sure nginx is started
service nginx start

#construction index.html file for EC2

sudo echo "<h2>STATIC EC2 Information</h2>" | sudo tee /var/www/html/index.nginx-debian.html
echo "<br><p>AMI ID: $(curl http://169.254.169.254/latest/meta-data/ami-id)</p>" | sudo tee -a /var/www/html/index.nginx-debian.html
echo "<br><p>Instance ID: $(curl http://169.254.169.254/latest/meta-data/ami-id)</p>" | sudo tee -a /var/www/html/index.nginx-debian.html
echo "<br><p>Local Hostname: $(curl http://169.254.169.254/latest/meta-data/local-hostname)</p>" | sudo tee -a /var/www/html/index.nginx-debian.html
echo "<br><p>Public Hostname: $(curl http://169.254.169.254/latest/meta-data/public-hostname)</p>" | sudo tee -a /var/www/html/index.nginx-debian.html
echo "<br><p>Local IP: $(curl http://169.254.169.254/latest/meta-data/local-ipv4)</p>" | sudo tee -a /var/www/html/index.nginx-debian.html
echo "<br><p>Public IP: $(curl http://169.254.169.254/latest/meta-data/public-ipv4)</p>" | sudo tee -a /var/www/html/index.nginx-debian.html
echo "<br><p>MAC ID: $(curl http://169.254.169.254/latest/meta-data/network/interfaces/macs/)</p>" | sudo tee -a /var/www/html/index.nginx-debian.html
echo "<br><p>Availability Zone: $(curl http://169.254.169.254/latest/meta-data/placement/availability-zone)</p>" | sudo tee -a /var/www/html/index.nginx-debian.html

echo "<br><h3>DYNAMIC EC2 Information</h3></br><br>" | sudo tee -a /var/www/html/index.nginx-debian.html
curl http://169.254.169.254/latest/dynamic/instance-identity/document | sudo tee -a /var/www/html/index.nginx-debian.html


# make sure nginx is started
service nginx restart
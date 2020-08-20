#!/bin/bash
#below 2 line are used to awk and cut to get the only 'AMI_ID' string which is later saved in amivar.tf
#download packer.exe and put this to executable location and set the path.
ARTIFACT=`packer build -machine-readable packer-example.json |awk -F, '$0 ~/artifact,0,id/ {print $6}'`
AMI_ID=`echo $ARTIFACT | cut -d ':' -f2`
echo 'variable "AMI_ID" { default = "'${AMI_ID}'" }' > amivar.tf
terraform init
terraform apply -auto-approve

#awk -F - indicates the field separater and {print $6} print the 6th column.
#cut -d uses the same thing with -d indicated delimeter (:) and prints the field num 2
#sudo -E- Indicates to the security policy that the user wishes to preserve their existing environment variables
locals {
  webserver_setup = <<EOF
#!/bin/bash

###
### PATCH TO LATEST
###
yum -y update


###
### INSTALL NGINX and other tools
###
amazon-linux-extras install nginx1
yum -y install curl unzip
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
chkconfig nginx on


###
### DEPLOY APP
###
aws s3 cp s3://givelify/givelify_index.html /usr/share/nginx/html/index.html


###
### REBOOT IN CASE PATCHING / KERNEL ETC
###
/sbin/reboot

EOF
}

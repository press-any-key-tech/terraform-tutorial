#!/bin/bash
sudo yum update -y
sudo yum -y install httpd -y
sudo service httpd start
sudo bash -c 'echo "Hello world from EC2 $(hostname -f)" > /var/www/html/index.html'

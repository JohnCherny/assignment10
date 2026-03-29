#!/bin/bash
yum update -y
yum install -y httpd
systemctl enable httpd
systemctl start httpd

echo "<h1>TechNova Web App</h1>" > /var/www/html/index.html

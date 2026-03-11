#!/bin/bash

# Run as root
sudo su 

## Downloading and installing Jenkins
## Completing the previous steps enables you to download and install Jenkins on AWS. To 
## download and install Jenkins:

## The following steps are written for Amazon Linux 2. If you’re using Amazon Linux 2023, it’s ## recommended to use dnf instead of yum. While the yum command is still available for 
## compatibility in this context, it is actually a symbolic link to dnf and may not support all of its ## features. For more details, please refer to the official AWS documentation.
## Ensure that your software packages are up to date on your instance by using the following ##command to perform a quick software update:

 yum update –y
## Add the Jenkins repo using the following command:
 dnf install wget -y
 wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/rpm-stable/jenkins.repo
## Import a key file from Jenkins-CI to enable installation from the package:

 rpm --import https://pkg.jenkins.io/rpm-stable/jenkins.io-2026.key
 yum upgrade -y

## Install Java:

 yum install java-21-amazon-corretto -y
## Install Jenkins:

 yum install jenkins -y
## Enable the Jenkins service to start at boot:

 systemctl enable jenkins
## Start Jenkins as a service:

 systemctl start jenkins
## You can check the status of the Jenkins service using the command:

echo "$(systemctl status jenkins)"

# Install Nginx for the health check endpoint
yum install -y nginx

# Create the health check HTML file
mkdir -p /var/www/healthcheck
echo "<html><body>Healthy</body></html>" > /var/www/healthcheck/index.html

# Configure Nginx to serve the health check page on port 8081
cat <<EOT > /etc/nginx/conf.d/healthcheck.conf
server {
    listen 8081;
    location / {
        root /var/www/healthcheck;
        index index.html;
    }
}
EOT

# Start and enable Nginx to serve the health check endpoint
systemctl enable nginx
systemctl start nginx

# increase the size of the patition to 4gb
df -h /tmp
mount | grep /tmp
sudo mount -o remount,size=4G /tmp
sudo systemctl restart jenkins


sudo cat /var/lib/jenkins/secrets/initialAdminPassword

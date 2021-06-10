#!/bin/bash

#author: rounak pashine
#os: amazon-linux-2
#description: this script install all the basic tools required to create an infrastructure automation pipeline

#update yum package manager
sudo yum update –y

#install git
sudo yum install git -y

#install jenkins
sudo yum remove java-1.7.0-openjdk -y
sudo yum install java-1.8.0 -y
sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import http://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo yum install jenkins -y
sudo systemctl start jenkins
sudo systemctl enable jenkins

#install terraform
sudo yum install yum-utils -y
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum install terraform -y 
terraform -install-autocomplete

#install packer
sudo yum install yum-utils -y
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum install packer -y
sudo rm -rf /sbin/packer

#install inspec
sudo curl https://omnitruck.chef.io/install.sh | sudo bash -s -- -P inspec

#install ansible
sudo amazon-linux-extras install ansible2 -y

#install docker
sudo yum install docker -y
sudo systemctl start docker
sudo systemctl enable docker
sudo chmod 777 /var/run/docker.sock

#install docker-compose
sudo curl -L https://github.com/docker/compose/releases/download/1.21.0/docker-compose-`uname -s`-`uname -m` | sudo tee /usr/local/bin/docker-compose > /dev/null
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

#run sonarqube container
mkdir /tmp/sonar/
wget https://raw.githubusercontent.com/shweta-github04/sonarqube/master/docker-compose.yml -P /tmp/sonar/
sudo docker-compose -f /tmp/sonar/docker-compose.yml up -d

#install sonar-scanner
sudo wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.5.0.2216-linux.zip -P /bin/
sudo unzip /bin/sonar-scanner-cli-4.5.0.2216-linux.zip -d /bin/
sudo rm -rf /bin/sonar-scanner-cli-4.5.0.2216-linux.zip
/bin/sonar-scanner-4.5.0.2216-linux/bin/sonar-scanner -h

#run jfrog-artifactory container
mkdir /tmp/jfrog/
wget https://raw.githubusercontent.com/shweta-github04/jfrog/master/docker-compose.yml -P /tmp/jfrog/
sudo docker-compose -f /tmp/jfrog/docker-compose.yml up -d
# Docker Setup for Centos via Package 
# https://docs.docker.com/install/linux/docker-ce/centos/#install-from-a-package

#Install Dependencies
echo y | sudo yum install /tmp/pigz-2.3.3-1.el7.centos.x86_64.rpm
echo y | sudo yum install /tmp/container-selinux-2.42-1.gitad8f0f7.el7.noarch.rpm

#Install Docker-CE
echo y | sudo yum install /tmp/docker-ce-18.03.0.ce-1.el7.centos.x86_64.rpm

#sudo systemctl enable docker
sudo systemctl start docker

#Download Docker Image
sudo docker run hello-world

#Instantiate Image in Container on Port 8081
docker run -d --restart=always -p 8081:8081 hello-world:latest
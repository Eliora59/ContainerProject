# ContainerProject

The goal of the project is to deploy some container faster to provide an environment to test some playbook or role with Ansible

## Get started

$ git clone https://github.com/Eliora59/ContainerProject.git

You need to being add in the docker group (Don't forget to restart your session)

$ sudo usermod -a -G docker theophile

## Build Dockerfile

$ cd ContainerProject/DockerFiles/CentOS

$ docker build -t="zeorus-centos" ContainerProject/DockerFiles/CentOS/.

## Install the script

$ sudo chmod +x ContainerProject/deploy.sh

$ sudo cp ContainerProject/deploy.sh /usr/bin/local

## Deploy your container

#### To have the help

$ deploy.sh

#### Create your docker to test your playbook and role
(Auto-destroy when session or computer is restarted)

$ deploy.sh --create

#### To have the infos of your docker

$ deploy.sh --infos

#### To remove your docker

$ deploy.sh --drop

#### To create an inventory Ansible with your docker

$ deploy.sh --ansible
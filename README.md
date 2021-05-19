# ContainerProject

## Get started

git clone https://github.com/Eliora59/ContainerProject.git

## Build Dockerfile

chmod +x ContainerProject/centos-deploy.sh

cd ContainerProject/DockerFiles/CentOS

docker build -t="zeorus-centos" ContainerProject/DockerFiles/CentOS/.

#### Deploy your container

### Create a docker to test your playbook

./centos-deploy.sh --create

### Delete your docker when you finish your playbook

./centos-deploy.sh --drop

### To have the help

./centos-deploy.sh
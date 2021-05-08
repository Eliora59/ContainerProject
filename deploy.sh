#!/bin/bash

help() {
echo "

Options :
		- --create : lancer des conteneurs

		- --drop : supprimer les conteneurs créer par le deploy.sh
	
		- --infos : caractéristiques des conteneurs (ip, nom, user...)

		- --start : redémarrage des conteneurs

		- --ansible : déploiement arborescence ansible

"
}

create() {
    docker run -tid --privileged --name $USER-centos -h $USER-centos zeorus-centos /usr/sbin/init
	docker exec -ti $USER-centos /bin/sh -c "useradd $USER"
	docker exec -ti $USER-centos /bin/sh -c "mkdir  ${HOME}/.ssh && chmod 700 ${HOME}/.ssh && chown $USER:$USER $HOME/.ssh"
	docker cp $HOME/.ssh/id_rsa.pub $USER-centos:$HOME/.ssh/authorized_keys
	docker exec -ti $USER-centos /bin/sh -c "chmod 600 ${HOME}/.ssh/authorized_keys && chown $USER:$USER $HOME/.ssh/authorized_keys"
	docker exec -ti $USER-centos /bin/sh -c "echo '$USER   ALL=(ALL) NOPASSWD: ALL'>>/etc/sudoers"
	docker exec -ti $USER-centos /bin/sh -c "systemctl start sshd"
	echo "Conteneur $USER-centos créé"
	infos
}

infos() {
	echo ""
	echo "Informations des conteneurs : "
	echo ""
	for conteneur in $(docker ps -a | grep $USER-centos | awk '{print $1}');do      
		docker inspect -f '   => {{.Name}} - {{.NetworkSettings.IPAddress }}' $conteneur
	done
	echo ""

}


if [ "$1" == "--create" ];then
	create
fi
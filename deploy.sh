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
    docker run -tid --rm --privileged --name $USER-$2 -h $USER-$2 zeorus-$2 /usr/sbin/init
	docker exec -ti $USER-$2 /bin/sh -c "useradd $USER"
	docker exec -ti $USER-$2 /bin/sh -c "mkdir  ${HOME}/.ssh && chmod 700 ${HOME}/.ssh && chown $USER:$USER $HOME/.ssh"
	docker cp $HOME/.ssh/id_rsa.pub $USER-$2:$HOME/.ssh/authorized_keys
	docker exec -ti $USER-$2 /bin/sh -c "chmod 600 ${HOME}/.ssh/authorized_keys && chown $USER:$USER $HOME/.ssh/authorized_keys"
	docker exec -ti $USER-$2 /bin/sh -c "echo '$USER   ALL=(ALL) NOPASSWD: ALL'>>/etc/sudoers"
	docker exec -ti $USER-$2 /bin/sh -c "systemctl start sshd"
	echo "Conteneur $USER-$2 créé"
	infos
}

infos() {
	echo ""
	echo "Informations des conteneurs : "
	echo ""
	for conteneur in $(docker ps -a | grep $USER-$2 | awk '{print $1}');do      
		docker inspect -f '   => {{.Name}} - {{.NetworkSettings.IPAddress }}' $conteneur
	done
	echo ""

}

drop() {
	echo "Suppression des conteneurs ..."
	docker rm -f $(docker ps -a | grep $USER-$2 | awk '{print $1}')
	echo "Fin de la  suppression ..."
}

ansible(){
	echo ""
  	ANSIBLE_DIR="AnsibleProject"
  	mkdir -p $ANSIBLE_DIR
  	echo "all:" > $ANSIBLE_DIR/00_inventory.yml
	echo "  vars:" >> $ANSIBLE_DIR/00_inventory.yml
    echo "    ansible_python_interpreter: /usr/bin/python3" >> $ANSIBLE_DIR/00_inventory.yml
  echo "  hosts:" >> $ANSIBLE_DIR/00_inventory.yml
  for conteneur in $(docker ps -a | grep $USER-$2 | awk '{print $1}');do      
    docker inspect -f '    {{.NetworkSettings.IPAddress }}:' $conteneur >> $ANSIBLE_DIR/00_inventory.yml
  done
  mkdir -p $ANSIBLE_DIR/host_vars
  mkdir -p $ANSIBLE_DIR/group_vars
	echo ""
}


if [ "$1" == "--create" ];then
	create

elif [ "$1" == "--infos" ];then
	infos

elif [ "$1" == "--drop" ];then
	drop

elif [ "$1" == "--ansible" ];then
	ansible
fi
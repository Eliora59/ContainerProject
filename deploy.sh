#!/bin/bash

help() {
echo "

Options :
		- --create : lancer des conteneurs

		- --drop : supprimer les conteneurs créer par le deploy.sh
	
		- --infos : caractéristiques des conteneurs (ip, nom, user...)

		- --ansible : déploiement arborescence ansible

"
}

create() {
	nb_machine=1
	[ "$1" != "" ] && nb_machine=$1
	min=1
	max=0
	idmax=`docker ps -a --format '{{ .Names}}' | awk -F "-" -v user="$USER" '$0 ~ user"-centos" {print $3}' | sort -r |head -1`
	min=$(($idmax + 1))
	max=$(($idmax + $nb_machine))

	for i in $(seq $min $max);do
    	docker run -tid --rm --privileged --name $USER-centos-$i -h $USER-centos-$i zeorus-centos /usr/sbin/init
		docker exec -ti $USER-centos-$i /bin/sh -c "useradd $USER"
		docker exec -ti $USER-centos-$i /bin/sh -c "mkdir  ${HOME}/.ssh && chmod 700 ${HOME}/.ssh && chown $USER:$USER $HOME/.ssh"
	docker cp $HOME/.ssh/id_rsa.pub $USER-centos-$i:$HOME/.ssh/authorized_keys
	docker exec -ti $USER-centos-$i /bin/sh -c "chmod 600 ${HOME}/.ssh/authorized_keys && chown $USER:$USER $HOME/.ssh/authorized_keys"
		docker exec -ti $USER-centos-$i /bin/sh -c "echo '$USER   ALL=(ALL) NOPASSWD: ALL'>>/etc/sudoers"
		docker exec -ti $USER-centos-$i /bin/sh -c "systemctl start sshd"
		echo "Conteneur $USER-centos-$i créé"
	done
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

drop() {
	echo "Suppression des conteneurs ..."
	docker rm -f $(docker ps -a | grep $USER-centos | awk '{print $1}')
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
  for conteneur in $(docker ps -a | grep $USER-centos | awk '{print $1}');do      
    docker inspect -f '    {{.NetworkSettings.IPAddress }}:' $conteneur >> $ANSIBLE_DIR/00_inventory.yml
  done
  mkdir -p $ANSIBLE_DIR/host_vars
  mkdir -p $ANSIBLE_DIR/group_vars
	echo ""
}


if [ "$1" == "--create" ];then
	create $2

elif [ "$1" == "--infos" ];then
	infos

elif [ "$1" == "--drop" ];then
	drop

elif [ "$1" == "--ansible" ];then
	ansible

elif [ "$1" == "" ];then
	help
fi
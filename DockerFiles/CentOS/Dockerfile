FROM centos:7
ENV container docker
ENV LC_ALL C

RUN dnf update -y && dnf install -y openssh-server net-tools

ENV init /lib/systemd/systemd
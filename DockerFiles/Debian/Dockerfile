FROM minimum2scp/systemd-buster
ENV container docker
ENV LC_ALL C

RUN apt-get update \
    && apt-get install -y --no-install-recommends systemd python3 sudo bash net-tools openssh-server openssh-client vim git\
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV init /lib/systemd/systemd

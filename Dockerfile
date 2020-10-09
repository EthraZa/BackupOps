FROM debian:stable-slim
LABEL maintainer="Allan Brazute <ethraza@gmail.com>"
LABEL description="BackupOps is your backup enabled toolbox Linux image."

EXPOSE 22
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update && apt-get -y install --no-install-recommends \
    busybox-static \
    ca-certificates \
    curl \
    fuse \
    ncat \
    openssh-server \
    p7zip \
    rsync \
    unison \
    zstd && \
    apt-get -y clean && \
    apt-get -y autoclean && \
    apt-get -y autoremove && \
    rm -rf /var/lib/apt/lists/* 

RUN groupadd -g 1000 sailor && \
    groupadd -g 500 core && \
    groupadd -g 233 docker && \
    useradd -m -u 1000 -s /bin/bash -c "Stevedore" -g sailor sailor -G adm,backup,core,disk,docker,mail,nogroup,operator,root,staff,sudo,tape,tty,users,www-data

RUN curl https://getcroc.schollz.com | bash

RUN curl https://rclone.org/install.sh | bash

RUN curl https://github.com/borgbackup/borg/releases/latest/download/borg-linux64 -L -o /usr/bin/borg && \
    chmod 755 /usr/bin/borg

RUN /bin/busybox --install

COPY ./entrypoint.sh /
ENTRYPOINT /entrypoint.sh

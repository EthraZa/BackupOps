FROM debian:stable-slim
LABEL maintainer="Allan Brazute <ethraza@gmail.com>"
LABEL description="BackupOps is your DevOps backup enabled toolbox Linux image."

EXPOSE 22
ARG DEBIAN_FRONTEND=noninteractive
ENV TERM=xterm-256color

RUN apt -y update && apt -y install --no-install-recommends \
    backupninja \
    busybox-static \
    ca-certificates \
    curl \
    duplicity \
    fuse \
    gnupg \
    ncat \
    openssh-server \
    p7zip \
    rdiff-backup \
    restic \
    rsnapshot \
    rsync \
    unison \
    zstd

RUN groupadd -g 1000 sailor && \
    groupadd -g 500 core && \
    groupadd -g 233 docker && \
    useradd -m -u 1000 -s /bin/bash -c "Stevedore" -g sailor sailor -G adm,backup,core,disk,docker,mail,nogroup,operator,root,staff,sudo,tape,tty,users,www-data

RUN curl https://getcroc.schollz.com | bash

RUN curl https://rclone.org/install.sh | bash

RUN curl https://github.com/borgbackup/borg/releases/latest/download/borg-linux64 -L -o /usr/bin/borg && \
    chmod 755 /usr/bin/borg

RUN curl -s https://kopia.io/signing-key | apt-key add - && \
    echo "deb http://packages.kopia.io/apt/ stable main" | tee /etc/apt/sources.list.d/kopia.list && \
    apt -y update && apt -y install --no-install-recommends kopia && \
    apt -y clean && \
    apt -y autoclean && \
    apt -y autoremove && \
    rm -rf /var/lib/apt/lists/*

RUN curl https://github.com/peak/s5cmd/releases/latest/download/s5cmd_1.3.0_Linux-64bit.tar.gz -L | tar -C /usr/bin/ -xzf - s5cmd

RUN /bin/busybox --install

COPY ./entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]

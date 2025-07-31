FROM debian:stable-slim
LABEL maintainer="Allan Brazute <ethraza@gmail.com>"
LABEL description="BackupOps is your DevOps backup enabled toolbox Linux image."

EXPOSE 22
ARG DEBIAN_FRONTEND=noninteractive
ENV TERM=xterm-256color

RUN apt -y update && apt -y install --no-install-recommends \
    7zip \
    backupninja \
    busybox-static \
    ca-certificates \
    curl \
    duplicity \
    fuse \
    gnupg \
    lz4 \
    lzma \
    mariadb-backup \
    mariadb-client \
    ncat \
    openssh-server \
    p7zip \
    pigz \
    rdiff-backup \
    restic \
    rsnapshot \
    rsync \
    unison \
    zarchive-tools \
    zip \
    zst \
    zstd

RUN groupadd -g 233 docker && \
    groupadd -g 500 core && \
    groupadd -g 999 mysql && \
    groupadd -g 1000 sailor && \
    useradd -m -u 1000 -s /bin/bash -c "Stevedore" -g sailor sailor -G adm,backup,core,disk,docker,mail,mysql,nogroup,operator,root,staff,sudo,tape,tty,users,www-data

RUN curl https://getcroc.schollz.com | bash

RUN curl https://rclone.org/install.sh | bash

RUN curl https://github.com/borgbackup/borg/releases/latest/download/borg-linux-glibc236 -L -o /usr/local/bin/borg && \
    chmod 755 /usr/local/bin/borg && \
    ln -s /usr/local/bin/borg /usr/local/bin/borgfs

RUN curl -s https://kopia.io/signing-key | apt-key add - && \
    echo "deb http://packages.kopia.io/apt/ stable main" | tee /etc/apt/sources.list.d/kopia.list && \
    curl -s https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | gpg --dearmor -o /etc/apt/keyrings/gierens.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | tee /etc/apt/sources.list.d/gierens.list && \
    chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list && \
    apt -y update && apt -y install --no-install-recommends kopia eza && \
    apt -y clean && \
    apt -y autoclean && \
    apt -y autoremove && \
    rm -rf /var/lib/apt/lists/*

RUN curl https://github.com/peak/s5cmd/releases/latest/download/s5cmd_2.3.0_Linux-64bit.tar.gz -L | tar -C /usr/bin/ -xzf - s5cmd

RUN /bin/busybox --install

COPY ./00-alias.sh /etc/profile.d/00-alias.sh
COPY ./entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]

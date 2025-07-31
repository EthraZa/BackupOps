# BackupOps
BackupOps is your backup enabled toolbox Linux image

GitHub: https://github.com/EthraZa/BackupOps
Docker Hub: https://hub.docker.com/r/ethraza/backupops

---
# Backup tools included
* [Backupninja](https://0xacab.org/liberate/backupninja) - Lightweight, extensible meta-backup system
* [Borg](https://www.borgbackup.org/) - Deduplicating archiver with compression and encryption
* [Croc](https://github.com/schollz/croc) - Easily and securely send things from one computer to another
* [Duplicity](http://duplicity.nongnu.org/) - Encrypted bandwidth-efficient backup using the rsync algorithm
* [Kopia](https://kopia.io/) - Encrypted, Deduplicated, and Compressed Data Backups Using Your Own Cloud Storage
* [Mariadb-backup](https://mariadb.com/docs/server/server-usage/backup-and-restore/mariadb-backup) - Formerly mariabackup, it's a tool provided by MariaDB for performing physical online backups of InnoDB, Aria and MyISAM tables. It was originally forked from Percona XtraBackup 2.3.8
* [Ncat](https://nmap.org/ncat/) - Feature-packed networking utility which reads and writes data across networks
* [Rclone](https://rclone.org/) - Syncs your files to cloud storage
* [Rdiff-backup](https://rdiff-backup.net/) - Reverse differential backup tool, over a network or locally
* [Restic](https://restic.net/) - A modern backup program that can back up your files
* [Rsnapshot](https://rsnapshot.org/) - A filesystem snapshot utility based on rsync
* [Rsync](https://rsync.samba.org/) - Utility that provides fast incremental file transfer
* [S5cmd](https://github.com/peak/s5cmd) - Parallel S3 and local filesystem execution tool
* [Unison](https://www.cis.upenn.edu/~bcpierce/unison/) - File-synchronization tool for OSX, Unix, and Windows


A nice mention that is not packed here and is not a backup tool per see, but may help you on your journey: [Syncthing](https://syncthing.net/) a continuous file synchronization program.


# Usage

**Running simple backup command lines**
1. Command line:
```
docker run -i --rm ethraza/backupops borg init --encryption=none
```

2. docker-compose.yml service:
```
command: ["borg", "init", "--encryption", "none"]
```


**Running backup scripts**
Bind mount docker-entrypoint.d directory with your script to be run at container's start

1. Command line:
```
docker run -i --rm -v /path/scripts:/docker-entrypoint.d ethraza/backupops
```

2. docker-compose.yml service:
```
volumes:
 - /mnt/storage/backup/scripts:/docker-entrypoint.d
```

If your backup routine is running in the background and you need to hold the container execution, set *BOPS_KEEP_RUNNING: "on"* environment variable will keep it running untill it receiver a stop command.


**Server container**
If it's a server container, you may add a script to launch your backup service to *docker-entrypoint.d* directory or command line. Or you just set *BOPS_SSH: "on"* environment variable to start the ssh server.

Set environment variables or bind mount volumes or directories with you backup configurations or ssh keys if needed.


**Cron like running on Swarm**
The [swarm-cronjob](https://crazymax.dev/swarm-cronjob/) is a cron like service that will get your backup containers jobs started on a time-based schedule.


---

> If you have two backup copies, you have one, if you have one, you have none.

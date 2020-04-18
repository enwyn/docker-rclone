FROM archlinux:latest
MAINTAINER tynor88 <tynor@hotmail.com>

# s6 environment settings
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2
ENV S6_KEEP_ENV=1

# global environment settings
ENV RCLONE_VERSION="current"
ENV RCLONE_ARCH="amd64"

RUN
# enable community packages
 echo [Community] >> /etc/pacman.conf
 echo Include = /etc/pacman.d/mirrorlist >> /etc/pacman.conf

# install packages
RUN \
 pacman -Sy --noconfirm archlinux-keyring && \
 pacman -Syu --noconfirm ca-certificates rclone && \
 pacman-db-upgrade && \
 update-ca-trust && \
 pacman -Scc --noconfirm

# create abc user
RUN \
	groupmod -g 1000 users && \
	useradd -u 911 -U -d /config -s /bin/false abc && \
	usermod -G users abc && \

# create some files / folders
	mkdir -p /config /app /defaults /data && \
	touch /var/lock/rclone.lock

# add local files
COPY root/ /

VOLUME ["/config"]

FROM buildpack-deps:lunar

RUN yes | env DEBIAN_FRONTEND=noninteractive unminimize \
    && \
    env DEBIAN_FRONTEND=noninteractive apt-get install -y \
        apt-utils \
        libnss3-tools \
        systemd \
    && \
    systemctl disable \
        apt-daily-upgrade.timer apt-daily.timer \
    && \
    curl -JLO "https://dl.filippo.io/mkcert/latest?for=linux/amd64" && \
    chmod +x mkcert-v*-linux-amd64 && \
    cp mkcert-v*-linux-amd64 /usr/local/bin/mkcert

RUN ln -fs /usr/share/zoneinfo/UTC /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

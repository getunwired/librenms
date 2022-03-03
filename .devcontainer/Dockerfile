ARG VARIANT=base
FROM mcr.microsoft.com/vscode/devcontainers/${VARIANT}:ubuntu


RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends acl curl composer \
    fping git graphviz imagemagick mariadb-client mariadb-server \
    mtr-tiny nginx-full nmap php7.4-cli php7.4-curl php7.4-fpm \
    php7.4-gd php7.4-gmp php7.4-json php7.4-mbstring php7.4-mysql \
    php7.4-snmp php7.4-xml php7.4-zip rrdtool snmp snmpd whois unzip \
    python3-pymysql python3-dotenv python3-redis python3-setuptools \
    python3-systemd python3-pip

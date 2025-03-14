# [Choice] Ubuntu version (use jammy or bionic on local arm64/Apple Silicon): jammy, focal, bionic
ARG VARIANT="jammy"
FROM buildpack-deps:${VARIANT}-curl

# Options for setup script
ARG INSTALL_ZSH="true"
ARG UPGRADE_PACKAGES="true"
ARG USERNAME=librenms
ARG USER_UID=1000
ARG USER_GID=$USER_UID
# Install needed packages and setup non-root user. Use a separate RUN statement to add your own dependencies.
COPY library-scripts/*.sh library-scripts/*.env /tmp/library-scripts/
RUN yes | unminimize 2>&1 \ 
    && bash /tmp/library-scripts/common-debian.sh "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" "${UPGRADE_PACKAGES}" "true" "true" \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts

# Install the required packages for LibreNMS
RUN apt-get update && apt-get install -y \
    acl \
    curl \
    fping \
    git \
    graphviz \
    imagemagick \
    mariadb-client \
    mariadb-server \
    mtr-tiny \
    nginx-full \
    nmap \
    rrdtool \
    snmp \
    snmpd \
    unzip \
    python3-pymysql \
    python3-dotenv \
    python3-redis \
    python3-setuptools \
    python3-psutil \
    python3-systemd \
    python3-pip \
    whois \
    traceroute \
    software-properties-common

# Add the PHP PPA (Ondřej Surý’s repository) to get access to the latest PHP versions
RUN add-apt-repository -y ppa:ondrej/php && apt-get update

# Install PHP 8.2 and required extensions
RUN apt-get install -y \
    php8.2-bcmath \
    php8.2-curl \
    php8.2-fpm \
    php8.2-gd \
    php8.2-intl \
    php8.2-mbstring \
    php8.2-mysql \
    php8.2-readline \
    php8.2-sockets \
    php8.2-tokenizer \
    php8.2-xml \
    php8.2-zip

# Clean up apt cache to reduce image size
RUN rm -rf /var/lib/apt/lists/*

# Install Composer globally (PHP package manager for managing PHP dependencies)
RUN curl -sS https://getcomposer.org/installer | php8.2 -- --install-dir=/usr/local/bin --filename=composer

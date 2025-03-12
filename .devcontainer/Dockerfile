# Use Ubuntu Jammy as the base image
FROM mcr.microsoft.com/devcontainers/base:jammy

# Set environment variables for user creation
ARG USERNAME="librenms"
ARG USER_UID=1001
ARG USER_GID=1001

# Install prerequisites
RUN apt-get update && apt-get install -y \
    acl \
    ca-certificates \
    curl \
    fping \
    git \
    gnupg \
    imagemagick \
    lsb-release \
    mysql-server \
    nmap \
    python3 \
    python3-dotenv \
    python3-pip \
    python3-psutil \
    python3-pymysql \
    python3-redis \
    python3-setuptools \
    python3-systemd \
    rrdtool \
    snmp \
    snmpd \
    software-properties-common \
    traceroute \
    unzip \
    whois \
    && rm -rf /var/lib/apt/lists/*

# Add the PHP PPA (Ondřej Surý’s repository)
RUN add-apt-repository -y ppa:ondrej/php && apt-get update

# Install PHP 8.2
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
    php8.2-zip \
    && rm -rf /var/lib/apt/lists/*

# Install Composer globally
RUN curl -sS https://getcomposer.org/installer | php8.2 -- --install-dir=/usr/local/bin --filename=composer

# Verify installations
RUN php -v && composer --version && python3 --version && pip3 --version

# Create the user and group
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME

# Grant the librenms user sudo privileges
RUN echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# Set the default user to 'librenms'
USER $USERNAME

# Set the working directory
WORKDIR /opt/librenms
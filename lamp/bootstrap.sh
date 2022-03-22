#!/usr/bin/env bash

# Use single quotes instead of double quotes to make it work with special-character passwords
PASSWORD='root'
PROJECTFOLDER='public'

# create project folder
sudo mkdir "/var/www/${PROJECTFOLDER}"

# update / upgrade
sudo apt-get update
sudo apt-get -y upgrade

# install Apache 2.5 and PHP 7.4
sudo apt-get install -y apache2
sudo apt-add-repository -y ppa:ondrej/php
sudo apt -y update
sudo apt-get install -y php7.4 libapache2-mod-php7.4 php7.4-common php7.4-cli php7.4-gd php7.4-curl php7.4-intl php7.4-mbstring php7.4-bcmath php7.4-imap php7.4-xml php7.4-zip

# install mysql and give password to installer
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $PASSWORD"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $PASSWORD"
sudo apt-get install -y mysql-server
sudo apt-get install -y php7.4-mysql

# install phpmyadmin and give password(s) to installer
# just visit http://your_server_ip/phpmyadmin after installation
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2"
sudo apt-get -y install phpmyadmin

# setup hosts file
VHOST=$(cat <<EOF
<VirtualHost *:80>
    DocumentRoot "/var/www/${PROJECTFOLDER}"
    <Directory "/var/www/${PROJECTFOLDER}">
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF
)
echo "${VHOST}" > /etc/apache2/sites-available/000-default.conf

# enable mod_rewrite
sudo a2enmod rewrite

# restart apache
service apache2 restart

# install git
sudo apt-get -y install git

# install Composer
curl -s https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

# install VIM
sudo apt-get -y install vim

# Install Docker CE
sudo apt-get remove -y docker docker-engine docker.io
sudo apt install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker
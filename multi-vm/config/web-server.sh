#!/bin/bash

# Install Apache2
sudo apt-get install -y apache2
sudo service apache2 restart

# Creating Symbolic links
rm -rf /var/www/html
ln -s /vagrant /var/www/html

# Install PHP
sudo apt-add-repository -y ppa:ondrej/php
sudo apt-get -y update
sudo apt-get install -y php7.4 libapache2-mod-php7.4 php7.4-common php7.4-cli php7.4-curl php7.4-intl php7.4-mbstring php7.4-imap php7.4-xml php7.4-zip php7.4-mysql php7.4-xdebug

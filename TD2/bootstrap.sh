#! /usr/bin/env bash

DBHOST=localhost
DBNAME=dbname
DBUSER=dbuser

# You should change the password for your own configuration.
DBPASSWD=userpass
# Passwords should come from environment variables !
# Do not put such secrets in version controlled repository (e.g., Git)
DBROOTPASS="8k!+5vD?#Q[-(dYU%f"

sudo apt-add-repository ppa:ondrej/php
#sudo apt-add-repository ppa:ondrej/apache2
sudo apt-get update
sudo apt-get upgrade

# install mysql
apt-get -y install mysql-server mysql-client

debconf-set-selections <<< "mysql-server mysql-server/root_password password $DBROOTPASS"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $DBROOTPASS"

# Grant access to normal user to dedicated db from outside localhost
mysql -uroot -p$DBROOTPASS -e "CREATE DATABASE $DBNAME"
mysql -uroot -p$DBROOTPASS -e "grant all privileges on $DBNAME.* to '$DBUSER'@'%' identified by '$DBPASSWD'"

# Activate the following configuration with caution, just only if you really need it.
# Root access to the db server from outside localhost is bad practice.
# mysql -uroot -p$DBROOTPASS -e "grant all privileges on *.* to 'root'@'_gateway' identified by '$DBROOTPASS'"

cd /vagrant

# update mysql conf file to allow remote access to the database
sudo sed -i "s/.*bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf

# then restart the mysql server
sudo service mysql restart

# install php and apache2
apt-get -y install php7.4 apache2 libapache2-mod-php7.4 php7.4-mcrypt php7.4-cgi php7.4-cli php7.4-curl php7.4-common \
  php7.4-gd php7.4-mysql php7.4-gettext

sudo a2enmod rewrite

sed -i "s/AllowOverride None/AllowOverride All/g" /etc/apache2/apache2.conf

sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.4/apache2/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.4/apache2/php.ini

# restart apache2
systemctl restart apache2

#!/bin/bash

#Import necessary libraries
set -e

#Define variables
MASTER_NODE_NAME="master"
SLAVE_NODE_NAME="slave"

#Create the Master node
vagrant up $MASTER_NODE_NAME

#Create the Slave node
vagrant up $SLAVE_NODE_NAME

#Create the altschool user on the Master node
sudo useradd -m -s /bin/bash altschool

#Grant the altschool user root privileges
sudo usermod -aG sudo altschool

#Enable SSH key-based authentication between the Master and Slave nodes
ssh-keygen -t rsa -b 4096 -C "altschool"

cat ~/.ssh/id_rsa.pub | ssh $SLAVE_NODE_NAME "cat >> ~/.ssh/authorized_keys"

#Copy the contents of the /mnt/altschool directory from the Master node to the /mnt/altschool/slave directory on the Slave node
ssh $SLAVE_NODE_NAME "sudo mkdir -p /mnt/altschool/slave"

ssh $SLAVE_NODE_NAME "sudo rsync -avz /mnt/altschool $SLAVE_NODE_NAME:/mnt/altschool/slave"

#Display an overview of the Linux process management on the Master node
ps aux

#Install the LAMP stack on both the Master and Slave nodes
sudo apt-get update

sudo apt-get install -y apache2 mysql-server php7.4 php7.4-mysql

Ensure Apache is running and set to start on boot on both nodes
sudo systemctl start apache2

sudo systemctl enable apache2

#Secure the MySQL installation on both nodes
sudo mysql_secure_installation

#Initialize MySQL with a default user and password on both nodes
sudo mysql -u root -p < /vagrant/init-mysql.sql

#Validate PHP functionality with Apache on both nodes
echo "<?php phpinfo(); ?>" > /var/www/html/info.php
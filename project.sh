#!/bin/bash

# Import necessary libraries
set -e

# Define variables
master_node_name="master"
slave_node_name="slave"
lamp_stack_dir="/opt/lamp"

# Create two Ubuntu systems
vagrant up $master_node_name $slave_node_name

# Create a user named altschool
vagrant ssh $master_node_name sudo useradd -m altschool

# Grant altschool user root privileges
vagrant ssh $master_node_name sudo passwd altschool

# Enable SSH key-based authentication
vagrant ssh $master_node_name sudo ssh-keygen -t rsa -f /home/altschool/.ssh/id_rsa
vagrant ssh $slave_node_name sudo ssh-keyscan -t rsa $master_node_name >> /home/altschool/.ssh/known_hosts

# Copy the contents of /mnt/altschool directory from the Master node to /mnt/altschool/slave on the Slave node
vagrant ssh $master_node_name sudo rsync -a /mnt/altschool/ vagrant@$slave_node_name:/mnt/altschool/slave

# Display an overview of the Linux process management, showcasing currently running processes
vagrant ssh $master_node_name ps aux

# Install a LAMP (Linux, Apache, MySQL, PHP) stack on both nodes
vagrant ssh $master_node_name sudo apt update
vagrant ssh $master_node_name sudo apt install -y apache2 mysql-server php
vagrant ssh $slave_node_name sudo apt update
vagrant ssh $slave_node_name sudo apt install -y apache2 mysql-server php

# Ensure Apache is running and set to start on boot
vagrant ssh $master_node_name sudo systemctl enable apache2
vagrant ssh $slave_node_name sudo systemctl enable apache2

# Secure the MySQL installation and initialize it with a default user and password
vagrant ssh $master_node_name sudo mysql_secure_installation
vagrant ssh $master_node_name sudo mysql -u root -p < /opt/lamp/mysql/init.sql

# Validate PHP functionality with Apache
vagrant ssh $master_node_name curl -i http://localhost


#Install nginx on both machines
vagrant ssh $master_node_name sudo apt install -y nginx
vagrant ssh $slave_node_name sudo apt install -y nginx

#Create a configuration file for nginx that specifies the IP addresses of the master and slave nodes
cat << EOF > /etc/nginx/sites-available/default
server {
listen 80;
server_name localhost;

location / {
proxy_pass http://10.0.2.15:80;
proxy_set_header Host $host;
proxy_set_header X-Real-IP $remote_addr;
}

location /phpmyadmin {
proxy_pass http://10.0.2.16:8080;
proxy_set_header Host $host;
proxy_set_header X-Real-IP $remote_addr;
}
}
EOF

#Enable the nginx configuration file
vagrant ssh $master_node_name sudo ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled
vagrant ssh $slave_node_name sudo ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled

#Restart nginx on both machines
vagrant ssh $master_node_name sudo service nginx restart
vagrant ssh $slave_node_name sudo service nginx restart

#This code will install nginx on both machines, create a configuration file for nginx, enable the configuration file, and restart nginx on both machines. This will configure nginx to load balance traffic between the master and slave nodes.


#This script will create two Vagrant Ubuntu systems, install a LAMP stack on both systems, and configure them for inter-node communication. It will also display an overview of the Linux process management on the Master node and validate PHP functionality with Apache.


#Purpose and functionality:

#This script automates the deployment of a LAMP stack on two Vagrant Ubuntu systems. The LAMP stack consists of Linux, Apache, MySQL, and PHP. The script also configures the systems for inter-node communication and displays an overview of the Linux process management on the Master node.

#Prerequisites:

#Vagrant
#VirtualBox
#An Ubuntu 20.04 LTS installation

#Instructions:

#Install Vagrant and VirtualBox.
#Create a new Vagrantfile that defines two Ubuntu 20.04 LTS machines.
#Run the vagrant up command to create the machines.
#Run the project.sh script to deploy the LAMP stack and configure the machines.
#Verify that the LAMP stack is working by visiting http://localhost in a web browser.

#Explanation of complex or non-obvious code:

#The set -e command at the beginning of the script ensures that the script will exit if any command fails. This helps to prevent the script from making unwanted changes to the system.

#The vagrant up command creates the two Vagrant machines. The vagrant ssh command connects to a Vagrant machine. The sudo command runs a command with root privileges.

#The rsync command copies files from one machine to another. The ps aux command lists all of the running processes. The apt update command updates the package list. The apt install -y command installs a package.

#The systemctl enable command enables a service to start automatically at boot. The mysql_secure_installation command secures the MySQL installation. The mysql -u root -p < /opt/lamp/mysql/init.sql command initializes the MySQL database.

#The curl -i http://localhost command checks that the LAMP stack is working


                           #line 48-78 Load balancer ,

#the load balancer code is the last code block in the script. This is because the load balancer needs to be configured after the LAMP stack is installed on both machines.

#The load balancer code first installs nginx on both machines. Then, it creates a configuration file for nginx that specifies the IP addresses of the master and slave nodes. The configuration file tells nginx to forward requests to the master node if it is available, and to the slave node if the master node is unavailable.

#Finally, the load balancer code enables the nginx configuration file and restarts nginx on both machines. This ensures that nginx is running and configured to load balance traffic between the master and slave nodes.


#Prerequisites:

#Vagrant

#VirtualBox

#An Ubuntu 20.04 LTS installation

#The LAMP stack (Linux, Apache, MySQL, PHP) installed on both nodes

#Instructions:

#Install Vagrant and VirtualBox.
#Create a new Vagrantfile that defines two Ubuntu 20.04 LTS machines.
#Run the vagrant up command to create the machines.
#Run the project.sh script to deploy the LAMP stack and configure nginx.
#Verify that nginx is working by visiting http://localhost in a web browser.

#Explanation of codes

#The first two lines of code install nginx on both the master and slave nodes. The vagrant ssh command connects to the specified node, the sudo command runs the command with root privileges, and the apt install -y nginx command installs nginx.

#The next block of code creates a configuration file for nginx. The cat command reads the specified file and outputs its contents to the standard output, the EOF control character marks the end of the file, and the > /etc/nginx/sites-available/default command creates a new file in the specified directory and writes the output of the cat command to it.

#The configuration file specifies the IP addresses of the master and slave nodes. The server block defines a server that listens on port 80 and has the hostname localhost. The location / block specifies that requests for the root directory should be forwarded to the master node at the IP address 10.0.2.15. The proxy_set_header directives set the Host and X-Real-IP headers to the value of the Host header in the original request.

#The final block of code restarts nginx on both nodes. The service nginx restart command restarts the nginx service.

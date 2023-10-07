#!/bin/bash

# Function to display messages with timestamps
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

# Function to copy files from Master to Slave using SSH key
copy_files_to_slave() {
    log "Copying files to Slave node..."
    scp -r -i /home/altschool/.ssh/id_rsa /mnt/altschool/* altschool@slave:/mnt/altschool/slave/
    log "Files copied to Slave node."
}

# Main script starts here

# Deploy Master and Slave nodes using Vagrant
log "Deploying Master and Slave nodes..."
vagrant up
log "Nodes deployed."

# Create user 'altschool' with root privileges on Master node
log "Creating altschool user and granting root privileges on Master node..."
vagrant ssh master -c "sudo adduser altschool --disabled-password --gecos ''"
vagrant ssh master -c "sudo usermod -aG sudo altschool"
log "User altschool created with root privileges."

# Enable SSH key-based authentication from Master to Slave
log "Setting up SSH key-based authentication from Master to Slave..."
vagrant ssh master -c "ssh-keygen -t rsa -N '' -f /home/altschool/.ssh/id_rsa"
copy_files_to_slave
log "SSH key-based authentication configured."

# Copy files to Slave node
copy_files_to_slave

# Display process overview on Master node
log "Process overview on Master node:"
vagrant ssh master -c "ps aux"

# Install LAMP stack on both nodes
log "Installing LAMP stack on nodes..."
vagrant ssh master -c "sudo apt-get update && sudo apt-get install -y apache2 mysql-server php libapache2-mod-php php-mysql"
vagrant ssh slave -c "sudo apt-get update && sudo apt-get install -y apache2 mysql-server php libapache2-mod-php php-mysql"
log "LAMP stack installed."

# Secure MySQL installation on both nodes
log "Securing MySQL installation..."
vagrant ssh master -c "sudo mysql_secure_installation"
vagrant ssh slave -c "sudo mysql_secure_installation"
log "MySQL installation secured."

# Validation: Create a PHP info file
log "Creating PHP info file..."
echo "<?php phpinfo(); ?>" | vagrant ssh master -c "sudo tee /var/www/html/info.php"
echo "<?php phpinfo(); ?>" | vagrant ssh slave -c "sudo tee /var/www/html/info.php"
log "PHP info file created."

log "Deployment completed."

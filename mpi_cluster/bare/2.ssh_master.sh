#!/bin/sh

# Install the SSH server
apt-get install -y openssh-server
# %1 is the IP address of the slave node
# and %2 its number in a set of nodes.
echo "$1    slave_$2" >> /etc/hosts
# Adding an MPI user to run MPI jobs
adduser --disabled-password --gecos "" mpiuser
echo "mpiuser:mpiuser" | chpasswd
# make mpiuser sudoer
usermod -aG sudo mpiuser
# Running the ssh service
service ssh start
# SSHPASS allor to pass the password to the ssh command
# without user interaction
apt-get install sshpass

# We use su -c "command" mpiuser
# to run the following commands form 
# root in behalf of mpiuser 

# Creationg the public and private keys
su -c "ssh-keygen -t rsa -N '' -f ~/.ssh/id_rsa" mpiuser
# Avoid checking if the remote host is reliable
su -c "echo 'StrictHostKeyChecking=no' >> ~/.ssh/config" mpiuser
# Sharing the public key with the remote slave
su -c "sshpass -p 'mpiuser' ssh-copy-id slave_$2" mpiuser
# Sharing the public key with myself
su -c "sshpass -p 'mpiuser' ssh-copy-id localhost" mpiuser


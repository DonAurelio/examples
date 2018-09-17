#!/bin/sh

echo "Adding the master $1 IP address to /etc/hosts on slave"
# %1 is the IP address of the master node
echo "$1    master" >> /etc/hosts

echo "Creating the mpiuser"
# Adding an MPI user to run MPI jobs
adduser --disabled-password --gecos "" mpiuser
echo "mpiuser:mpiuser" | chpasswd
# make mpiuser sudoer
usermod -aG sudo mpiuser

echo "Setting up the ssh server"
# Install the SSH server
apt-get install -y openssh-server
# Running the ssh service
service ssh start

#!/bin/sh

# Install the SSH server
apt-get install -y openssh-server
# %1 is the IP address of the master node
echo "$1    master" >> /etc/hosts
# Adding an MPI user to run MPI jobs
adduser --disabled-password --gecos "" mpiuser
echo "mpiuser:mpiuser" | chpasswd
# make mpiuser sudoer
usermod -aG sudo mpiuser
# Running the ssh service
service ssh start

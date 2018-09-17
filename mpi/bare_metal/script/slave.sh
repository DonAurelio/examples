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

# Install the nfs server package
apt-get install -y nfs-common
# Creating the directory where the remote shared
# files will be visible
mkdir /home/mpiuser/cloud
# Mounting the remote directory on behalf of mpi user
su -c "echo 'mpiuser' | sudo -S mount -t nfs master:/home/mpiuser/cloud /home/mpiuser/cloud" mpiuser
# To mount the cloud remote folder every time the system starts
echo 'master:/home/mpiuser/cloud /home/mpiuser/cloud nfs' >> /etc/fstab

# Installing OpenMPI library
apt-get install -y make openmpi-bin openmpi-doc libopenmpi-dev
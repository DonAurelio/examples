#!/bin/sh

# Install the nfs server package
apt-get install -y nfs-common
# Creating the directory where the remote shared
# files will be visible
mkdir /home/mpiuser/cloud
# Mounting the remote directory on behalf of mpi user
su -c "echo 'mpiuser' | sudo -S mount -t nfs master:/home/mpiuser/cloud /home/mpiuser/cloud" mpiuser
# To mount the cloud remote folder every time the system starts
echo 'master:/home/mpiuser/cloud /home/mpiuser/cloud nfs' >> /etc/fstab

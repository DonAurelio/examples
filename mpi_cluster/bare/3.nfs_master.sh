#!/bin/sh

# Install the nfs server package
apt-get install -y nfs-kernel-server
# Creating the shared directory
mkdir /home/mpiuser/cloud
# Indicating the directory that will be shared
# sed -e '/home/mpiuser/cloud *(rw,sync,no_root_squash,no_subtree_check)' -ibak /etc/exports
echo '/home/mpiuser/cloud *(rw,sync,no_root_squash,no_subtree_check)' >> /etc/exports
# Exporting shared directories
exportfs -a
# Restarting the NFS server
service nfs-kernel-server restart

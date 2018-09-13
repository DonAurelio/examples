#!/bin/sh

# Initializing ssh service
/etc/init.d/ssh start -d

su - mpiuser

ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa
echo "StrictHostKeyChecking=no" >> ~/.ssh/config
sshpass -p 'mpiuser' ssh-copy-id slave #ip-address may also be used
sshpass -p 'mpiuser' ssh-copy-id localhost #ip-address may also be used

# To keep the container running
tail -F anything
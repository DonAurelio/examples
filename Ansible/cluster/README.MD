# Vagrant

Vagrant is a tool for building and managing virtual machines and **focus on automation**. Vagrant provides easy to configure, reproducible, and portable work environments built on top of industry-standard technology (Virtualbox, AWS, VMware).

Instead of building a virtual machine from scratch, which would be a slow and tedious process, Vagrant uses a base image to quickly clone a virtual machine. These base images are known as "boxes" in Vagrant

## Start cluster

```sh
vagrant up
```

## Get into a cluster node

```sh
vagrant ssh <master | slave_1 | slave_2>
```

## SSH Settings

```sh
vagrant ssh-config
```

```sh
Host master
  HostName 127.0.0.1
  User vagrant
  Port 2222
  ...
  IdentityFile /home/username/Desktop/vagrant/cluster/.vagrant/machines/master/virtualbox/private_key
  ...

Host slave_1
  HostName 127.0.0.1
  User vagrant
  Port 2200
  ...
  IdentityFile /home/username/Desktop/vagrant/cluster/.vagrant/machines/slave_1/virtualbox/private_key
  ...

Host slave_2
  HostName 127.0.0.1
  User vagrant
  Port 2201
  ...
  IdentityFile /home/username/Desktop/vagrant/cluster/.vagrant/machines/slave_2/virtualbox/private_key
  ...
```

# Ansible

Ansible is an **Agentless** Configuration Management Tool commonly used to automate three types of tasks: Provisioning, Configuration Manangement and Application Deployment. Ansible considers to kind of machines:

- Control Machines 
- Machines Under Configuration

Passwordless is required between a Control Machine and Machines Under Configuration because Ansible use SSH to perform the configuration of these machines. Control and Under Configuration Machines need python to be installed.

*Roles is a list of commands that will be executed on a target machine in a give order*

*Playbooks is to used to identify witch role would be applyed for each target machine.*

## Configure Ansible Machines

Information about machines ansible will be able to configure is provides by the user in the inventory file located at */etc/ansible/hosts*.

```sh
nano /etc/ansible/hosts
```

```sh
[vagrant_cluster]
master ansible_host=127.0.0.1 ansible_port=2222 ansible_user=vagrant ansible_ssh_private_key_file=/home/username/Desktop/vagrant/cluster/.vagrant/machines/master/virtualbox/private_key
slave_1 ansible_host=127.0.0.1 ansible_port=2200 ansible_user=vagrant ansible_ssh_private_key_file=/home/username/Desktop/vagrant/cluster/.vagrant/machines/slave_1/virtualbox/private_key
slave_2 ansible_host=127.0.0.1 ansible_port=2201 ansible_user=vagrant ansible_ssh_private_key_file=/home/username/Desktop/vagrant/cluster/.vagrant/machines/slave_2/virtualbox/private_key
```

## References 

- [Introduction to Vagrant](https://www.vagrantup.com/intro/index.html)
- [What is Ansible?](https://cloudacademy.com/blog/what-is-ansible/)
- [Provisioning Vagrant multi-machines with Ansible](https://medium.com/@megawan/provisioning-vagrant-multi-machines-with-ansible-32e1809816c5)
- [Ansible - A Beginner's Tutorial, Part 2
](https://www.youtube.com/watch?v=pRZA9ymZXn0)
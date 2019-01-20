# OpenMPI 3.1.2 Ansible Playbook

This playbook includes:

* OpenMPI install
* Passworldless setting
* NFS setting up (/home/mpiuser) by default

## Run

We use the connection module *paramiko* because *smart* fails somethimes. To run in vagrant machines use:

```sh
ansible-playbook playbook.yml -c paramiko 
```

For other machines, remote machines user will require to promnt the user paswword.

```sh
ansible-playbook playbook.yml -K -c paramiko 
```

## Todo

* SSH keys needs to be more secure.


## Issues

When the play was executed as first time, this error appears. When running the playbook again this does not happend anymore. 

```sh
TASK [basic : Running MPI ./configure (this can take a few seconds) ...] *****************************************************************************
fatal: [slave_2]: FAILED! => {"msg": "Timeout (12s) waiting for privilege escalation prompt: "}
fatal: [slave_1]: FAILED! => {"msg": "Timeout (12s) waiting for privilege escalation prompt: "}
	to retry, use: --limit @/home/aureavm/Desktop/ci/Ansible/playbooks/openmpi/playbook.retry
```
# Configuring a MPI Cluster Over a LAN (Manual scripts)

This folder contains configuration scripts to configure manually a LAN MPI Cluster of two machines. i.e., a single master and slave node.

## Requirements

* Master and Slave machines need communicated over the network.
* The scripts must be run as root user.

## Configuration Steps

The following configuration scripts have the following format: number.program_machine.sh. i.e., the 1.ssh_slave.sh is the first script you have to run to install the **ssh server** in a **slave node**. 2.ssh_master.sh is the second and so on.

**NOTE: Run the following scripts under the root user**

Setting up the ssh server in the Slave and Master nodes

```sh
sh 1.ssh_slave.sh <ip-master>
```

```sh
sh 1.ssh_master.sh <ip-slave> <slave-number>
```

```sh
sh 3.nfs_master.sh
```

```sh
sh 4.nfs_slave.sh
```

Install OpenMPI 


```sh
sh 5.openmpi_slave_master.sh
```

## To do 

- [ ] Allow the script to configure a single master machine with serveral slave nodes. **The clue can be in the 2.ssh_master.sh script**

## References

[Running an MPI Cluster within a LAN](http://mpitutorial.com/tutorials/running-an-mpi-cluster-within-a-lan/)
[How do I parse command line arguments in Bash?](https://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash)
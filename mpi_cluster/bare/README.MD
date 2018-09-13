# Configuring a MPI Cluster Over a LAN

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

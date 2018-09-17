#!/bin/bash


# Script settings
MPI_USER='mpiuser'
APT_GET_FLAGS='-qq -y'


function clean_log(){
  rm -f slave.log
}


function write_log(){
  local text=$1
  echo $text >> slave.log 
}


# Create and MPI user on the Master node
function create_mpi_user(){
  echo "Creating the MPI user $MPI_USER"
  write_log "Creating the MPI user $MPI_USER"

  # Adding an MPI user to run MPI jobs
  adduser --disabled-password --gecos "" $MPI_USER
  echo "$MPI_USER:$MPI_USER" | chpasswd
  # make mpiuser sudoer
  usermod -aG sudo $MPI_USER
  # Checking if user was added succesfully
  if [ $? -eq 0 ]
  then
    echo "User $MPI_USER created succesfully"
    write_log "User $MPI_USER created succesfully"
  else
    echo "Error: User $MPI_USER could not be created" >&2
    write_log "Error: User $MPI_USER could not be created"
  fi
}


# Install and start the ssh server
function setting_up_ssh(){
  echo "Setting up the ssh server"
  write_log "Setting up the ssh server"

  apt-get $APT_GET_FLAGS update

  if [ $? -eq 0 ]
  then
    echo "Souce list updated succesfully"
    write_log "Souce list updated succesfully"
  else
    echo "Error: Souce list could not be updated" >&2
    write_log "Error: Souce list could not be updated"
  fi

  # Install the SSH server
  apt-get $APT_GET_FLAGS install openssh-server
  # Running the ssh service
  service ssh start
  # Checking if user was added succesfully
  if [ $? -eq 0 ]
  then
    echo "SSH server running"
    write_log "SSH server running"
  else
    echo "Error: SSH could not be configured" >&2
    write_log "Error: SSH could not be configured"
  fi
}


function setting_up_nfs(){
  echo "Setting NFS Server"
  write_log "Setting NFS Server"

  apt-get $APT_GET_FLAGS update

  if [ $? -eq 0 ]
  then
    echo "Souce list updated succesfully"
    write_log "Souce list updated succesfully"
  else
    echo "Error: Souce list could not be updated" >&2
    write_log "Error: Souce list could not be updated"
  fi

  echo "Installing NFS Client"
  write_log "Installing NFS Client"
  # Install the nfs server package
  apt-get $APT_GET_FLAGS install nfs-common

  echo "Creating NFS shared directory /home/$MPI_USER/cloud"
  write_log "Installing NFS Client"
  # Creating the shared directory
  mkdir -p "/home/$MPI_USER/cloud"

  echo "Mounting remote  master:/home/mpiuser/cloud"
  write_log "Mounting remote  master:/home/mpiuser/cloud"

	# Mounting the remote directory on behalf of mpi user
	output = $(su -c "echo 'mpiuser' | sudo -S mount -t nfs master:/home/mpiuser/cloud /home/mpiuser/cloud" mpiuser)
	
  if [ -z $output ]
  then
    echo "/master:/home/mpiuser/cloud mounted"
    write_log "/master:/home/mpiuser/cloud mounted"
  else
    echo "Error: Remote /master:/home/mpiuser/cloud folder could be mounted" >&2
    write_log "Error: Remote /master:/home/mpiuser/cloud folder could be mounted"
  fi

  echo "Persist master:/home/mpiuser/cloud mounted directory"
  write_log "Persist master:/home/mpiuser/cloud mounted directory"
	# To mount the cloud remote folder every time the system starts
	echo 'master:/home/mpiuser/cloud /home/mpiuser/cloud nfs' >> /etc/fstab

}


function setting_up_mpi(){
  echo "Setting up MPI"
  # Installing OpenMPI library
  apt-get $APT_GET_FLAGS update

  if [ $? -eq 0 ]
  then
    echo "Souce list updated succesfully"
    write_log "Souce list updated succesfully"
  else
    echo "Error: Souce list could not be updated" >&2
    write_log "Error: Souce list could not be updated"
  fi

  apt-get $APT_GET_FLAGS install make openmpi-bin openmpi-doc libopenmpi-dev
  # Checking if mpi was installed succesfully
  if [ $? -eq 0 ]
  then
    echo "MPI was installed succesfully"
    write_log "MPI was installed succesfully"
  else
    echo "Error: MPI can not be installed properly" >&2
    write_log "MPI was installed succesfully"
  fi
}


function add_master(){
  echo "Adding a new host to /etc/hosts"
  write_log "Adding a new host to /etc/hosts"

  local host_address=${1}

  output = "$(grep $host_address /etc/hosts)"

  # If the host_address does not exits in /etc/hosts
  # we add it.
  if [ -n $output ]
  then
    echo "Adding the ${host_address} IP address with host name slave_$host_number to /etc/hosts on master"
    echo -e "$host_address\tmaster" >> /etc/hosts
    echo "Master host $host_address added succesfully"
    write_log "Master host $host_address added succesfully"
  else
    echo "Master host $host_address already exits" >&2
    write_log "Master hosts $host_address already exits"
    echo $output
    write_log $output
  fi
}


# Parsing argumnets
POSITIONAL=''
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -config)
    write_log $(date '+%Y-%m-%d %H:%M:%S')
    create_mpi_user
    setting_up_ssh
    setting_up_nfs
    setting_up_mpi
    shift # past argument
    shift # past value
    ;;
    -add_master)
    HOST_IP="$2"
    add_master $HOST_IP
    shift # past argument
    shift # past value
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    echo "The $POSITIONAL arguments is not a valid argument"
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters


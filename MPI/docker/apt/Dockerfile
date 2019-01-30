FROM ubuntu:18.04

LABEL maintaainer="Aurelio Vivas <aa.vivas@uniandes.edu.co>"

# Performing all installs as root user
RUN apt-get update

RUN apt-get install -y \
	nano \
	# To access ifconfig
	net-tools \
	# Optional packages
	make \
	git \
	# OpenMPI Packages
	openmpi-bin \
	openmpi-doc \
	libopenmpi-dev \
	# Install also openssh-client
	openssh-server \
	# sshpass is a utility designed for running ssh 
	# using the mode referred to as "keyboard-interactive" 
	# password authentication, but in non-interactive mode.
	sshpass \
	# To be able to use sudo with a given user
	sudo

# Creating a user for run MPI applications
RUN adduser --disabled-password --gecos "" mpiuser

# Changing mpiuser password user:passwd
RUN echo "mpiuser:mpiuser" | chpasswd

# Make mpiuser sudoer
RUN usermod -aG sudo mpiuser

# Seting up working directory
WORKDIR /usr/src/app

# Copy the project into the container current workdir
# COPY . .

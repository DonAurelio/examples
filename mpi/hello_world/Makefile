COMPILER = mpicc
TARGET  = hello_world
EXT = .c

# Total of processes:
# Launch N processes in all computer cluster
N = 4

# Processes per node:
# Lauch NP processes on every node 
# specified on the host_file
NP = 8

# The files on which the computers that will perform 
# the parallel work are specified
HOST_FILE = host_file

# mpirun flags
MPIRUN_FLAGS = -v --allow-run-as-root
MPIRUN_FLAGS= --mca btl_tcp_if_include eno1  -np 16 --hostfile host_file
# MPIRUN_FLAGS = -v --allow-run-as-root --mca btl ^openib

all: run_single_host

compile:
	${COMPILER} -o ${TARGET} ${TARGET}${EXT}

single_host: compile
	mpirun ${MPIRUN_FLAGS} ./${TARGET}

multi_host: compile
	mpirun ${MPIRUN_FLAGS} ./${TARGET}

clean:
	rm -f ${TARGET}

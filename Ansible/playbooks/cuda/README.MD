# CUDA Ansible Playbook

This playbook includes:

* nvidia-driver-410
* nvidia-dirver-390
* cuda toolkit 10 (it supported since nvidia-driver-410)

## Run

```sh
ansible-playbook playbook.yml
```

## Todo

* The script does not place the LD_LIBRARY_PATH in the environment. This can lead some mistakes while using cuda. 

```sh
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda-10.0/lib64
```


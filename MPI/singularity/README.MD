# Singularity Containers Usage

Creating (build) a container image from a definition file. The **.sif** (singulairty Image Format) image generated is inmutable, that is, it can not be modified. That's because this format is inteded to be sherable or ready to be reproducible in another linux environment (Workstation, HPC Cluster, etc). 

**In a nutshell:** When you package your container like this is because it is ready to be shared or reproducible in another linux environment. 

```sh
sudo singularity build hello.sif hello.def
```

When the bootstraping process ends the container will execute automatically the **%test** section.




```sh
sudo singularity build --notest hello.sif hello.def
```

# References

[Singularity Definition File Sections](http://singularity.lbl.gov/archive/docs/v2-3/bootstrap-image)
#!/bin/sh

# Initializing ssh service
/etc/init.d/ssh start -d

# To keep the container running
tail -F anything
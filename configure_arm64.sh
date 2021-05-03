#!/bin/bash

apt update
apt-get install -y libibnetdisc-dev

echo 'PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/home/mpiuser/.openmpi/bin"' > /etc/environment
echo 'LD_LIBRARY_PATH="/lib:/usr/lib:/usr/local/lib:/home/.openmpi/lib/"' >> /etc/environment

adduser --disabled-password --gecos "" mpiuser
usermod -aG sudo mpiuser
sudo -i -u mpiuser bash << EOF
echo "Enter mpiuser"
export PATH=/bin:/usr/bin:/usr/local/bin:/sbin:/usr/sbin

wget https://www.open-mpi.org/software/ompi/v1.8/downloads/openmpi-1.8.1.tar.gz 
tar -xzf openmpi-1.8.1.tar.gz && cd openmpi-1.8.1
./configure --prefix="/users/mpiuser/.openmpi"
make && make install

ssh-keygen -t rsa -N "" -f /${USER}/.ssh/id_rsa
cp ~/.ssh/id_rsa.pub ~/.ssh/authorized_keys

EOF
echo "Exit mpiuser"

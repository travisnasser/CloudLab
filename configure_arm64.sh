#!/bin/bash

apt update
apt-get install -y libibnetdisc-dev

echo 'PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/home/mpiuser/.openmpi/bin"' > /etc/environment
echo 'LD_LIBRARY_PATH="/lib:/usr/lib:/usr/local/lib:/home/.openmpi/lib/"' >> /etc/environment

# Create and configure mpiuser
adduser --disabled-password --gecos "" mpiuser
usermod -aG sudo mpiuser
sudo -i -u mpiuser bash << EOF
echo "Enter mpiuser"
export PATH=/bin:/usr/bin:/usr/local/bin:/sbin:/usr/sbin

# Configure OpenMPI
wget https://www.open-mpi.org/software/ompi/v1.8/downloads/openmpi-1.8.1.tar.gz 
tar -xzf openmpi-1.8.1.tar.gz && cd openmpi-1.8.1
./configure --prefix="/users/mpiuser/.openmpi"
make && make install

# Genererate ssh-keys
ssh-keygen -t rsa -N "" -f /${USER}/.ssh/id_rsa
cp ~/.ssh/id_rsa.pub ~/.ssh/authorized_keys

# Configure RDMA
apt-get install libibverbs1 ibverbs-utils librdmacm1 rdmacm-utils libcxgb3-1 libmlx4-1 libmthca1 libnes1 libibcommon1 ibverbs-providers
wget https://launchpad.net/ubuntu/+source/libibcommon/1.1.2-20090314-1ubuntu1/+build/5845211/+files/libibcommon1_1.1.2-20090314-1ubuntu1_arm64.deb
dpkg -i libibcommon1_1.1.2-20090314-1ubuntu1_arm64.deb

EOF
echo "Exit mpiuser"

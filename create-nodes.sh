#!/bin/sh -e
#  运行完这个脚本之后，只要在maas中看到这些机器的状态是New就行，至于别的错可以先忽略

OS_VARIANT=ubuntu22.04
POOL=testbed  # Remove 'pool' option below if not using a libvirt storage pool.

# It appears that on Jammy this is needed.
chmod o+x /home/ubuntu

# The Juju controller

VCPUS=2
RAM_SIZE_MB=4000
DISK_SIZE_GB_1=10
NAME=controller
MAC1="52:54:00:02:01:01"

virt-install \
  --os-variant $OS_VARIANT --arch x86_64 \
        --graphics vnc \
        --noautoconsole \
        --network network=internal,mac=$MAC1 \
        --name $NAME \
        --vcpus $VCPUS \
        --cpu host \
        --memory $RAM_SIZE_MB \
        --disk "$NAME"_1.img,size=$DISK_SIZE_GB_1,pool=$POOL \
        --pxe --boot network,hd --virt-type=kvm


# The usable MAAS nodes

VCPUS=4
RAM_SIZE_MB=8000
DISK_SIZE_GB_1=20
DISK_SIZE_GB_2=8

for NAME in node1 node2 node3 node4; do

        case $NAME in
        node1)
          MAC1="52:54:00:03:01:01"
          MAC2="52:54:00:03:01:02"
          ;;
        node2)
          MAC1="52:54:00:03:02:01"
          MAC2="52:54:00:03:02:02"
          ;;
        node3)
          MAC1="52:54:00:03:03:01"
          MAC2="52:54:00:03:03:02"
          ;;
        node4)
          MAC1="52:54:00:03:04:01"
          MAC2="52:54:00:03:04:02"
          ;;
        esac

        #may hit bug 20-maas-02-dhcp-unconfigured-ifaces
        virt-install \
          --os-variant $OS_VARIANT --arch x86_64 \
                --graphics vnc \
                --noautoconsole \
                --network network=internal,mac=$MAC1 \
                --network network=external,mac=$MAC2 \
                --name $NAME \
                --vcpus $VCPUS \
                --cpu host \
                --memory $RAM_SIZE_MB \
                --disk "$NAME"_1.img,size=$DISK_SIZE_GB_1,pool=$POOL \
                --disk "$NAME"_2.img,size=$DISK_SIZE_GB_2,pool=$POOL \
                --pxe --boot network,hd --virt-type=kvm

done

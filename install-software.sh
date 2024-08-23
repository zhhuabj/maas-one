#!/bin/sh -e

# The `uvt-simplestreams-libvirt` command provides the
# release for the MAAS host.

cd
sudo apt update
sudo apt full-upgrade -y
sudo apt install -y uvtool virtinst
# sudo ss -ntp | grep -E "$(dig +short cloud-images.ubuntu.com | tr '\n' '|')"
gg sudo uvt-simplestreams-libvirt --verbose sync release=jammy arch=amd64
sudo uvt-simplestreams-libvirt query
sudo snap install juju --classic

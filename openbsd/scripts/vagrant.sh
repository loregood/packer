#!/bin/sh
#
# Setup stuff for Vagrant and OpenBSD.
# User: vagrant is created during installation from the Packer .json file.

set -e

## Make a homedir for user vagrant with it's insecure public SSH key
## A new keypair will be generated on first boot
## https://github.com/hashicorp/vagrant/tree/master/keys
/bin/mkdir -p /home/vagrant/.ssh
/bin/cat <<EOT >/home/vagrant/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key
EOT
/sbin/chown -R vagrant /home/vagrant/.ssh
/bin/chmod -R go-rwsx /home/vagrant/.ssh

## Install doas.conf(5) for user: vagrant - so we can use doas(1)
echo "permit nopass keepenv vagrant" >> /etc/doas.conf

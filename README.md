# Building OS box images with Packer
This repository builds various machine images from OS ISO release install CD's -- using HashiCorp Packer and Vagrant.


### Requirements
You need the following free and open source software installed:

  * [Packer](https://www.packer.io)
  * [Vagrant](https://www.vagrantup.com)

If you want to acually use the Packer build Vagrant box image, you also need:

  * [VirtualBox](https://www.virtualbox.org)

Other platforms could be suported, using another [Packer Builder](https://www.packer.io/docs/builders/index.html).

I recommend Sun's err Oracle's... VirtualBox for local development, since it's free and it works on Windows, Mac and Linux.

Using Vagrant to "control" how the Virtual Machine is configured in VirtualBox is a very nice way to live. :-)


### Installation
When the above is installed, clone this git repository to a local directory, from your terminal:

    $ git clone https://github.com/loregood/packer

Currently I have only OpenBSD machine images, but FreeBSD is comming soon.


### Usage
Read the README.md in each OS folder for more information.

    $ cd openbsd
    $ less README.md

If you are new to Vagrant, you should checkout the [Vagrant documentation](https://www.vagrantup.com/docs/).

If you want to make changes to the Packer build process, checkout the [Packer documentation](https://www.packer.io/docs/index.html).

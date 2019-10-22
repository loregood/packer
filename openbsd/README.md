# Build an OpenBSD Vagrant box image with Packer
This repository builds Vagrant box images from an OpenBSD ISO release installs -- using HashiCorp Packer and Vagrant.

If your new to OpenBSD they have a really good [FAQ](https://www.openbsd.org/faq/index.html). But you should really read the [man](https://man.openbsd.org/man8/intro.8) pages.


### Requirements
You need the following free and open source software installed:

  * [Packer](https://www.packer.io)
  * [Vagrant](https://www.vagrantup.com)

If you want to acually use the Packer build Vagrant box image, you also need:

  * [VirtualBox](https://www.virtualbox.org)


### Installation
When the above is installed, clone this git repository to a local directory, from your terminal:

    $ git clone https://github.com/loregood/packer
    $ cd openbsd

The git repo should something like the files and directories below (there might be more versions):

    $ tree
    ├── README.md
    ├── Vagrantfile.template
    ├── 6.3/
    │   └── openbsd.json
    ├── 6.4/
    │   └── openbsd.json
    ├── 6.5/
    │   └── openbsd.json
    └── scripts/
        ├── minimize.sh
        ├── postinstall.sh
        └── vagrant.sh


### Usage
If you are in a hurry, jump to the "How-to build a Vagrant box image", but I would recommend to read the sections about the "Packer files" below first.


#### Packer files
Each version of OpenBSD has it's own directory (6.3, 6.4 and so on), so you can easily build the OpenBSD box image version you want.

The openbsd.json file is used by Packer to build a **very** minimal Vagrant box image using the Vagrantfile.template from the root directory using a standard OpenBSD release installation CD (which it will fetch from the Internet).

##### Packer variables section
You have to edit the openbsd.json "variables": section ("version":, "iso": and "checksum":) when adding new OpenBSD versions. Below is an example for verison 6.4 (this is already done in the various version directories):

    "variables": {
      "version": "6.4",
      "iso": "install64.iso",
      "checksum": "81833b79e23dc0f961ac5fb34484bca66386deb3181ddb8236870fa4f488cdd2"
    }

And DON'T TRUST ME! Verify the checksum (install64.iso) yourself from the official site: https://ftp.openbsd.org/pub/OpenBSD/6.4/amd64/SHA256.sig

Or even better, use [signify(1)](https://man.openbsd.org/signify) if you already have a running OpenBSD installation.

I use Cloudflare's mirror to fetch the installX.iso since they are globally very well connected, and delivers the ISO in under 4 seconds. You can changed it to a [local mirror](https://www.openbsd.org/ftp.html), if you want. Please don't ever use the official site for fetching installs!

    "mirror": "https://cloudflare.cdn.openbsd.org/pub/OpenBSD"


##### Packer provisioners section
I create a very minimal configured OpenBSD box image on purpose, but with all the [File Sets](https://www.openbsd.org/faq/faq4.html#FilesNeeded) installed.

You should keep the box image changes to a minimum, so you can reuse the same image to create many differnt OpenBSD installations. Use your Vagrantfile to setup the VM afterwards, or a provisioning tool (like Ansible, Chef, Puppet, Salt or..?). Don't use Packer to create specific OpenBSD installations!

The scripts below are used to provision the box image. See the "scripts": section under "provisioners":

  - [vagrant.sh](scripts/vagrant.sh)           # Creates the vagrant user and doas.conf settings
  - [postinstall.sh](scripts/postinstall.sh)   # Use Cloudflare instead of Fastly in /etc/installurl
  - [minimize.sh](scripts/minimize.sh)         # Zero out all partions for a minimal box image size

You can add more configuration to [postinstall.sh](scripts/postinstall.sh) script if you want, but you probably shouldn't.

minimize.sh should always run last - it does take a long time (about 2 1/2 minut on a SSD), but saves around 20% on the final box image size. You can remove it if you have a spinning disk or prefer speed over size - the box image will build around twice as fast (3 vs 5 1/2 minuts). Keep in mind, that this is a full OS installation with fetching the install ISO, configuring and installing the OS - and creating a box image for much faster installations afterwards (around ~35 seconds for a new OS installation -- ready to use!).

##### Packer builders section
If you want to change the answers during the OpenBSD installation, you have to edit the "boot_command": under "builders":

    "boot_command": [
      "S<enter>",
      "cat <<EOF >>install.conf<enter>",
      "Choose your keyboard layout = us<enter>",
      "System hostname = openbsd<enter>",
      "Password for root = vagrant<enter>",
      "Do you expect to run the X Window System = no<enter>",
      "Setup a user = vagrant<enter>",
      "Password for user = vagrant<enter>",
      "Allow root ssh login = yes<enter>",
      "What timezone are you in = UTC<enter>",
      "Location of sets = cd<enter>",
      "Directory does not contain SHA256.sig. Continue without verification = yes<enter>",
      "EOF<enter>",
      "install -af install.conf && reboot<enter>"
    ]

Don't change "Allow root ssh login" to "no" - or the build will fail! Make these kind af changed later in the Vagrantfile, or with proper provisioning tools.

You might want to change keyboard layout and timezone? But I would also recommend to configure that later.

You can change the the parameters below if your system is really old, or slow. If you have old spinning disk, you might want to increase "boot_wait": to "30s" or more (if you have a fast SSD, you can change it to "15s"). Disk allocation is using "thin provisioning"/"sparse volume", so don't worry about the size (unless you fill it up afterwards) - it helps OpenBSD chooose sane partions sizes:

    "boot_wait": "20s",
    "disk_size": 19140,
    "vboxmanage": [
      [ "modifyvm", "{{.Name}}", "--memory", "1024" ],
      [ "modifyvm", "{{.Name}}", "--cpus", "1" ]
    ]


### How-to build a Vagrant box image
First decide which version of OpenBSD you want. If you want OpenBSD 6.4 then:

    $ cd 6.4
    $ packer build openbsd.json

This will download the official OpenBSD ISO file to a ./packer_cache directory, automatically verify it's signature and install OpenBSD (hands off)!

  Wait until the build is completly finished, the last entry should be something like:

    ==> Builds finished. The artifacts of successful builds are:
    --> virtualbox-iso: 'virtualbox' provider box: OpenBSD-6.4_amd64

When the ISO is downloaded Packer will start building the Vagrant box image from the openbsd.json file using the downloaded ISO. It will run any script from "scripts": section, and use the Vagrantfile.template (special configuration for Vagrant + OpenBSD) to build the Vagrant box image. When it's done it will add the box image to Vagrant ~/.vagrant.d on your host OS.

Creating the box image takes time, but you only have to do that once (for each release). Then you can reuse the box image in multiple differnt Vagrantfiles.

The OpenBSD Vagrant box image should be around 350 (6.3) to 450 MB (6.6) -- for a full OpenBSD amd64 installation!


### Using your new Vagrant box image
When you want to use your new box image, create a new directory for your project, and a [Vagrantfile](https://www.vagrantup.com/docs/vagrantfile/).

A very simple `Vagrantfile` using OpenBSD 6.4 (without the '$ cat Vagrantfile' part):

    $ cat Vagrantfile

    Vagrant.configure("2") do |config|
      ## The config.vm.box name is the configured Packer box image from the openbsd.json file
      config.vm.box = "OpenBSD-6.4_amd64"
    end

To start and stop the Virtual Machine:

    $ vagrant up       # Boots the VM with VirtualBox with the specifications from the Vagrantfile
    $ vagrant halt     # Halts the VM in VirtualBox, but keeps the changes you have made
    $ vagrant up       # Boots the VM back up again, from where you left. And so on...

To completly remove the Virtual Machine from VirtualBox, when you are all done:

    $ vagrant destory  # Removes the VM from VirtualBox and all your changes!
    $ vagrant up       # Builds a fresh installation again from scratch


#### Manage Vagrant boxes
List all your Vagrant boxes (located in ~/.vagrant.d):

    $ vagrant box list

Delete a specific Vagrant box image:

    $ vagrant box remove OpenBSD-6.4_amd64

Use Packer again to build a new box image if you regret (see: "How-to build a Vagrant box image" above).

# Installation and Configuration

- [Installation and Configuration](#installation-and-configuration)
  - [Operating System](#operating-system)
  - [OS Installation](#os-installation)
    - [Disk partitioning](#disk-partitioning)
    - [Network Configuration](#network-configuration)
    - [System update](#system-update)
    - [Nvidia configuration](#nvidia-configuration)
    - [SSH Server](#ssh-server)
    - [Done](#done)
  - [User Management](#user-management)
    - [Creating a new user](#creating-a-new-user)
    - [The root user and the admins](#the-root-user-and-the-admins)
  - [Disk management](#disk-management)
  - [The 2 2TB HDDS configuration](#the-2-2tb-hdds-configuration)

This guide explains how the system was installed and configured the way it is now. It serves as a guideline for (maybe) next installations/updates and contains explanations on why is the system configured as it is.

## Operating System

The operating system we chose is the [OpenSuse Leap](https://www.opensuse.org/). The reasons why were:

1. It is remarkably stable. We never had any problem with it.
2. Nvidia actively maintains a repository with the latest drivers (with CUDA support). This is very important so we can have the latest tech and acceleration possible!
3. All the software is close to the most recent version. Ubuntu, for example, has a repository with dated software, which can cause conflics and dependency problems.

## OS Installation

OpenSuse can be downloaded as a DVD image that does not require a connection to the internet during installation, and makes it faster to install (no need to download every package). During the installation, select the server option to install the minimum packages required (no GUI or high-level tooling).

### Disk partitioning

This computer has a 500Gb NVMe SSD, which a high-speed low-latency disk, which is directly connected on the motherboard. Because of this, we chose to partition it as follows:

- 500Mb for the boot `/boot/efi` partition. The recommended is 100Mb to 250Mb but we chose to make it a bit larger, just in case.
- 150Gb for the root partition `/`. This partition will contain the system-wide programs and configuration. Because all applications will be maintained by the sysadmin, we can keep this lightweight.
- 300Gb (the rest) for the `/home` partition. This partition will contain all the user data. We chose to put it on this small partition, but it is recommended for each user to maintain it as light as possible. Because the user will install its programs/python/pytorch/tensorflow/etc... in here, it is beneficial to have this in this ssh. But be careful (otherwise, we can implement quotas for each user). The users can optionally have extra space, which will be shown later on.

Tips:
1. Check the disk utilization with `df -h`. This will shown the available space and utilization of each partition and disk.
2. Quotas can be implemented in a user/group basis.
3. Users do not have to necessarily have their home in `/home`. The home folder can be specified elsewhere (for non-essential users).

### Network Configuration

The server has a static IP configuration, given by the UA STICS, which allows the server to be acessed everywhere. This is the guide to configure the networking of the computer.

Write the following in the `/etc/sysconfig/network/ifcfg-eth0`. This configuration sets the correct static IP and the university gateway. 

```
NAME=''
BOOTPROTO='static'
ONBOOT='yes'
IPADDR='193.137.172.109/24'
MTU='1500'
STARTMODE='auto'
GATEWAY=193.137.172.254
```

Now we need to configure the routes, which are in the file `/etc/sysconfig/network/ifroutes-eth0`:

```
default		193.137.172.254
```

Tips:
1. The ethernet devices can be different from `eth0`. If so, check the correct device with `ip addr` or `ip link`.
2. If the ethernet device of down, activate it with `ip link set eth0 up`.
3. Check if the ethernet is correctly working with `ping google.pt` or `ping 1.1.1.1`.


In addition to the `eth0`, there is also a secondary ethernet interface named `eth1`. This interface is intended for operations that require low latency and therefore a physical connection is recommended. For instance, to run CARLA server on DeepLar and CARLA client on the personal computer. The network configuration is the following:

```
NAME='eth1'
BOOTPROTO='static'
ONBOOT='yes'
IPADDR='193.137.171.109/24'
MTU='1500'
STARTMODE='auto'
GATEWAY=193.137.171.254   
```

and the route is the following:

```
default 	193.137.171.254
```



### System update

Now that we have internet, we can update our system to the latest version. Run the command:

```
sudo zypper update
```

### Nvidia configuration

Now, we just need to install the Nvidia drivers. Follow the guide in [here](https://en.opensuse.org/SDB:NVIDIA_drivers). After the installation, reboot the PC and check if all the graphics show with:

```
nvidia-smi
```

Now, you may have noticed that the graphics cards are very, **very** hot! This is because they do not manage their temperature without the driving loaded. To load it all the times, nvidia has a simple daemon that does exactly that. Run it with `sudo nvidia-persistenced`. To load it at boot, we are required to add a script to the `systemd` system, in `/etc/systemd/system/nvidia-persistenced.service`.

```
[Unit]
Description=Nvidia Persistenced Daemon
Wants=syslog.target

[Service]
Type=forking
PIDFile=/var/run/nvidia-persistenced/nvidia-persistenced.pid
Restart=always
ExecStart=/usr/bin/nvidia-persistenced
ExecStopPost=/bin/rm -rf /var/run/nvidia-persistenced

[Install]
WantedBy=multi-user.target
```

Now, enable it in every boot with `sudo systemctl enable nvidia-persistenced`.

### SSH Server

Now, we are just missing the ssh server, to allow everyone to login remotely. Enable it with:

```
sudo systemctl enable sshd
```

### Done

Now, the system is operational! Next, we will add some users.



## User Management

### Creating a new user

We need new users in the computer. We prefer users to be a 3 letter word, like `tmr`, `bml` or `gmg`. The process of adding new users (let's say `abc`) is as follows:

1. Add a user user `sudo useradd --create-home abc`.
2. Add the group `video` so that it can use the graphics cards: `sudo usermod -aG video abc`. In the future, more groups could be added to add extra permissions.
3. Generate a new random password, which we will email to him/her: 

```
PASSWORD=$(openssl rand -base64 32)
echo "The password is '$PASSWORD'"
passwd abc # insert password here
```

4. Email the password to the user along with an explanation on how to change it and how to set the more secure public-private key authentication.

### The root user and the admins

...

## Disk management

This server has 8 disks: 4x1TB SSDs and 2x2TB HDDs. The disks are managed as two pools: one for cold-storage (the HDDs) and the other ones for hot storage (the SSDs).

These pools of disks are managed through the _Logical Volume Management_. For a detailed explanation, go [here](https://www.digitalocean.com/community/tutorials/an-introduction-to-lvm-concepts-terminology-and-operations).

First, to check where are the labels for the disks in the computer, use the program `lsblk`. This will output something similar to:

```
NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda           8:0    0 931.5G  0 disk 
└─sda1        8:1    0 931.5G  0 part 
sdb           8:16   0 931.5G  0 disk 
└─sdb1        8:17   0 931.5G  0 part 
sdc           8:32   0 931.5G  0 disk 
sdd           8:48   0 931.5G  0 disk 
sde           8:64   0   1.8T  0 disk 
└─sde1        8:65   0   1.8T  0 part 
sdf           8:80   0   1.8T  0 disk 
└─sdf1        8:81   0   1.8T  0 part 
nvme0n1     259:0    0 465.8G  0 disk 
├─nvme0n1p1 259:1    0   500M  0 part /boot/efi
├─nvme0n1p2 259:2    0 165.1G  0 part /
└─nvme0n1p3 259:3    0 300.2G  0 part /home
```

Now, we can see that the 4 SSDs are the `sda` to `sdd`, and the 2 HDDs are the `sde` and `sdf`.

## The 2 2TB HDDS configuration

1. Create the physical volumes on `/dev/sde` and `/dev/sdf`:

```
pvcreate /dev/sde /dev/sdf
```

2. Create the volume group called `cold-storage`:

```
vgcreate cold-storage /dev/sde /dev/sdf
```

Tip: We can check if everything is configured accordingly with the command `pvs` and `vgs`.

3. Finally, create (for example) a partition for datasets with 1.5Tb:

```
lvcreate -L 1500G -n datasets cold-storage
```

We can then format it as an ext4 partition and mount it under `/srv/storage/datasets`:

```
mkfs.ext4 /dev/cold-storage/datasets
mkdir -p /srv/storage/datasets
mount /dev/cold-storage/datasets /srv/storage/datasets
```
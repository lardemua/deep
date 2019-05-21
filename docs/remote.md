# Working remotely

- [Working remotely](#working-remotely)
  - [SSH](#ssh)
      - [Login through ssh keys instead of password](#login-through-ssh-keys-instead-of-password)
      - [Define custom hosts](#define-custom-hosts)
      - [Port Forwarding](#port-forwarding)
  - [SCP](#scp)
  - [rsync](#rsync)

## SSH

Secure Shell, or `SSH`, allows a communication between the local computer and a remote host. This connection is highly useful, as it can create remote shells, share files and create tcp tunnels between the two computers. The most basic command creates a remote shell:

```bash
ssh ${USER}@${HOST}
# Now we are executing commands on the other computer
```

The following are a bunch of commands that are useful when working on a remote shell:

#### Login through ssh keys instead of password

It is possible to login through a pair of cryptographic keys, instead of a password. This is more secure and more practical, because it is not required to enter the password at each new connection. To activate this, execute this commands:

```bash
# Generate the cryptographic key pair
ssh-keygen
# Copy the public key to the remote computer
ssh-copy-id user@remote
```

A more detailed explanation on this protocol can be found [here](https://www.ssh.com/ssh/#sec-Automate-with-SSH-keys-but-manage-them) and [here](https://www.hostinger.com/tutorials/ssh-tutorial-how-does-ssh-work)

#### Define custom hosts

It can be quite cumbersome to configure the same host repeatedly with the `ssh` command. To overcome this, it is possible to configure the hosts in the ssh configuration. To to so, add the lines to the `.ssh/config` for each host:

```
Host beast
    Hostname beastmaster64.web.dem.ua.pt
    Port     22
    User     my.self
```

#### Port Forwarding

The port forwarding makes it possible to share a port between the two computers, through the ssh connection. To do so, a `-L` option can be configured. For example, to open a connection to my-server and forward any connection to port 8080 to the port 80 of the server, the command should be:

```
ssh -L 8080:localhost:80 my-server
```

A more detailed explanation can be found in [here](https://www.ssh.com/ssh/tunneling/example).

## SCP

SCP allows files to be copied between different hosts. It uses ssh for data transfer and provides the same authentication and same level of security as ssh. For example, to copy the file `foobar.txt` from a remote host to the local host:

```bash
scp your_username@remotehost.edu:foobar.txt /some/local/directory
```

Further information about SCP can be found [here](http://www.hypexr.org/linux_scp_help.php).

## rsync


# Setup

- [Setup](#setup)
  - [Podman](#podman)
    - [Installation](#installation)
    - [Testing](#testing)
  - [Docker (alternative)](#docker-alternative)
  - [NVIDIA container runtime](#nvidia-container-runtime)
    - [Installation](#installation-1)
    - [Test the system](#test-the-system)
  - [FAQ](#faq)

## Podman

Podman and buildah are two tools that aim to be a substitute for docker, with regards to security and practicality. It is a RedHat project and it is also backed by companies such as Google. To see the disadvantages of docker and how podman solves some of it's issues, see [this](https://developers.redhat.com/blog/2019/02/21/podman-and-buildah-for-docker-users/) or [this](https://podman.io/talks/2018/10/01/talk-replace-docker-with-podman.html). The main advantage is that podman has the same api, so there should be no difference working with one tool or another.

### Installation

See how to install podman in [here](https://github.com/containers/libpod/blob/master/install.md). Or, in one line:

```
sudo add-apt-repository -y ppa:projectatomic/ppa
sudo apt install podman buildah skopeo
```

Add the `docker.io` registry to the configuration in file `/etc/containers/registries.conf` as described in [here](https://github.com/containers/libpod/blob/master/install.md#configuration-files)). Replace the line 12 to:

```
registries = ["docker.io"]
```

Thats it :ok_hand:.

### Testing

```bash
podman run --rm hello-world
```

## Docker (alternative)

__ATTENTION__: Do not use docker unless you have a kernel version older than `4.10` (check with `uname -r`).

Docker can be installed according to [here](https://docs.docker.com/install/linux/docker-ce/ubuntu/).

Do not forget to enable/start the docker daemon and add yourself to the docker group, before starting to use docker:

```bash
# Start the docker daemon
sudo systemctl start docker
# Enable the docker at startup
sudo systemctl enable docker
# Add myself to the docker group
sudo usermod -aG docker $USER
# Logoff/Login to take effect
```

Finally, test if everything is working with:

```bash
docker run --rm hello-world
```

## NVIDIA container runtime

To use the drivers from inside the container, it is necessary to install the libnvidia container runtime.

### Installation

1. Install the nvidia-container-runtime. Instructions [here](https://nvidia.github.io/nvidia-container-runtime/):

```bash
# Add the libnvidia-container repository
DIST=$(. /etc/os-release; echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/libnvidia-container/gpgkey | \
  sudo apt-key add -
curl -s -L https://nvidia.github.io/libnvidia-container/$DIST/libnvidia-container.list | \
  sudo tee /etc/apt/sources.list.d/libnvidia-container.list
sudo apt-get update
# Install the libnvidia-container software
sudo apt install \
    libnvidia-container1 \
    libnvidia-container-runtime \
    nvidia-container-runtime
```

2. Install the nvidia-hook.json

```bash
cat <<EOF > /usr/share/containers/oci/hooks.d/oci-nvidia-hook.json
{
  "hook": "/usr/bin/nvidia-container-runtime-hook",
  "arguments": ["prestart"],
  "annotations": ["sandbox"],
  "stage": [ "prestart" ]
}
EOF
```

3. Configure the nvidia-container-runtime

```bash
cat <<EOF > /etc/nvidia-container-runtime/config.toml
disable-require = false

[nvidia-container-cli]
#root = "/run/nvidia/driver"
#path = "usr/bin/nvidia-container-cli"
environment = []
#debug = "/var/log/nvidia-container-runtime-hook.log"
#ldcache = "/etc/ld.so.cache"
load-kmods = true
no-cgroups = true
#user = "root:video"
ldconfig = "@/sbin/ldconfig.real"
EOF
```

4. Add the hook as default in my user configuration

```bash
cat <<EOF >> $HOME/.config/containers/libpod.conf
hooks_dir = [ "/usr/share/containers/oci/hooks.d" ]
EOF
```

### Test the system

```bash
podman run --rm nvidia/cuda nvidia-smi
```

## FAQ

> I have Docker but I want to copy-paste the examples.

Just run `alias podman=docker` to alias podman to docker.

> Docker containers does not have internet access.

This could be a problem related to forwarding configuration of the network bridge created by docker. Use the flag `--network=host` to solve the problem.


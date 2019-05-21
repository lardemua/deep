# Overview of Podman CLI

Let's begin by seeing all available commands `podman` has:

```bash
podman --help
```

The output, as for version `1.2.0`, is:

```
manage pods and images

Usage:
  podman [flags]
  podman [command]

Available Commands:
  attach      Attach to a running container
  build       Build an image using instructions from Dockerfiles
  commit      Create new image based on the changed container
  container   Manage Containers
  cp          Copy files/folders between a container and the local filesystem
  create      Create but do not start a container
  diff        Inspect changes on container's file systems
  events      show podman events
  exec        Run a process in a running container
  export      Export container's filesystem contents as a tar archive
  generate    Generated structured data
  healthcheck Manage Healthcheck
  help        Help about any command
  history     Show history of a specified image
  image       Manage images
  images      List images in local storage
  import      Import a tarball to create a filesystem image
  info        Display podman system information
  inspect     Display the configuration of a container or image
  kill        Kill one or more running containers with a specific signal
  load        Load an image from container archive
  login       Login to a container registry
  logout      Logout of a container registry
  logs        Fetch the logs of a container
  mount       Mount a working container's root filesystem
  pause       Pause all the processes in one or more containers
  play        Play a pod
  pod         Manage pods
  port        List port mappings or a specific mapping for the container
  ps          List containers
  pull        Pull an image from a registry
  push        Push an image to a specified destination
  restart     Restart one or more containers
  rm          Remove one or more containers
  rmi         Removes one or more images from local storage
  run         Run a command in a new container
  save        Save image to an archive
  search      Search registry for image
  start       Start one or more containers
  stats       Display a live stream of container resource usage statistics
  stop        Stop one or more containers
  system      Manage podman
  tag         Add an additional name to a local image
  top         Display the running processes of a container
  umount      Unmounts working container's root filesystem
  unpause     Unpause the processes in one or more containers
  varlink     Run varlink interface
  version     Display the Podman Version Information
  volume      Manage volumes
  wait        Block on one or more containers
```

Uau, that is a lot of commands!!! Let us begin with each command in a step by set way.

## Working with images

### Searching for an image

As discussed before, in order to run a container, it is required to first define the image which will be the blueprint for the image. Podman has a `search` command in order to find images in the registries.

For example, if we want to find the `ubuntu` image:

```
podman search ubuntu
```

This will provide a long list of images that match `ubuntu`. The first image, marked as official, looks promising: `docker.io/library/ubuntu`.

### Pulling the image

Now, in order to use the image, we need to download it, or, in container terms, `pull` it from the registry. This will ensure that the image is present in the host machine.

```
podman pull docker.io/library/ubuntu
```

### Listing images

What are the images present on the host? The `images` command lists all images on the host.

```
podman images
```

### Pushing a image

An image present in the host machine can be pushed to a registry with the `push` command, similarly to the `pull` command.

```
podman push ubuntu <registry>/<image>
```

## Working with containers

### Creating a new container

To create a new container, we can use the `run` command.

```
podman run ubuntu
```

What? Nothing happened? Yeah. The container started but because no command was specified, it immediately stopped. We can see the stopped container with the `podman ps -a` command.

Let us run again with a command now.

```bash
podman run ubuntu echo "I'm a container"
```

This time, the container outputs `I'm a container`, indicating that the `echo` actually run.

Now, we want to run a container has an interactive session:

```bash
podman run -it ubuntu
```

The `run` command is very powerful, and can be greatly customized by it's option flags. The most useful and known ones are:

* `--name`: sets the name of the container.
* `--rm`: remove the container after it has stopped.
* `-it`: attach a terminal to the container, in order to start an interactive container.
* `-v`: maps a directory from the host to the container. For example: `-v ~/workspace/package1:/workspace/package1`.
* `-p`: maps a port from the host to the container. For example: `-p 8080:80`.
* `-e`: define a environment variable inside the container.
* `-d`: run the container in background (detach from current terminal).
* `--cpus`: define the number of cpus available in the container.

### Listing running container

To list the running containers, use the command `ps`. If we instead want to see the stopped containers as well, add the `-a` flag.

```
podman ps
```

### Stop running container

To stop a running container, use the command `stop`. The id or the name of the container is required, which can be seen with the `ps` command.

```
podman stop <container>
```

### Removing a container

To delete a container, use the command `rm`. Deleting a container deletes all state that was created in the container.

```
podman rm <container>
```

### Commiting a container

To save the current container state as a image, use the `commit` command.

```
podman commit <container> <image>
```

## Building images with Dockerfile

Podman can build images with the Dockerfile specification (see [this](https://docs.docker.com/engine/reference/builder/)), using the `build` command.

```
podman build --tag <image> <Dockerfile>
```

NOTE: Based on [this tutoral](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-getting-started) from _Digital Ocean_.
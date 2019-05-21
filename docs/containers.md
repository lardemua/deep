# Containers

- [Containers](#containers)
  - [What are containers](#what-are-containers)
  - [Why we want to use containers](#why-we-want-to-use-containers)
  - [Components](#components)
    - [Images](#images)
    - [Containers](#containers-1)
  - [Further reading](#further-reading)

## What are containers

![containers](_images/containers.jpg ':size=400px')

Linux containers, in short, contain applications in a way that keep them isolated from the host that they run on. This is similar to applications running on virtual machines. They also allow applications to be packaged in *images* that contain the operating system, dependencies and configuration, so they are easy to deploy, distribute and develop.

![](https://www.redhat.com/cms/managed-files/what-is-a-container.png ':size=300px')

## Why we want to use containers

* Containers provide a similar isolation to virtual machines, but require much less overhead, which improves performance.
* Containers are GPU-friendly.
* Containers allow applications to be portable between systems.
* Each developer/admin has full control of the container.
* Containers allow easy management of resources, such as cpu quotas, memory and visible GPU devices.
* Containers cannot tamper the underlying host system they run on.

> In a nutshell: portability, configurability, and isolation

## Components

As an overview, the container environment are made of 2 main components: 

* Containers
* Images

### Images

A container image is the template containing the files and the configuration that creates a container. Images, in this scope, are layered, so they are based on other images, with added files and configuration. For example, if we want to deploy a python application (for example, a flask service), we can start our image from the `python:3.7` images, which is based on the `ubuntu:18.04` image. This is essential for the deduplication of files and improves performance. Also, we only require to build the last layer of the whole layer that is our application, which reduces size and improves the image building times.

To build a new image, the steps are defined in a file called `Dockerfile`, in a imperative syntax. This files has several commands such as `RUN`, to run a command inside the building container, `ENV` to set environment variables, `COPY` to copy files from the host to the container image and `CMD` to define the command which is run when the container is started.

The image files are defines by the OCI-spec, which means that a container build by someone can be shared and distributed easily, and can run on my computer without modification. This led to the creation of registries, such as [DockerHub](https://hub.docker.com/), which contains a large set of images, such as base images, like `ubuntu` and `fedora`, runtime images, such as `ruby` and `python` and application images, such as databases like `mariadb`.

### Containers

A container is the runnable instance defined by an image. Containers can be created, started, stopped and deleted, in a simple manner, using the docker CLI. The containers are by default ephemeral, which means that when a container is removed, any changes made during its that are not preserved. However, it is possible to preserve the container state through snapshotting, that preserved the state in a new image.

The containers processes just like a normal process in the host machine, but the isolation is ensured by the linux, using namespaces and cgroups (a recent feature of the linux kernel). From inside, the container appears as a isolated environment, and the user has total control inside the container space. From outside, the container runs as an unprivileged user and has only access to the resources that are defined by its creation. The container runtime, however, allows resources to be mapped from and to the container, such as network, storage or graphic cards.

## Further reading

* [Opensource.com: What are linux containers](https://opensource.com/resources/what-are-linux-containers)
* [Open Container Iniciative](https://www.opencontainers.org)
* [RedHat: What are linux containers](https://www.redhat.com/en/topics/containers)
* [Docker: What are docker containers](https://www.docker.com/resources/what-container)
* [Podman and Buildah for docker users](https://developers.redhat.com/blog/2019/02/21/podman-and-buildah-for-docker-users/)
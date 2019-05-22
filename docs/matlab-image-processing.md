# Processing Images with MATLAB

- [Processing Images with MATLAB](#processing-images-with-matlab)
  - [Overview](#overview)
  - [Define the image](#define-the-image)
  - [Dockerfile](#dockerfile)
  - [Building the image](#building-the-image)
  - [Running](#running)
  - [Getting the results](#getting-the-results)
    - [Reading the logs](#reading-the-logs)
    - [Copy the results from the container to the host machine](#copy-the-results-from-the-container-to-the-host-machine)
  - [Advantages](#advantages)

## Overview

This the main objective is to run a matlab script based on a work made in computer vision classes (TP1-2018). This work performs a segmentation of a series of images with barcodes and qr-codes and reads the number in the barcodes. The main components that are required to run the whole work are:

* __The runtime__: in this work we used octave instead of matlab just because it is available on most linux distributions and is an open-source project.
* __The scripts__: the collection of `*.m` scripts and functions required. They are all in the _src_ directory and the main entrypoint is the `main.m` file.
* __The dataset__: the collection of images that are being processed. The file `data.tar.xz` contains 3 datasets: the `seq320`, `seq410` and `seq515`.
* __The output__: the processed result is a _txt_ file that describes a set of parameters for each image on the dataset.

## Define the image

We now need to define how the image will be, in regards to the parameters and where are the files.

First, the files:

* The scripts will be in the directory `/workspace`.
* The data will be in the directory `/data`.
* The results will be in the directory `/results`.

Then, the parameters. The parameters will be passed as environment variables, which is a common technique in this field:

* `DATASET` will define where is the folder of the dataset. By default, it will be `/data/seq320`, the first dataset.
* `OUTPUT` will define where to save the results. By default, it will be `/results`.
* `SAVE_PROCESSED_IMAGES` will specify if we want to save debug images. By default, it will be `false`.

## Dockerfile

```dockerfile
# We are going to use fedora as the base image
FROM fedora:29

# Install all the dependencies required to run the application
RUN dnf install -y octave octave-image pstoedit transfig

# Configure the files in the image
# Copy the source files from src to /workspace
COPY src /workspace
# Extract the dataset to /data
ADD data.tar.xz /data
# Create a /results directory
RUN mkdir /results

# Define the default environment variables
ENV DATASET=/data/seq320
ENV OUTPUT=/results
ENV SAVE_PROCESSED_IMAGES=false

# Define the workdir as /workspace
# This will define the directory where the script will run
WORKDIR /workspace

# Define the default command: octave -W main.m
# NOTE: -W forces octave to run windowless
CMD ["octave", "-W", "main.m"]
```

## Building the image

Now, just build the image `image-processing` defined by the `Dockerfile`.

```
podman build -t image-processing .
```

Note that rerunning again is much faster because podman caches the intermediate commands

## Running

```
podman run image-processing
```

If we want to run the container for a different dataset, we can override the `DATASET` environment variable.

```
podman run -e DATASET=/data/seq515 image-processing
```

If we want the program to save the processed images, just override the `SAVE_PROCESSED_IMAGES` environment variable.

```
podman run -e DATASET=/data/seq510 -e SAVE_PROCESSED_IMAGES=true image-processing
```

Id we want the program to run in the background, we can detach it from the shell with the `-d` option.

```
podman run -d image-processing
```

## Getting the results

### Reading the logs

```
podman logs <container>
```

### Copy the results from the container to the host machine

```
mkdir results
podman cp <container>:/results results
```

## Advantages

Why is this approach better than just running the script on the host machine? Here are some reasons:

* We did not require to install any dependency on the host machine.
* It is easier to share the image and to deploy on other machine.
* Each run is deterministic and the results and logs are saved for each run.
* The image can be versioned, so the results are consistent and reproducible.

Of course, there are some disadvantages:

* It is not possible to use an graphical interface (at least, not easily).
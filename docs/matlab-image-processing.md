# Processing Images with MATLAB

- [Processing Images with MATLAB](#processing-images-with-matlab)
  - [Overview](#overview)
  - [Dockerfile](#dockerfile)
  - [Building the image](#building-the-image)
  - [Running](#running)
  - [Getting the results](#getting-the-results)
  - [Advantages](#advantages)

## Overview

## Dockerfile

```dockerfile
FROM fedora:29

RUN dnf install -y octave octave-image pstoedit transfig

COPY src /workspace
ADD data.tar.xz /data
RUN mkdir /results

ENV DATASET=/data/seq320
ENV OUTPUT=/results
ENV SAVE_PROCESSED_IMAGES=false

WORKDIR /workspace

CMD ["octave", "-W", "main.m"]
```

## Building the image

    podman build -t image-processing .

## Running

```
podman run image-processing
```

```
podman run -e DATASET=/data/seq515 image-processing
```

```
podman run -e DATASET=/data/seq510 -e SAVE_PROCESSED_IMAGES=true 
```

## Getting the results

## Advantages


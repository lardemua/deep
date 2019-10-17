# Flask Webapp

- [Flask Webapp](#flask-webapp)
  - [The flask application](#the-flask-application)
  - [The Dockerfile](#the-dockerfile)
  - [Build the image](#build-the-image)
  - [Run the webapp container](#run-the-webapp-container)
  - [Pushing the application to the registry](#pushing-the-application-to-the-registry)

In this hands on, we will create a simple [flask](http://flask.pocoo.org/) web application, using the _Dockerfile_ specification.

## The flask application

This flask application just serves a simple webpage on `localhost:4000`. It contains the hostname and the environment variable "\$NAME".

```py
from flask import Flask
import os
import socket

app = Flask(__name__)

@app.route("/")
def hello():
    html = "<h3>Hello {name}!</h3> <b>Hostname:</b> {hostname}<br/>"
    return html.format(name=os.getenv("NAME", "world"), hostname=socket.gethostname())

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=4000)
```

## The Dockerfile

The dockerfile to build this application's image is the following.

```dockerfile
FROM python:2.7-alpine
WORKDIR /app
ADD app.py /app
RUN pip install Flask
ENV NAME World
CMD ["python", "app.py"]
```

Each command has the following explanation:

- `FROM`: defines the base layer of the image, in this case, the `python:2.7` image, which can be found in [here](https://hub.docker.com/_/python). This is mandatory in every dockerfile and is required to be the first line. All further commands will add files or configuration to this base image
- `WORKDIR`: defines the default path on the container.
- `ADD`: copies files from the host to the container image.
- `RUN`: runs commands in the container image. In this case `pip` to install all dependencies.
- `ENV`: defines an environment variable that will be shown in the container. In this case, it will define "\$NAME" to be "World" by default. This can be overridden at the start of the container
- `CMD`: defines the default starting command when running the container. In this case, it will execute the `app.py` application. This can also be overriden when creating the container.

## Build the image

Now, we have to build the image using the Dockerfile we specified above. So, go to the directory where the `Dockerfile` is execute the `build command`. The `-t` flag defines the name of the image.

```
cd examples/flask-webapp

podman build -t webapp .
```

We can now verify that the image `webapp` is listed in the images available in the host.

```
podman images
```

## Run the webapp container

Now run the container with the `run` command. Again, the `-p` option is required to map the ports between the host/container.

```
podman run -p 4000:4000 webapp
```

Now, if you go to [localhost:4000](http://localhost:4000), you will se something like

    Hello World!
    Hostname: 47d4b8e1a3b5

The environment variables and the hostname can be customized as following

```
podman run -p 4000:4000 --hostname beautiful-app --env NAME=flask webapp
```

Now you will see this instead

    Hello flask!
    Hostname: beautiful-app

## Pushing the application to the registry

Now we will push the image to the registry, so it is publicly available and everyone can pull and run it. To do so, create an account in the dockerhub and login in the local machine using the `podman login docker.io`.

The, we have to tag the image to match the registry name and our username.

```
podman tag webapp docker.io/<user>/webapp
```

We can check that we have a new image `docker.io/<user>/webapp` with the `podman images` command. Now, we can push the application with the `push` command.

```
podman push docker.io/<user>/webapp
```

Now, your image is online like [mine](https://hub.docker.com/r/bernardomig/webapp)!

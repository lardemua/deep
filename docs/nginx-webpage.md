# Serve a webpage with nginx

Let's say we have a beautiful webpage written in html like the follow:

```html
<html>

    <head>
        <title>The most useful webpage</title>
    </head>

    <body>
        <h1>This is the nicest webpage I ever see.</h1>
    </body>

</html>
```

I would be nice to publish this website somewhere, so everybody can see this masterpiece! However, to serve a website, we need a http server. For it, we gonna use the awesome nginx web server.

## Searching for the nginx image

If we search the docker registry, through podman, we can find that there is a official `nginx` image:

```bash
podman search nginx
```

Alternatively, we can find the nginx image in the docker registry ([hub.docker.com](https://hub.docker.com/)) [here](https://hub.docker.com/_/nginx).

## Running a nginx container

Now, we can run the nginx container as follows:

```bash
podman run -d -p 8080:80 -v $PWD:/usr/share/nginx/html:ro --name nginx-webpage nginx
```

Now we can see the documentation in [localhost:8080](http://localhost:8080)

The flags used have the following explanation:

* `-d`: detach from the current shell, running as a daemon. This has two effects: first, if we close the shell, the container will continue running; second, the output of the container will not be shown. We can see the logs using the `podman logs nginx-webpage` command.
* `-p 8080:80`: map the host port 8080, to the port 80 in the container. The port 80 is the port used by nginx to listen to the http.
* `-v $PWD/docs:/usr/share/nginx/html:ro`: map the docs directory in the host to the directory `/usr/share/nginx/html` in the container. This is directory where nginx expects the static files to be. The `:ro` options ensures that the directory is read-only inside the container.
* `--name nginx-webpage`: gives the `nginx-webpage` name to the container.

## Print the logs

nginx prints useful logs about the requests made to the server, such as what files were request, at what time and from where they where requested. To print the logs of the container (create some request by refreshing the webpage first), use the `logs` command as follows:

```bash
podman logs nginx-webpage
```

## Stop/Start/Remove the container

When you are finished, stop the container with the `stop` command.

```
podman stop nginx-webpage
```

You can restart the container with the `start` command

```
podman start nginx-webpage
```

Finally, remove the container with the `rm`.

```
podman rm nginx-webpage
```

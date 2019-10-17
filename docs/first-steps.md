# First Steps

- [First Steps](#first-steps)
  - [Remote Connection](#remote-connection)
    - [SSH configuration](#ssh-configuration)
    - [Check the computer status](#check-the-computer-status)
  - [Miniconda](#miniconda)
    - [Instalation](#instalation)
    - [Create new tensorflow environment](#create-new-tensorflow-environment)
  - [Cloning this repo](#cloning-this-repo)
  - [Running and editing scripts (ol'way)](#running-and-editing-scripts-olway)
  - [Interactivity](#interactivity)
    - [IPython](#ipython)
    - [VSCode](#vscode)
    - [Jupyter](#jupyter)

## Remote Connection

Using remote computers means using remote connections. Remote connections, or `SSH` connections, allow us to interact with a computer to create terminals, transfer files, forward ports, and more.
The basic thing we do is to create remote shells, or terminals. To do so, use the command:

```sh
ssh user@deeplar.ml
```

It is expected to ask for the password, and them a shell should open in the remote computer. Now if we execute commands, we shall see a different response than in our host machine. For example:

```sh
who
# bml      :0           2019-10-17 10:48 (:0)
ls
# your directory content
hostname
# deep
```

### SSH configuration

Now it may seem easy to open new sessions all the time, but it can start to be cumbersome to type the password and the `user@deeplar.ml` each time we connect. We can optimize this a bit:

1. The authentication can be done though private keys, so we don't need to type the password in a authorized computer:
   ```sh
   # generate a new private key
   ssh-keygen
   # copy the public key to the remote computer
   ssh-copy-id user@deeplar.ml
   ```
2. We add the connection parameters in the `.ssh/config` file:
   ```
   Host deep
       Hostname deeplar.ml
       Port 22
       User user
   ```

### Check the computer status

In order to check the computer status, such as cpu and ram utilization, and the status of the nvidia gpgpus, we can a number of commands:

- To check GPGPU status, use the command `nvidia-smi`.
- To check the ram and cpu utilization, use the command `htop`.

## Miniconda

Like `virtualenv` and `pip`, conda is a package manager with a special focus on python. One of it's advantages is the system packages that it provides, for example, for cuda or gcc. Conda allow us to install packages and dependencies without root permissions, and to create separate environments to separate dependencies.

### Instalation

```sh
# download the latest miniconda
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
# install it
sh Miniconda3-latest-Linux-x86_64.sh
```

### Create new tensorflow environment

Conda is able to separate dependencies through environments. To create a new environment, with a new environment with the tensorflow distribution with cuda and python 3.6, use the command:

```
conda create -n tf python=3.6 tensorflow-gpu=1.14
```

Now, we can activate the new environment with

```
conda activate tf
```

If we forgot to install a package, just install the other dependencies with `conda install`:

```
conda install jupyter
```

## Cloning this repo

We prepared an example to illustrate this guide. Get the required files from this repository:

```sh
# clone the repo
git clone https://github.com/bernardomig/deep.git
# go to the examples directory
cd deep/examples/tensorflow/
# go to the first example
cd 01-cats-and-dogs
```

Install the conda dependencies required:

```
conda install jupyterlab numpy matplotlib pillow tqdm tabulate
```

## Running and editing scripts (ol'way)

Inside the first example there are two python scripts, one for training, `cats_and_dogs_train.py`, and other for inference, `cats_and_dogs_inference.py`.

We can see and edit these files by the _normal_ way, using the `vim`, or the `micro` program.

We can train the model by running:

```
python cats_and_dogs_train.py
```

TIP: before running the python script, please check if there is an available graphics card with `nvidia-smi` and force the script to use a free graphics card with `export CUDA_VISIBLE_DEVIDES=N`.


Now that the model is trained, we have to get some cats/dogs images to run the model against. So, download a few images and store them a folder on the host machine. Now, we have to transfer the files to the remote computer. To do so, use the `scp` command:

```
scp images/*.jpg deep:~/deep/examples/tensorflow/01-cats-and-dogs/images/
```

Now, run the `cats_and_dogs_inference.py` script to classify the images:

```
python cats_and_dogs_inference.py --model models/cats-and-dogs.h5 images/*.jpg
```

Ok, this is boring :unamused:... We need a better way to interact with the script.

## Interactivity

Python is an interactive language, why don't we use this advantage? We will explore two ways to do it.

### IPython

We can use the interactive interpreter `ipython`. Some of its advantages are:

- syntax highlighting,
- autocompletion,
- help with `?`,
- interpretation of shell commands with `!`.

### VSCode

VSCode support remote connections with the `Remote - SSH` connection.

To install vscode: `snap install --classic vscode`

### Jupyter

Jupyter is a interactive notebook interface. It is a server that runs on the remove machine and is accessed though a web browser.

To start the jupyter server (choose a different port):

```
jupyter lab --port 10000
```

Afterward, create a port forwarding rule in the ssh terminal using the flag:

```
-L 10000:localhost:10000
```

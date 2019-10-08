# Miniconda

- [Miniconda](#miniconda)
  - [1. Install](#1-install)
  - [2. Conda environments](#2-conda-environments)
  - [3. Further Reading](#3-further-reading)

> Package, dependency and environment management for any language---Python, R, Ruby, Lua, Scala, Java, JavaScript, C/ C++, FORTRAN
> -- <cite>Conda docs</cite>

Like `virtualenv` and `pip`, conda is a package manager with a special focus on python. One of it's advantages is the system packages that it provides, for example, for cuda or gcc.

## 1. Install

Download the latest `miniconda` instalation file.

```
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
```

Install it.

```
sh Miniconda3-latest-Linux-x86_64.sh
```

That's it.

## 2. Conda environments

Conda is able to manage multiple environments. To create a new environment with `python3.7` and tensorflow `1.13`:

```
conda create -n tf python=3.7 tensorflow-gpu=1.13
```

To select this environment:

```
conda activate tf
```

To install other packages:

```
conda install jupyter
```

## 3. Further Reading

- [Conda Docs](https://docs.conda.io/projects/conda/en/latest/index.html)
- [Conda Command Reference](https://docs.conda.io/projects/conda/en/latest/commands.html)

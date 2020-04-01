# My bash profile commands

Some functions in my `bash_profile` for developers `bash --version > 4.0`

[![Build Status](https://travis-ci.org/brunomacedo/.eiskaffee.svg?branch=master)](https://travis-ci.org/brunomacedo/.eiskaffee)


# Instructions

## Install automatically

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/brunomacedo/.eiskaffee/master/tools/install.sh)"
```

and then restart your terminal. =D


## Update

```bash
eiskaffee update
```


## Where to put it (manually)?

**1.** Clone this **repository** in your root user folder.

**2.** Create a file called `.bash_profile` in your root user folder.
After that you should insert this line `source ~/.eiskrc` on it.

**3.** Now copy `.eiskrc` file on this repository into `tools/.eiskrc` in your root user folder.

**4.** Restart your terminal. =D


## Uninstall

```bash
eiskaffee uninstall
```

and then restart your terminal. =D


# Anotations

## Kubernetes Completion

```bash
kubectl completion bash > ~/kubectl-completion.bash
```

### `~/.bashrc`

```bash
source ~/kubectl-completion.bash
```

# vagrant-k3s

## Setup

```console
$ vagrant up
```

## Usage

### Master Node

```console
$ vagrant ssh master or ssh vagrant@localhost -p40010 or ssh vagrant@192.168.123.120
$ vagrant@localhost's password: vagrant
$ sudo -i
$ (default:default) root@master:~#
```

### Worker Node

```console
$ vagrant ssh worker1~3 or ssh vagrant@localhost -p40101~40103 or ssh vagrant@192.168.123.121~123
$ vagrant@localhost's password: vagrant
```

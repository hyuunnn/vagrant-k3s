# vagrant-k3s

## Setup

```console
$ vagrant up
```

## Usage

### Master Node

```console
$ vagrant ssh master or ssh vagrant@localhost -p60010 or ssh vagrant@192.168.123.120
```

### Worker Node

```console
$ vagrant ssh worker1~3 or ssh vagrant@localhost -p60101~60103 or ssh vagrant@192.168.123.121~123
```

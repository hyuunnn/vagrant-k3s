# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  N = 3

  config.vm.define "master" do |cfg|
    cfg.vm.box = "generic/ubuntu2204"
    cfg.vm.host_name = "master"

    cfg.vm.provider "virtualbox" do |v|
      v.name = "master"
      v.cpus = 2
      v.memory = 4096
      v.customize ["modifyvm", :id, "--groups", "/k3s"]
    end
    
    cfg.vm.network "private_network", ip: "192.168.123.120"
    cfg.vm.network "forwarded_port", guest: 22, host: 40010, auto_correct: true, id: "ssh"
    cfg.vm.synced_folder ".", "/vagrant", disabled: false
    cfg.vm.provision "shell", path: "config.sh", args: N
    cfg.vm.provision "shell", path: "master_node.sh"
  end

  (1..N).each do |i|
    config.vm.define "worker#{i}" do |cfg|
      cfg.vm.box = "generic/ubuntu2204"
      cfg.vm.host_name = "worker#{i}"

      cfg.vm.provider "virtualbox" do |v|
        v.name = "worker#{i}"
        v.cpus = 1
        v.memory = 2048
        v.customize ["modifyvm", :id, "--groups", "/k3s"]
      end

      cfg.vm.network "private_network", ip: "192.168.123.12#{i}"
      cfg.vm.network "forwarded_port", guest: 22, host: "4010#{i}", auto_correct: true, id: "ssh"
      cfg.vm.synced_folder ".", "/vagrant", disabled: false
      cfg.vm.provision "shell", path: "config.sh", args: N
      cfg.vm.provision "shell", path: "worker_node.sh"
    end
  end
end

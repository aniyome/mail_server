# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.provider :virtualbox do |provider, override|
    override.vm.box = "centos7.2"

    override.vm.hostname = "local.mail.service.ne.jp"
    override.vm.network "private_network", ip: "192.168.33.55"

    config.vbguest.auto_update = true
  end

  config.vm.synced_folder ".", "/vagrant"
  config.vm.provision :shell, :path => "./provision/vm.sh"
end

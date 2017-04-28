# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.provider :virtualbox do |provider, override|
    override.vm.box = "centos/7"

    override.vm.hostname = "local.mail.service.ne.jp"
    override.vm.network "private_network", ip: "192.168.33.55"

    config.vbguest.auto_update = true

    # 自動でhostsをセットしてくれるvagrantのプラグインがインストールされているかチェック
    unless Vagrant.has_plugin?("vagrant-hostsupdater") then
      raise <<-EOS
vagrantのプラグイン"vagrant-hostsupdater"がインストールされていません。
"vagrant plugin install vagrant-hostsupdater"コマンドでインストールしてから
"vagrant up"コマンドを実行して下さい。
EOS
    end
    # VirtualBox GuestAdditionsの設定 (vagrant.plugin.vagrant-vbguest)
    if Vagrant.has_plugin?("vagrant-vbguest") then
      config.vbguest.auto_update = true
      require File.expand_path("../provision/vagrant-plugin/update-centos-kernel/plugin", __FILE__)
      config.vbguest.auto_update = true
    else
      raise <<-EOS
vagrantのプラグイン"vagrant-vbguest"がインストールされていません。
"vagrant plugin install vagrant-vbguest"コマンドでインストールしてから
"vagrant up"コマンドを実行して下さい。
EOS
    end
  end

  sync_type = "rsync"
  config.vm.synced_folder ".", "/vagrant",
    type: sync_type, owner: "vagrant", group: "vagrant"
  config.vm.provision :shell, :path => "./provision/vm.sh"
end

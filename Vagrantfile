# -*- mode: ruby -*-
# vi: set ft=ruby :

%w(vagrant-vbguest).each do |vp|
  unless Vagrant.has_plugin?(vp)
    puts "installing #{vp}"
    system "vagrant plugin install #{vp}"
  end
end

Vagrant.configure(2) do |config|
  config.vm.hostname = 'traineract'
  config.vm.box      = 'ubuntu/trusty64'

  config.vm.network "private_network", ip: "192.168.21.10"

  # Local. Artisanal. Virtual. Box.
  config.vm.provider :virtualbox do |vb, override|
    vb.cpus   = `sysctl -n hw.ncpu`.to_i
    vb.memory = "8192"
  end

  config.vm.provision "shell" do |s|
    s.path         = './provision'
    s.keep_color   = true
    s.name         = "traineract_provisioner"
    s.privileged   = true
  end
end

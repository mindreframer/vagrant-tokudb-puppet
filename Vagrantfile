# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  config.vm.box = "base"
  config.vm.network :hostonly, "192.168.33.10"

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "puppet/manifests"
    puppet.manifest_file  = "base.pp"
    puppet.module_path    = "puppet/modules"
  end
end
### GRANT ALL PRIVILEGES ON *.* TO 'roman'@'192.168.33.1'    IDENTIFIED BY 'dummy' WITH GRANT OPTION;
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.hostname = "mongodb-mms-agent-dev"
  config.vm.box = "chefprecise64"
  config.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_ubuntu-12.04_chef-provisionerless.box"

  config.omnibus.chef_version = :latest
  config.berkshelf.enabled = true

  config.vm.provision :chef_solo do |chef|
    chef.json = {
      vagrant: {}
    }
    chef.run_list = [
        "recipe[apt]",
        "recipe[mongodb-mms-agent::default]",
        "recipe[mongodb-mms-agent::backup]"
    ]
  end
end

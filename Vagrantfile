# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.hostname = "mongodb-mms-agent-dev"
  config.vm.box = "chefprecise64"
  config.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_ubuntu-12.04_chef-provisionerless.box"

  config.omnibus.chef_version = :latest
  config.berkshelf.enabled = true

  config.chef_zero.chef_repo_path = 'test/fixtures/'

  config.vm.provision :chef_client do |chef|
    chef.json = {
      vagrant: true, # required in order to detect vagrant usage in recipes.
      monitor: {
        master_address: 'localhost',
        environment_aware_search: false
      }
    }
    chef.encrypted_data_bag_secret_key_path = 'test/fixtures/encrypted_data_bag_secret'
    chef.run_list = [
        "recipe[mongodb-mms-agent::role]"
    ]
  end
end

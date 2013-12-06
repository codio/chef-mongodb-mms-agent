#
# Cookbook Name:: mongodb-mms-agent
# Recipe:: role
#

# Include a little sugar
include_recipe 'chef-sugar::default'


include_recipe 'base::default'

unless vagrant?
  # Sensu monitoring checks
  include_recipe 'base::monitor'
end

include_recipe 'mongodb-mms-agent::default'
include_recipe 'mongodb-mms-agent::backup'
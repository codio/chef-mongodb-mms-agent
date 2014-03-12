#
# Cookbook Name:: mongodb-mms-agent
# Recipe:: role
#

include_recipe 'base::default'
include_recipe 'base::monitor'

include_recipe 'mongodb-mms-agent::default'
include_recipe 'mongodb-mms-agent::backup'

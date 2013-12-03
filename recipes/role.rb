#
# Cookbook Name:: mongodb-mms-agent
# Recipe:: role
#

include_recipe 'monitor::master'
include_recipe 'base::default'
include_recipe 'mongodb-mms-agent::default'
include_recipe 'mongodb-mms-agent::backup'
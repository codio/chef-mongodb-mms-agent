#
# Cookbook Name:: mms_agent
# Recipe:: backup
#
# Installs and configures the MMS Backup agent.
#

include_recipe 'python'

# Load the MMS agent keys from the data bag `keys.mms_agent`.
begin
  data_bag = Chef::EncryptedDataBagItem.load('keys', 'mms_agent')
  node.default[:mms_agent][:api_key] = data_bag['api_key']
rescue
  log "Unable to find encrypted data bag: 'keys.mms_agent'" do
    level :warn
  end
end


# Create the system user and group.
group node[:mms_agent][:user]
user node[:mms_agent][:user] do
  gid node[:mms_agent][:group]
end


#
# Backup config and agent install.
#

directory '/usr/local/share/mms-agent/backup' do
  owner node[:mms_agent][:user]
  group node[:mms_agent][:group]
  recursive true
end

template 'backup.conf' do
  path '/usr/local/share/mms-agent/backup/local.config'
  owner node[:mms_agent][:user]
  group node[:mms_agent][:group]
  variables api_key: node[:mms_agent][:api_key]
end

cookbook_file '/usr/local/share/mms-agent/backup/agent' do
  source 'backup-agent'
  mode 0755
  owner node[:mms_agent][:user]
  group node[:mms_agent][:group]
end


#
# Create log directory
#

directory '/var/log/mms-agent' do
  owner node[:mms_agent][:user]
  group node[:mms_agent][:group]
end


#
# Upstart config.
#

service "mms-backup" do
  provider Chef::Provider::Service::Upstart
  supports :restart => true, :start => true, :stop => true
end

template "mms-backup.upstart.conf" do
  path "/etc/init/mms-backup.conf"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, "service[mms-backup]"
end

service "mms-backup" do
  action [:enable, :start]
end